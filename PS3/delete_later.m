% EXPLANATION
% This is a code for Q3 for PS2 by T.Allen(460).
% The objective of this exercise is to match the trade-flow data exactly.



%% housekeeping
clc;
clear all;
close all;
load tradedata_cleaned_up;
dbstop if error

sum_i_j = 0;
checks = diff(X(:,1));
checks = [0;checks];
N_country = sum(checks);
X_jj = nan(N_country,1);
X_ii = nan(N_country,1);
bin = 1;

for i = 1 : length(X)
    if checks(i)~=1
    sum_i_j = sum_i_j + flow(i);
    else
        X_ii(bin) = gdp_origin(i-1) - sum_i_j;
        sum_i_j = flow(i);
        bin = bin+1;
    end    
end

checks = diff(X(:,2));
checks = [0;checks];


for j = 1 : length(X)
    if checks(j)>0
    sum_i_j = sum_i_j + flow(j);
    else
        X_ii(bin) = gdp_origin(i-1) - sum_i_j;
        sum_i_j = flow(i);
        bin = bin+1;
    end
end

