function  w = eqm_wage(K,L,alpha,w)
% CAUTION definition of K is from lecture 5.
% Apparently K is used in a different thing in lecture 6.
% Also alphs is abused
% Follow the notation in lecture 5.
% EXPLANATION
% The eqm wage is computed.
% See the treb's note(lecture 5). Notations here are consistent with the
% note.
% 
% INPUT
% K : coefficients
% L : population
% alpha : power
% w : initial guess

% prelims
weight=0.7;
tol=1e-5;
maxit = 100000;

% number of the countries
N = length(L);

% initial guess

if exist('w','var')~=1
    w = ones(N,1);
end

for i = 1 : maxit
    
    temp= (K')*w.^alpha; % N * 1
    temp = (w.*L)./temp;
    
    % new wage (10) equation
    w_new = ( w.^alpha .*  (K * temp) )./L;    
    if isnan(w_new)
        keyboard;
    end

    % convergence check
    dist = norm(w-w_new);
    if dist<tol
        break;
    end
    if isnan(dist)
        keyboard;
    end
    
    % update
    w = weight * w + (1-weight) * w_new;
    if i == maxit
        fprintf('\nDist = %5.10f\n',dist)
        error('The equilibrium is not obtained...')
    end
end

% fprintf('\ndist = %5.10f\n',dist)


