function [w X] = discrete_EK(T,theta,tau,L,sigma,M,draw)
% EXPLANATION
% T : technology parameters
% theta : shape (aggregate shocks)
% M : number of the goods (M=infinity => EK model)




% number of the countries
N = length(T);

% technology draws
Z = nan(N,M);

if strcmp(draw{1},'F')
    for i = 1 : N
        Z(i,:)=(frechet_r(M,T(i),theta))';
    end
else
    shape_param = draw{2};
    for i = 1 : N
        Z(i,:)=(Pareto_r(M,T(i),theta,shape_param))';
    end
    
end

% initial guess
w = ones(N,1);

maxit = 1000;
coeff=.99;

for ii = 1 : maxit
    
    % TRY VECTORIZATION : close to my standard notation
    % [tau      tau     tau ...]
    % [z1... z1 z2...z2 z3...  ]
    TAU = repmat(tau.*repmat(w,1,N),1,length(Z));
    Zvec=repmat(Z,N,1);
    Zvec=Zvec(:);
    Zvec=reshape(Zvec,N,length(Z)*N);
    temp = TAU./Zvec;
    [temp, policy] = min(temp,[],1);
    C=reshape(policy,N,M);
    P = reshape(temp,N,M);
    % expenditure
    Y = w.*L;
    Pind = (sum(P.^(1-sigma),2)).^(1/(1-sigma));
    
    

    % don't vectorize this part.
    % too high dimension
    X = zeros(N,N,M);
    for omega = 1 : M
        for j = 1 : N
            X(C(j,omega),j,omega)= (P(j,omega)/Pind(j))^(1-sigma)*Y(j) ;
        end
    end
    
    X = sum(X,3);
    X = squeeze(X);
    
    Ynew = sum(X,2);
    Y = Ynew;
    w_new = Y./L;
    
    dist = norm(w_new-w);
    if dist <.05
        break;
    end
    
    w = coeff*w +(1-coeff)*w_new;
    
    if ii == maxit
        disp('non-convergenced...')
    end
    
end

