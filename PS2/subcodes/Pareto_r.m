function  Z = Pareto_r(n1,T,theta,alpha)
U = rand(n1,1);
Z = alpha * T./((1-U).^(1/theta)) ;
end