#include <TMB.hpp>

template <class Type>
Type dt1(Type x){
  return Type(1.0)/M_PI/(Type(1.0)+x*x);
}

template <class Type>
Type ilogit(Type x){
  return Type(1.0)/(Type(1.0)+exp(-x));
}

template <class Type>
Type nldens(Type x, Type mu, Type sd, Type p){
  Type z=(x-mu)/sd;
  return -log(1.0/sd*((1.0-p)*dnorm(z,Type(0.0),Type(1.0),false)+p*dt1(z)));
}

template<class Type>
Type objective_function<Type>::operator() ()
{
  DATA_VECTOR(height);
  DATA_VECTOR(times);
  DATA_IVECTOR(timeidx);
  DATA_IVECTOR(newtimeidx);
  DATA_IVECTOR(group);
  DATA_IVECTOR(satid);
  DATA_IVECTOR(qfid);
  DATA_IARRAY(trackinfo);
  DATA_VECTOR(weights);
  DATA_VECTOR(priorHeight);
  DATA_VECTOR(priorSd);
  DATA_INTEGER(varPerTrack);
  DATA_INTEGER(varPerQuality);
  DATA_IVECTOR(trackidx);
  
  vector<Type> pred(height.size());
  pred.setZero();

  PARAMETER_VECTOR(logSigma);
  PARAMETER(logSigmaRW);
  PARAMETER(logitp);
  PARAMETER_VECTOR(u);
  PARAMETER_VECTOR(bias);

  vector<Type> biasvec(bias.size()+1);
  biasvec(0)=0;
  for(int i=1; i<biasvec.size();++i)biasvec(i)=bias(i-1);
    
  int timeSteps=times.size();
  int obsDim=height.size();
  int noTracks=trackinfo.dim[0];

  Type p=ilogit(logitp); 
  
  Type ans=0;

  if(priorHeight.size()==1){
    ans += -sum(dnorm(u, priorHeight(0), priorSd(0), true));
  }
 
  Type sdRW=exp(logSigmaRW);
  for(int i=1;i<timeSteps;i++){
    ans += -dnorm(u(i),u(i-1),sdRW*sqrt(times(i)-times(i-1)),true); 
  }

  vector<Type> sdObs=exp(logSigma);
  for(int t=0;t<noTracks;t++){
    vector<Type> sub=height.segment(trackinfo(t,0),trackinfo(t,2));
    vector<Type> subw=weights.segment(trackinfo(t,0),trackinfo(t,2));
    vector<int> subsatid=satid.segment(trackinfo(t,0),trackinfo(t,2));
    vector<int> subtrackid=trackidx.segment(trackinfo(t,0),trackinfo(t,2));
    vector<int> subqfid=qfid.segment(trackinfo(t,0),trackinfo(t,2));
    int idxVar;
    for(int i=0;i<trackinfo(t,2);i++){
      if(varPerTrack==1){idxVar=subtrackid(i);}else{idxVar=subsatid(i);}
      if(varPerQuality==1){idxVar=subqfid(i);}else{idxVar=subsatid(i);}      
      if(priorHeight.size()==1){
        if((sub(i)>(priorHeight(0)-Type(5)*priorSd(0))) && (sub(i)<(priorHeight(0)+Type(5)*priorSd(0)))){
          ans += nldens(sub(i),u(timeidx(trackinfo(t,0))-1)+biasvec(subsatid(i)),sdObs(idxVar)/sqrt(subw(i)),p);
        } 
      }else{
        ans += nldens(sub(i),u(timeidx(trackinfo(t,0))-1)+biasvec(subsatid(i)),sdObs(idxVar)/sqrt(subw(i)),p);
      }
      pred(trackinfo(t,0)+i)=u(timeidx(trackinfo(t,0))-1)+biasvec(subsatid(i));
    } 
  }

  Type aveH=sum(u)/u.size();
  ADREPORT(aveH);
  if(group.size()>0){
    int ngroup=group.maxCoeff()+1;
    vector<Type> groupAve(ngroup); groupAve.setZero();
    vector<Type> groupN(ngroup); groupAve.setZero();
    for(int i=0; i<newtimeidx.size(); ++i){
      groupAve(group(i))+=u(newtimeidx(i)-1);
      groupN(group(i))+=1;
    }
    groupAve/=groupN;
    ADREPORT(groupAve);
  }   
  REPORT(pred);
  return ans;
}
