%% fixed learning rate - adding momentum - we use the old faithful dataset

figure()
colormap(winter)
load('train_oldfaithful.mat')

%load the testing data
load('test_oldfaithful.mat')
m = length(x_test);
input = [ones(m , 1) , x_test];

n = length(x);
t = t*0.5 + 0.5;
%add row for bias values
x = [ones(n,1) x];
%unfortunate naming here - this is our learning parameter
alpha = 0.005;
% and this is our parameter for momentum
momentum_param = 0.9;

%% discussion of momentum
% Adding momentum results in good classifications even for very low values
% of the learning rate alpha. That is because the momentum causes the
% weight vector to "jump over" local minima
%%
num_hidden = 1;
num_input = size(x , 2);
num_output = size(t , 2);

%% weights w and v random intialization
v1 = random('unif',-1,1,3,1);
w1 = random('unif',-1,1,2,1);

%% repeat until win
stop = false;
cnt = 1;
reps = 0;
% for first iteration:
delta_w = 0;
delta_v = 0;

while not(stop) && not(reps == 10)
    %feedforward
    z_in = x(cnt , :) * v1;
    z = [1 1./(1 + exp(-z_in))];
    y_in = z * w1;
    y = 1./(1 + exp(-y_in));

    %backpropagation
    delta = (t(cnt) - y) * (1./(1 + exp(-y_in))) * (1 - 1./(1 + exp(-y_in)));
    delta_w = alpha * delta * z + momentum_param*delta_w;
    delta_in = delta * w1(2);
    delta_back = delta_in * (1./(1 + exp(-z_in))) * (1 - 1./(1 + exp(-z_in)));
    delta_v = alpha * delta_back * x(cnt , :) + momentum_param*delta_v;

    % update weights
    w1 = w1 + delta_w.';
    v1 = v1 + delta_v.';

    cnt = cnt + 1;
    if cnt == n
        cnt = 1;
        reps = reps + 1;
    end
    %stop =true;
end

%% test the network

%calculate the labels that are assigned by the backpropagation network
z_test_in = input * v1;
z_test = [ones(m,1) 1./(1 + exp(-z_test_in))];
y_test_in = z_test * w1;
y_test = 1./(1 + exp(-y_test_in));
labels = y_test >= 0.5;

%plot them next to another so that you can see that the teting data is
%classified correctly
subplot(1,2,1)
hold on;
axis equal;
scatter(x_test(:,1) , x_test(:,2))
scatter(x(:,2),x(:,3),[],t)
title('No classification')


subplot(1,2,2)
hold on;
axis equal;
scatter(x_test(:,1) , x_test(:,2) , [] , labels)
scatter(x(:,2),x(:,3),[],t)
title(strcat('Current rate: ' , num2str(alpha)))
