%% load data

close all;
clear all;
load('train_or.mat');
n = length(t);
x = [ones(n,1) , x]; % represent bias as w_0 -> need 1st column = 1
%% plot data with color
figure()
subplot(1,3,1)
axis equal
hold on;
colormap(winter)
scatter(x(:,2),x(:,3),[],t)
%% plot seperating line as well
% a + bx + cy = 0
% cy = -bx - a
% y = (-bx - a)/c
w = random('unif',-1,1,3,1);
quiver(0,-w(1)/w(3),-1./w(3),-1./w(2))
dx = linspace(-2,2,100);
fx = (-w(2)*dx - w(1))/(w(3));
plot(dx,fx)
xlim([-2,2])
ylim([-2,2])
%% incremental learning algorithm
% converges often, but not always perfectly
stop = false;
threshold = 0.01;
eps = 0.05;
iter = 1;
while stop == false
    for i = 1:n % for all the data - update weights
        y_in = x(i,:) * w;  % performance might improve if we changed the
        y = (y_in > threshold) + -(y_in <= threshold); % order of the data 
        w = w + eps*(t(i) - y)*x(i,:).'; % in each iteration
    end
    
    correct = sum((x * w >= 0) + -(x*w < 0) == t); % calculate correct classifications
    if correct == n || iter == 10000 % cutoff necessary
         stop = true;
    end
    iter = iter + 1;
end
%% plot final seperating line
    
subplot(1,3,2)
axis equal
hold on;
quiver(0,-w(1)/w(3),-1./w(3),-1./w(2))
scatter(x(:,2),x(:,3),[],t)
fx = (-w(2)*dx - w(1))/(w(3));
plot(dx,fx)
xlim([-2,2])
ylim([-2,2])

%% load testing data an plot with classification
subplot(1,3,3);
colormap(winter);
axis equal;
hold on;
load('test_or.mat')
m = length(x_test);
test = [ones(m,1) , x_test];
pred = (test*w >= 0) - (test*w < 0);
scatter(x(:,2),x(:,3),[],t)
scatter(test(:,2),test(:,3),[],pred)
xlim([-2,2])
ylim([-2,2])

