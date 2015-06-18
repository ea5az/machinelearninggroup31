%% we use the old faithful dataset

load('train_oldfaithful.mat')
n = length(x);
t = t*0.5 + 0.5;
%add row for bias values
x = [ones(n,1) x];

alpha = 0.5;

num_hidden = 1;
num_input = size(x , 2);
num_output = size(t , 2);

%% weights w and v random intialization
v1 = random('unif',-1,1,3,1);
w1 = random('unif',-1,1,2,1);

%% repeat until win
stop = false;
cnt = 1;
while not(stop) && not(cnt == n)
    %feedforward
    z_in = x(cnt , :) * v1;
    z = [1 1./(1 + exp(-z_in))];
    y_in = z * w1;
    y = 1./(1 + exp(-y_in))
    
    %backpropagation
    delta = (t(cnt) - y) * (1./(1 + exp(-y_in))) * (1 - 1./(1 + exp(-y_in)));
    delta_w = alpha * delta * z;
    delta_in = delta * w1(2);
    delta_back = delta_in * (1./(1 + exp(-z_in))) * (1 - 1./(1 + exp(-z_in)));
    delta_v = alpha * delta_back * x(cnt , :);
    
    % update weights
    w1 = w1 + delta_w.';
    v1 = v1 + delta_v.';
    
    cnt = cnt + 1;
    %stop =true;
end

%%

load('test_oldfaithful.mat')
scatter(x(:,1) , x(:,2))