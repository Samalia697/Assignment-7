function [p] = LogPost7(rep,x,y,ind_2,ind_34,kid)

if(kid~=0)
    
    tau0   = x(1);
    tau1   = x(2);
    sigma = x(3);
    theta0 = x(4:37);
    theta1 = x(38:71);
    phi0=x(72);
    phi1=x(73);
    eta0=x(74:107);
    eta1=x(108:141);
    b00=x(142);
    b01=x(143);
    b10=x(144);
    b11=x(145);
    % Log-Prior
    log_prior = 0;
    % p(theta0|mu0,tau0)
    for ii = 1:length(theta0)
        mu0 = b00 + b01*ind_2(ii);
        theta0 = mu0 + eta0.*tau0;
       log_prior = log_prior - (0.5*((theta0(ii)-(mu0+(phi0*ind_2(ii))))/tau0)^2) - log(tau0);%Gelman's version
        
    end
    % p(theta1|mu1,tau1)
    for ii = 1:length(theta1)
        mu1 = b10 + b11*ind_2(ii);
        theta1 = mu1 + eta1.*tau1;
       log_prior = log_prior - (0.5*((theta1(ii)-(mu1+(phi1*ind_2(ii))))/tau1)^2) - log(tau1);%Gelman's version
    end
    % p(sigma)
    if(sigma<=0)
    log_prior = log_prior + (-inf);
    end
    % p(tau0)
    if(tau0<=0)
    log_prior = log_prior + (-inf);
    end
    % p(tau1)
    if(tau1<=0)
    log_prior = log_prior +(-inf);
    end
    % p(mu0)
    log_prior = log_prior + log(1);
    % p(mu1)
    log_prior = log_prior + log(1);
    % p(phi0)
    log_prior = log_prior  + log(1);
    % p(phi1)
    log_prior = log_prior  + log(1);
    % Log-Likelihood function
    log_likefun = 0;
    mlogy=mean(y);
    slogy=std(y);
    mrep=mean(rep);
    srep=std(rep);
    for ii = 1:length(theta0)
           ind_34_ii=find(ind_34==ii);
           zlogy=(y(ind_34_ii)-mlogy) ./ slogy;
           xs=rep(ind_34_ii);
           zx=(xs-mrep) ./ srep;
           log_likefun =  log_likefun -(0.5*sum(((zlogy-(theta0(ii)+(theta1(ii).*zx)))./sigma).^2))- log(sigma);
    end
    % Log Posterior
    p = log_prior + log_likefun;
end