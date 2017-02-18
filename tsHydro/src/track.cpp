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
  DATA_IARRAY(trackinfo);
  DATA_VECTOR(weights);
  DATA_VECTOR(priorHeight);
  DATA_VECTOR(priorSd);

  PARAMETER(logSigma);
  PARAMETER(logSigmaRW);
  PARAMETER(logitp);
  PARAMETER_VECTOR(u);

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

  Type sdObs=exp(logSigma);
  for(int t=0;t<noTracks;t++){
    vector<Type> sub=height.segment(trackinfo(t,0),trackinfo(t,2));
    vector<Type> subw=weights.segment(trackinfo(t,0),trackinfo(t,2));
    for(int i=0;i<trackinfo(t,2);i++){
      if(priorHeight.size()==1){
        if((sub(i)>(priorHeight(0)-Type(5)*priorSd(0))) && (sub(i)<(priorHeight(0)+Type(5)*priorSd(0)))){
          ans += nldens(sub(i),u(timeidx(trackinfo(t,0))-1),sdObs/sqrt(subw(i)),p);
        } 
      }else{
        ans += nldens(sub(i),u(timeidx(trackinfo(t,0))-1),sdObs/sqrt(subw(i)),p);
      }
    } 
  }

  return ans;
}
