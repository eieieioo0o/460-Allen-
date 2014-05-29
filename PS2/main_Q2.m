% EXPLANATION
% This code is for Allen(460).
% The objective here is to compute the eqm wage,
% See the problem set 2 for the instruction

%% house keeping
clc;
clear all;
close all;
addpath(genpath(pwd))

load problemset2_data.mat;

% number of the countries
N = length(A);



%% trade costs
model = 'non-symm';
if strcmp(model,'symm')
    tau = tau_symm;
else
    tau = tau; %#ok<ASGSL>
end


%% Do comparative statics

% mute the effects from labor
%L = ones(N,1)*mean(L);
%A = ones(N,1);
% sigma=5; % bigger sigma = lower CRRA = less care for variation
%tau = ones(N);
sigma = 5;



%% Eqm computation

tau_c=tau;
tau_c(15,36)=tau_c(15,36)*1.1; % 10% increase in tau(15,36)

K = tau.^(1-sigma) .* repmat(A.^(sigma-1),1,N);
K_cs = tau_c.^(1-sigma) .* repmat(A.^(sigma-1),1,N);

w_initial = ones(N,1);
[w K_bilateral gamma P Y X delta W W_tau W_log_tau W_country] = eqm_armington(K,L,sigma,A,tau,w_initial);
[~,~,~,~,~,~,~,W_actual] = eqm_armington(K_cs,L,sigma,A,tau_c,w);
[~ ,~,~,Pcs, Ycs, ~, ~, W_actual ] = eqm_armington(K_cs,L,sigma,A,tau_c,w);
actual_effect=(W_actual-W)/W*100;
target= W_log_tau(15,36);
theoretical_effect=target*10;

C = Y./P;
C_cs = Ycs./Pcs;


%% Results

fprintf('\n**************************************************\n')
fprintf('Set up\n')
fprintf('**************************************************\n')
fprintf('sigma (elasticity) : %5.1f\n',sigma)
fprintf('iceberg cost       : %5.10s\n',model)
fprintf('**************************************************\n')


fprintf('\n**************************************************\n')
fprintf('Welfare analysis : 10%% increase in tau(15,36)\n')
fprintf('**************************************************\n')
fprintf('1st order approx of welfare change : %5.5f\n',theoretical_effect)
fprintf('Actual welfare change              : %5.5f\n',actual_effect)
fprintf('**************************************************\n')


keyboard
%% analyze


stat = [A w gamma delta P W_country];
name = {'Productivity','wage','gamma','delta','Price index','Welfare'};



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
if strcmp(model,'symm')    
    print -depsc 'armington_symm_model.eps'
else
    print -depsc 'armington_model.eps'
end



%% Comparative statics
Ncs = 100;
sigma_cs =  linspace(1.5,7,Ncs);
Ntau = 6;
% boxes
W_cs = nan(Ncs,Ntau);
w_cs = nan(N,Ncs);
for j = 1 : Ntau
    tau_cs = tau*(1+.02*(j-1));
    for k = 1 : length(tau)
        tau_cs(k,k)=1;
    end
    
    for i = 1 : Ncs
        sigma = sigma_cs(i);
        [w ~,~,~,~,~,~,W_cs(i,j)] = eqm_armington(K,L,sigma,A,tau_cs,w);
    end    
end

W_cs_devi = log(W_cs(:,2:end)./repmat(W_cs(:,1),1,Ntau-1))*100;



for i = 1 : Ncs
    sigma = sigma_cs(i);
    if i == 1
        w = ones(N,1);
    else
        w = w_cs(:,i-1);
    end
    w_cs(:,i) = eqm_armington(K,L,sigma,A,tau,w);
end


figure
subplot(1,2,1)
plot(sigma_cs,W_cs)
xlabel(' elasticity : \sigma')
legend('tau','2% up','4% up','6% up','8% up','10% up','Location','Best')
title('Welfare : Z^{-1}','FontSize',14)
ylabel('Level')
grid on
axis tight

subplot(1,2,2)
plot(sigma_cs,W_cs_devi)
xlabel(' elasticity : \sigma')
legend('original','2% up','4% up','6% up','8% up','10% up','Location','Best')
title('Welfare','FontSize',14)
ylabel('Percent change')
grid on
axis tight

print -depsc 'world_welfare.eps'



figure
plot(A,w_cs(:,1),'o',A,w_cs(:,end),'r*');
legend('\sigma = 3','\sigma = 7','Location','Best')
grid on
xlim([0, max(A)])
ylim([0, 2])
title('Wage for higher and lower \sigma')


if strcmp(model,'symm')
    print -depsc 'wage_sigma_symm.eps'
else
    print -depsc 'wage_sigma.eps'
end

close all


movefile *.eps pictures
