% EXPLANATION
% This is a code for Q3 for PS2 by T.Allen(460).
% The objective of this code is to convert the data.frame in R into the
% standard format used in matlab
% for example, x_ij is a column vector, but I convert it to S*S matrix



%% housekeeping
clc;
clear all;
close all;
addpath(genpath(pwd));
load data_Q3

d = fieldnames(dataset);
for i = 1 : length(d)
    eval([d{i},'=dataset.',d{i},';'])
end
clear dataset


names = [origin;destination];
names = unique(names);
N_country = length(names);

% labor 
L = nan(N_country,1);
Y = nan(N_country,1);
for i = 1 : N_country
    ind = strcmp(names(i),destination);
    ind = find(ind==1);
    if isempty(ind)~=1
        ind  = min(ind); 
        L(i) = population_destination(ind);
        Y(i) = gdp_destination(ind);
    end
end
L = exp(L);
Y = exp(Y);
% trade flow data
X = nan(N_country);
Ratio = nan(N_country);
N_observation = length(trade);
for n = 1 : N_observation
    origin_temp = origin(n);
    desti_temp  = destination(n);
    origin_ind = find(strcmp(origin_temp,names)==1);
    desti_ind = find(strcmp(desti_temp,names)==1);
    X(origin_ind,desti_ind) = trade(n);
    Ratio(origin_ind,desti_ind) = ratio(n);
end
X = exp(X);
Ratio = exp(Ratio);
for i = 1 : length(Ratio)
    Ratio(i,i) = 1;
end
% clean up a little bit
Y_na = find(isnan(Y));
L_na = find(isnan(L)==1);

na_ind = [Y_na;L_na];

na_ind = unique(na_ind);
Y(na_ind) =[];
L(na_ind) =[];
X(na_ind,:) = [];
X(:,na_ind) = [];
X(isnan(X)) = 0;
Ratio(na_ind,:) = [];
Ratio(:,na_ind) = [];
Ratio(isnan(Ratio)) = 0;





save data_Q3_modified Y L X Ratio

N_country = length(Y);
tau = nan(N_country);
tau(X==0) = inf;







