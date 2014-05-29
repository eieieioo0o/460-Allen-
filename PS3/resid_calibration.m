function resid = resid_calibration(A,X,Y,L,ratio, sigma)
% EXPLANATION
% This is a code for Q3 for PS2 by T.Allen(460).
% The objective of this exercise is to match the trade-flow data exactly.



%% The code starts from here...

N_country = length(Y);
tau = nan(N_country);



% wage
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

t = diag(tau)-1;
t = max(t);
if t>1e-15
    error('Wrong...')
end


% small checkes
sc = isinf(K);
if sum(sc(:))~=0
    error('Something is wrong');
end

% new wage
alpha = 1-sigma;
w_new = eqm_wage(K,L,alpha,w);


% convergence check
resid = w_new-w;
resid = norm(w_new-w);




