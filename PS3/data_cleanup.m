% EXPLANATION
% This is a code for Q3 for PS2 by T.Allen(460).
% The objective of this exercise is to match the trade-flow data exactly.



%% housekeeping
clc;
clear all;
close all;
addpath(genpath(pwd))
load tradedata_original.mat;
dbstop if error

%%
d = fieldnames(dataset);
for i = 1 : length(d)
    eval([d{i},'=dataset.',d{i},';'])
end
clear dataset


names = [origin;destination];
names = unique(names);
N_country = length(names);


% labor & output
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


% trade flow data
X = zeros(N_country);
N_observation = length(trade)-1;
for n = 1 : N_observation
    origin_temp = origin(n);
    desti_temp  = destination(n);
    origin_ind = find(strcmp(origin_temp,names)==1);
    desti_ind = find(strcmp(desti_temp,names)==1);
    X(origin_ind,desti_ind) = trade(n);
end



% Xjj
% this is a little bit tricky
% the following does not work
% Xjj = sum(X,1)'; Xjj = Y-Xjj;
Xjj = sum(X,2);
Xjj = Y-Xjj;


negatives = find(Xjj<=0);
negatives = [find(sum(X,2)==0);negatives];
negatives = [find(sum(X,1)==0);negatives];
negatives = unique(negatives);

% delete the elements
Y(negatives) = [];
L(negatives) = [];
X(negatives,:) = [];
X(:,negatives) = [];
Xjj(negatives,:) = [];
N_country = length(Y);
ratio = X./repmat(Xjj,1,N_country);

Xjj = sum(X,2);
Xjj = Y-Xjj;

for i = 1 : N_country
    X(i,i) = Xjj(i);
end



%%
save tradedata_cleaned_up X Y L ratio Xjj

