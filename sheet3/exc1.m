clear all; close all;
load('data.mat');
fx = x;
dx = linspace(0,length(x) , length(x));
plot(dx,fx,'o');

% Create random partitions
Y = random( makedist('Uniform') , 200 , 1);

select1 = Y <= 1./3.;
partition1 = fx .* select1;
partition1(partition1 == 0) = [];
mu(1) = mean(partition1);
sigma(1) = std(partition1);
alpha(1) = length(partition1)/length(fx);

select2 = (Y > 1./3.) & (Y <= 2./3.);
partition2 = fx .* select2;
partition2(partition2 == 0) = [];
mu(2) = mean(partition2);
sigma(2) = std(partition2);
alpha(2) = length(partition2)/length(fx);


select3 = (Y > 2./3.);
partition3 = fx .* select3;
partition3(partition3 == 0) = [];
mu(3) = mean(partition3);
sigma(3) = std(partition3);
alpha(3) = length(partition3)/length(fx);

eps = 0.5;
N = 100;
mu_array = zeros(3 , 12);
mu_array(1 , 1) = mu(1);
mu_array(2 , 1) = mu(2);
mu_array(3 , 1) = mu(3);

sigma_array = zeros(3 , 12);
sigma_array(1 , 1) = sigma(1);
sigma_array(2 , 1) = sigma(2);
sigma_array(3 , 1) = sigma(3);

alpha_array = zeros(3 , 12);
alpha_array(1 , 1) = alpha(1);
alpha_array(2 , 1) = alpha(2);
alpha_array(3 , 1) = alpha(3);

p = zeros(200 , 3);

n = 1;
while(true)
    p(: , 1) = normpdf(fx,mu_array(1,n),sigma_array(1,n))*alpha_array(1,n);
    p(: , 2) = normpdf(fx,mu_array(2,n),sigma_array(3,n))*alpha_array(2,n);
    p(: , 3) = normpdf(fx,mu_array(3,n),sigma_array(3,n))*alpha_array(3,n);
    
    normsum = sum(p,2);
    
    p(: , 1) = p(: , 1) .* (1./normsum);
    p(: , 2) = p(: , 2) .* (1./normsum);
    p(: , 3) = p(: , 3) .* (1./normsum);

    summed_rows = sum(p,1);
    
    mu_array(1 , n+1) = (1./summed_rows(1))*sum(fx .* p(: , 1) , 1);
    mu_array(2 , n+1) = (1./summed_rows(2))*sum(fx .* p(: , 2) , 1);
    mu_array(3 , n+1) = (1./summed_rows(3))*sum(fx .* p(: , 3) , 1);

    sigma_array(1 , n+1) = (1./summed_rows(1))*sum((fx-mu_array(1 , n+1)).^2 .* p(: , 1) , 1);
    sigma_array(2 , n+1) = (1./summed_rows(1))*sum((fx-mu_array(2 , n+1)).^2 .* p(: , 2) , 1);
    sigma_array(3 , n+1) = (1./summed_rows(1))*sum((fx-mu_array(3 , n+1)).^2 .* p(: , 3) , 1);

    mean_p = mean(p , 1);
    
    alpha_array(1 , n+1) = mean_p(1);
    alpha_array(2 , n+1) = mean_p(2);
    alpha_array(3 , n+1) = mean_p(3);
    
    for j =1:3
        ix = linspace (-4.5 ,4 ,200);
        plot(ix,normpdf(ix, mu_array(j , n),sigma_array(j,n))+1);
    end
    
    mu_delta = sum(abs(mu_array(: , n)-mu_array(: , n+1)));
    sigma_delta = sum(abs(sigma_array(: , n)-sigma_array(: , n+1)));
    if (mu_delta < eps) & (sigma_delta < eps); break; end
    n = n + 1;
end
alpha_array
sigma_array
mu_array