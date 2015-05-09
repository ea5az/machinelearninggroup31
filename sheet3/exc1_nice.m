clear all; close all;
load('data.mat'); %load
data = x; %rename

% Create random partitions
Y = random( makedist('Uniform') , 200 , 1);
partition = cell(3);
mu = zeros(3,1);
sigma = zeros(3,1);
alpha = zeros(3,1);
n = length(data);

for i = 1:3
    select = (Y > (i-1.)/3.) & (Y <= i/3.);
    temp = data .* select;
    temp(temp == 0) = [];
    partition{i} = temp;
    mu(i) = mean(partition{i});
    sigma(i) = std(partition{i});
    mu(i) = mean(partition{i});
    alpha(i) = length(partition{i})/n;
end

eps = 0.005;
N = 100;
p = zeros(200 , 3);
first_run = true;
n = 1;
mu_delta=0;sigma_delta=0;old_mu=0;old_sigma=0;
figure();
n = 1;
while((mu_delta > eps && sigma_delta > eps) || first_run)
    %Likelihoods unnormalized
    p(: , 1) = normpdf(data,mu(1),sigma(1))*alpha(1);
    p(: , 2) = normpdf(data,mu(2),sigma(2))*alpha(2);
    p(: , 3) = normpdf(data,mu(3),sigma(3))*alpha(3);
    
    %normalization
    normsum = sum(p,2);
    
    p(: , 1) = p(: , 1) .* (1./normsum);
    p(: , 2) = p(: , 2) .* (1./normsum);
    p(: , 3) = p(: , 3) .* (1./normsum);
    
    %updating
    summed_rows = sum(p,1);
    mu(1) = (1./summed_rows(1))*sum(data .* p(: , 1) , 1);
    mu(2) = (1./summed_rows(2))*sum(data .* p(: , 2) , 1);
    mu(3) = (1./summed_rows(3))*sum(data .* p(: , 3) , 1);
    
    sigma(1) = sqrt((1./summed_rows(1))*sum((data-mu(1)).^2 .* p(: , 1) , 1));
    sigma(2) = sqrt((1./summed_rows(2))*sum((data-mu(2)).^2 .* p(: , 2) , 1));
    sigma(3) = sqrt((1./summed_rows(3))*sum((data-mu(3)).^2 .* p(: , 3) , 1));

    mean_p = mean(p , 1);
    
    alpha(1) = mean_p(1);
    alpha(2) = mean_p(2);
    alpha(3) = mean_p(3);
    
    
    mu_delta = sum(abs(mu-old_mu));
    sigma_delta = sum(abs(sigma-old_sigma));
    old_mu = mu; old_sigma = sigma;

    %display(mu_delta)
    %display(sigma_delta)

    [~,assign] = max(p , [] , 2);
    
    part1 = data(assign == 1);
    part2 = data(assign == 2);
    part3 = data(assign == 3);
    
%     subplot(6,3,n);
% 
%     hold on;
%     dx1 = zeros(length(part1)) ;
%     dx2 = zeros(length(part2)) ;
%     dx3 = zeros(length(part3)) ;
%     
%     
%     plot(part1,dx1,'o','color','red');
%     plot(part2,dx2,'o','color','blue');
%     plot(part3,dx3,'o','color','green');
%     for j =1:3
%         ix = linspace (-4.5 ,4 ,200);
%         plot(ix,normpdf(ix,mu(j),sigma(j))+1)
%     end
%     hold off;
    n = n+1
    first_run = false;
end
alpha
mu
sigma
