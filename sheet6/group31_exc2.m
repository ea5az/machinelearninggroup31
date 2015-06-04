%% load the data
close all;
load('dataLarge1.mat')

n = length(x);
dim = size(x,2);

%% plot the data
% figure()
% hold on;
plot(x(:,1),x(:,2),'o')
%% pick constants

epsilon = 0.005;
steps = 100;

%% randomly initialize
figure()
w = random('Uniform',-1,1,2,1);
subplot(4,3,1)
hold on;
plot(x(:,1),x(:,2),'o')
quiver(0,0,w(1),w(2));

%%
for i = 1:iter
    y = theta(x(i,:)*w);
    delta_w = epsilon * y *(x(i,:).' - y*w);
    w = delta_w + w;
    if mod(i,10) == 0
        subplot(4,3,iter/10+1)
        hold on;
        quiver(0,0,w(1),w(2));
        plot(x(:,1),x(:,2),'o')
    end
end

