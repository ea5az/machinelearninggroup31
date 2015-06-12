close all;
clear all;
load('train_or.mat')

n = length(t);
%% initialize weight and biases randomly

w = random('unif',-1,1,1,2);
b = random('unif',-1,1);

%%
figure();
hold on;
axis equal;
colormap(winter(2));
scatter(x(:,1),x(:,2),[],t+2);

%%
continu = true;
count = 1;
threshold = 0.005;
epsilon = 0.5;
while continu == true
    % test for stop
    w = w * (1./sqrt(w*w.'));
    classification = (w * ([x(:,1) , x(:,2) - b]).') >= 0;
    classification(classification == 0) = -1;
    correct = sum(classification.' == t);
    cont = correct < n;
    % iterate over data
    y_in = w*x(count , :).' + b;
    ypos = y_in > threshold;
    yneg = -(y_in < -threshold);
    y = ypos + yneg
    t(count)
    epsilon * (t(count) - y)*x(count)
    w = w + epsilon * (t(count) - y)*x(count);
    b = b + epsilon * (t(count) - y);
    count = count + 1;
    if count == n 
        count = 1;
    end

end
%%
quiver(0,b,w(1),w(2));
dx = linspace(-2,2);
fx = -w(1)*dx/w(2) + b;
plot(dx,fx)
xlim([-2,2])
ylim([-2 2])
%%
% figure();
% hold on;
% axis equal;
% colormap(winter(2));
% 
% scatter(x(:,1),x(:,2),[],t+2);
% quiver(0,b,w(1),w(2));
% dx = linspace(-2,2);
% fx = -w(1)*dx/w(2) + b;
% plot(dx,fx)
% 
% xlim([-2,2])
% ylim([-2 2])