clear all; close all;
load('data.mat'); %load
data = x; %rename

% allocate space for variables
n = length(data);
mu = zeros(3,1);
sigma = zeros(3,1);
alpha = zeros(3,1);
p = zeros(n , 3);
first_run = true;
mu_delta=0;sigma_delta=0;old_mu=0;old_sigma=0;

% define constant
eps = 0.005; % small epsilon

figure();


% Create random partitions by drawing from a uniform distribution
% and assigning indices according to the corresponding random numbers
Y = random(makedist('Uniform') , n , 1);

for i = 1:3
    select = (Y > (i-1.)/3.) & (Y <= i/3.);
    partition = data .* select; % everything that doesn't satisfy boolean is now 0
    partition(partition == 0) = []; %delete 0's
    mu(i) = mean(partition); %initialize values from random partition
    sigma(i) = std(partition);
    mu(i) = mean(partition);
    alpha(i) = length(partition)/n;
end
iteration = 1;
while((mu_delta > eps && sigma_delta > eps) || first_run) %while change in values 'big'
    
    %Likelihoods unnormalized %sorry for the messy indexing, after this
    %exercise we looked up how to do this stuff more elegantly
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

    alpha = mean(p , 1);
    
    % calculate the change (manhatten distance)
    mu_delta = sum(abs(mu-old_mu));
    sigma_delta = sum(abs(sigma-old_sigma));
    old_mu = mu; old_sigma = sigma;
    
    % find for each datapoint which class is the most likely
    [~,assign] = max(p , [] , 2);
    
    part1 = data(assign == 1);
    part2 = data(assign == 2);
    part3 = data(assign == 3);
    
    %plot every 3rd instance
    if mod(iteration,3) == 0
        subplot(6,3,iteration/3);
        hold on;
        dx1 = zeros(length(part1)) ;
        dx2 = zeros(length(part2)) ;
        dx3 = zeros(length(part3)) ; 
        
        
        plot(part1,dx1,'o','color','green');
        plot(part2,dx2,'o','color','blue');
        plot(part3,dx3,'o','color','red'); 

        for j =1:3
            ix = linspace (-4.5 ,4 ,200);
            plot(ix,normpdf(ix,mu(j),sigma(j))+1);
            title(strcat('iteration: #' , num2str(iteration)))
        end        
        
        hold off;
    end
    iteration = iteration+1;
    first_run = false;
end
alpha
mu
sigma
