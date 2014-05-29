% EXPLANATION
% This is a code for computing a discrete-state version
% of Eaton Kortum model.
% M is the number of the goods (M=infinity is EK)
% Apparently vectorization is not feasible since
% there are many countries and there are many goods.
% It is costly compute N*N*M matrix and manipualte them.



%% house keeping
clc;
clear all;
close all;
addpath(genpath(pwd))
load problemset2_data.mat;

% number of the countries
N = length(A);


T = A.^(sigma-1);
theta = sigma-1;

M=500;
shape_param = .5;
draw{1} = 'P';
draw{2} = shape_param;
[w_apprx X_apprx] = discrete_EK(T,theta,tau,L,sigma,M,draw);
%load temp % skip the computation part.

% EK model
K = tau.^(-theta).*repmat(T,1,N);
alpha = -theta;
w_EK = eqm_wage(K,L,alpha);
Y_EK = w_EK.*L;
P_EK = (tau').^(-theta) * (T.*w_EK.^(-theta));
P_EK = P_EK.^(-1/theta);
X_EK = tau.^(-theta) .* repmat(w_EK.^(-theta).*T,1,N).* repmat(Y_EK'.*(P_EK').^theta,N,1);
%% comparison
figure
subplot(1,2,1)
scatter(w_EK,w_apprx)
xlabel('EK eqm wage')
ylabel('approximation')
grid on
axis tight
subplot(1,2,2)
scatter(X_EK(:),X_apprx(:))
xlabel('EK eqm trade flows')
ylabel('approximated trade flows')
grid on
axis tight


if strcmp(draw{1},'F')
    eval(['print -depsc ''EK_approx_M',num2str(M),''' '])
else
    eval(['print -depsc ''EK_approx_M',num2str(M),'_alpha_',num2str(draw{2}*10),''' '])
    
end
movefile *.eps pictures

















