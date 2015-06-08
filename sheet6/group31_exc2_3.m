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

epsilon = 0.5;
steps = 100;

%% randomly initialize
figure()
w = random('Uniform',-1,1,2,1);
subplot(4,3,1)
hold on;
plot(x(:,1),x(:,2),'o','color','blue')
quiver(0,0,w(1),w(2),5);

%%
for i = 1:steps
    y = theta(x(i,:)*w);
    delta_w = epsilon * y *(x(i,:).' - y*w)
    w = delta_w + w;
    if mod(i,10) == 0
        subplot(4,3,i/10+1)
        hold on;
        plot(x(:,1),x(:,2),'o','color','blue');
        quiver(0,0,w(1),w(2),5,'color','red');
    end
end

