function  Z = frechet_r(n1,T,theta)

U = rand(n1,1);
Z = (log(U)/(-T)).^(-1/theta);


end