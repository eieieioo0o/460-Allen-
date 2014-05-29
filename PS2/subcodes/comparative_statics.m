%% comparative statics
% EXPLANATION
% This code is for Allen(460).
% The objective here is to compute the eqm wage,
% See the problem set 2 for the instruction

%% house keeping
clc;
clear all;
close all;

load problemset2_data.mat;

% number of the countries
N = length(A);



%% Do comparative statics

% mute the effects from labor
%L = ones(N,1)*mean(L);
A = ones(N,1);
% sigma=5; % bigger sigma = lower CRRA = less care for variation
%tau = ones(N);
sigma = 5;



%% Eqm computation

tau_c=tau;
tau_c(15,36)=tau_c(15,36)*1.1; % 10% increase in tau(15,36)

K = tau.^(1-sigma) .* repmat(A.^(sigma-1),1,N);

w_initial = ones(N,1);
[w, K_bilateral, gamma, P, Y, delta, Z,Welfare_tau] = eqm_armington(K,L,sigma,A,tau,w_initial);


%% analyze


stat = [A w gamma delta P Y];
name = {'Productivity','wage','gamma','delta','Price index','Output'};



figure('name','Statistics')
for i = 2 : size(stat,2)
        subplot(2,3,i-1)
        scatter(stat(:,1),stat(:,i),'o')
        grid on
        xlabel('Technology')
        title(name{i})
        ylabel(name{i})
        axis tight
end

subplot(2,3,6)
scatter(gamma,delta)
xlabel('origin effect')
ylabel('destination effect')
grid on
title('Destination VS Origin fixed effect')

print -depsc 'result_without_tech.eps'


