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

  PARAMETER(logSigma);
  PARAMETER(logSigmaRW);
  PARAMETER(logitp);
  PARAMETER_VECTOR(u);

  int timeSteps=times.size();
  int obsDim=height.size();

  Type p=ilogit(logitp); 
  
  Type ans=0;
 
  Type sdRW=exp(logSigmaRW);
  for(int i=1;i<timeSteps;i++)
    ans += -dnorm(u(i),u(i-1),sdRW*sqrt(times(i)-times(i-1)),true); 

  Type sdObs=exp(logSigma);
  for(int i=0;i<obsDim;i++)
    ans += nldens(height(i),u(timeidx(i)-1),sdObs,p); 
  return ans;
}
