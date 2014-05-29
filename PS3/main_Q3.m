% EXPLANATION
% This is a code for Q3 for PS2 by T.Allen(460).
% The objective of this exercise is to match the trade-flow data exactly.



%% housekeeping
clc;
clear all;
close all;
addpath(genpath('../'));
% load data_Q3_modified
load tradedata_cleaned_up;
%% analysis

N_country = length(Y);
tau = nan(N_country);

% pre-determined parameters
sigma = 5;

% wage
w = Y./L;

% Technology
A = ones(N_country,1);
w = Y./L;
K = nan(N_country);
% iceberg


for i = 1 : N_country
    for j = 1 : N_country
        if i==j % normalization
            tau(i,j)=1;
            K(i,j) = 1/(A(j)^(1-sigma));
        elseif X(i,j)==0
            tau(i,j) = inf;
            K(i,j) = 0;
        else
            tau(i,j) = ratio(i,j)^(1/(1-sigma))*w(j)./w(i) * A(i)/A(j);
            K(i,j) = ratio(i,j) * (w(j)/w(i))^(1-sigma) / (A(j)^(1-sigma));
        end
    end
end

% bilateral
% K = tau.^(1-sigma)
origin = (w./A).^(1-sigma);
P = tau.^(1-sigma) .* repmat(w./A,1,N_country);
P = sum(P,1)';
P = P.^(1/(1-sigma));
delta = Y./P.^(1-sigma);

scatter(log(origin),log(delta),'s')
grid on
axis tight
xlabel('origin effect')
ylabel('destination effect')
title('Fixed effects')
print -depsc 'Q3_fixed_effects.eps'


movefile *.eps pictures






