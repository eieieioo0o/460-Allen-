function [w K_bilateral gamma P Y X delta Z_inverse Z_inverse_tau Z_inverse_log_tau W_country] = eqm_armington(K,L,sigma,A,tau,w)
% CAUTION
% alpha here is not the same as the alpah in lecture 5
% DO NOT USE alpha except for eqm_wage
% EXPLANATION
% This code gives you the eqm results in Armington model
% W = Z_inverse : weighted welfare
%
% INPUT
% K : tau^(1-sigma) * A(1-sigma)
% L : labor
% sigma : elasticity
% A : technology
% tau : iceberg cost
% w : initial guess
% OUTPUT
% w : eqm wage
% K_bilateral : bilateral effect
% gamma : origin effect
% P : price index
% delta : destination effect
% Y : income  = w * L
% X : trade flows
% Others are welfare measures...

%% The code starts from here...

alpha = 1-sigma;
N = length(L);
if exist('w','var')~=1
    w = ones(N,1);
end

w = eqm_wage(K,L,alpha,w);

% Outcomes
Y  = w.*L;
K_bilateral = tau.^(1-sigma);
gamma = (w./A).^(1-sigma);
P = (  K_bilateral' * gamma  ).^(1/(1-sigma));
delta = Y.*P.^(-(1-sigma));
% world income
Yw = sum(Y);

% trade flow
X = K_bilateral.* repmat(gamma,1,N).* repmat(delta',N,1);

% world welfare
Z_inverse= K_bilateral*gamma;
Z_inverse= Z_inverse' * gamma;
Z_inverse=1./Z_inverse;
% Welfare partial derivative
Z_inverse_tau= repmat(gamma,1,N).*repmat(gamma',N,1).*tau.^(1-sigma)*(1-sigma)/Z_inverse;
% Welfare partial log derivative
Z_inverse_log_tau = - X./Yw*(1-sigma);

% openess
lambda = X./(repmat(Y',N,1));
W_country = A.*(diag(lambda)).^(1/(1-sigma));




