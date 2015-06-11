%% load the data+
%TUTOR: Nice job! 12/12
clear all;
close all;
load('dataLarge1.mat') %pick a dataset
%load('dataLarge2.mat')

%% pick constants

epsilon = 0.01;
iter = 1000;

%% randomly initialize
figure()
w = random('Uniform',-1,1,2,1);

hold on;
plot(x(:,1),x(:,2),'o')
quiver(0,0,w(1),w(2));

%%plot few of the iteration steps over the data
% strange plots if initilization vectors orthogonal to eigen-vector with highest eigen-value

for i = 1:iter
    y = theta(x(i,:)*w);
    %Ojas rule:
    delta_w = epsilon * y *(x(i,:)' - y*w);
    
    %Hebbs rule:
    %delta_w = epsilon * y * x(i,:).';
    
    w = delta_w + w;  
    if i == 1 % make the first vector long so that we can see the development
        quiver(0,0,5*w(1),5*w(2));
    elseif i < 10
        quiver(0,0,3*w(1),3*w(2));
    elseif mod(i, 100) == 0    
        quiver(0,0,3*w(1),3*w(2));
    elseif i>990
        quiver(0,0,3*w(1),3*w(2));
    end
end
%TUTOR: Nice! I just changed the Muliplikators of the size of the vectors
%here. 

%% Calculating the covariance matrix ???

C = cov(x,x)
%TUTOR: yes, thats it..^^

%delta_w

%% discussion of difference between Hebbs and Ojas:
% Both rules don't always converge. Especially on dataset 2 the parameter
% vector seems to get stuck in local extrema. The obvious difference
% between the two methods is that the length of the parameter vector when
% applying Hebbs rule increases continuously while the length stays
% approximately the same when using Oja's rule.
%TUTOR: I changed your epsilon to 0.01. now the convergence is more
%obvious.
