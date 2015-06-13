close all;
clear all;
load('train_or.mat')

n = length(t);
%% initialize weight and biases randomly
% w0 is bias
w = random('unif',-1,1,1,3);

x = [ones([n,1]) , x];

%%
figure();
subplot(6,5,1);
hold on;
axis equal;
colormap(winter(2));
scatter(x(:,2),x(:,3),[],t+2);
%%
quiver(0,w(1),w(2),w(3));
dx = linspace(-2,2);
fx = -w(2)*dx/w(3) + w(1);
plot(dx,fx)
xlim([-2,2])
ylim([-2 2])
%%
continu = true;
count = 1;
threshold = 0.05;
epsilon = 0.5;
reps = 1;
plotnr = 2;
while continu == true
    % test for stop
    %w = w * (1./sqrt(w*w.'));
    classification = (w * x.') >= 0;
    classification(classification == 0) = -1;
    correct = sum(classification.' == t);
    cont = correct < n;
    % iterate over data
    y_in = w*x(count , :).';
    y = y_in >= threshold + -(y_in <= threshold);

    w = w + epsilon * (t(count) - y)*x(count , :);

    count = count + 1;
    if count == n 
        %continu = false
        count = 1
        reps = reps + 1
    end
    if reps == 3
        continu = 0
    end
    subplot(6,5,plotnr);
    hold on;
    axis equal;
    scatter(x(:,2),x(:,3),[],t+2);
    quiver(0,w(1),w(2),w(3));
    dx = linspace(-2,2);
    fx = -w(2)*dx/w(3) + w(1);
    plot(dx,fx)
    xlim([-2,2])
    ylim([-2 2])  
    plotnr = plotnr + 1;
end
%%
% quiver(0,w(1),w(2),w(3));
% dx = linspace(-2,2);
% fx = -w(2)*dx/w(3) + w(1);
% plot(dx,fx)
% xlim([-2,2])
% ylim([-2 2])
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