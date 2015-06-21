%% trying different learning rates - we use the old faithful dataset

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

alphas = [ 0.001 , 0.01 , 0.5 , 1 , 10 , 100];
iterations = length(alphas);
current_it = 1;

num_hidden = 1;
num_input = size(x , 2);
num_output = size(t , 2);

for alpha = alphas
    %% weights w and v random intialization
    v1 = random('unif',-1,1,3,1);
    w1 = random('unif',-1,1,2,1);

    %% repeat until win
    stop = false;
    cnt = 1;
    reps = 0;
    while not(stop) && not(reps == 10)
        %feedforward
        z_in = x(cnt , :) * v1;
        z = [1 1./(1 + exp(-z_in))];
        y_in = z * w1;
        y = 1./(1 + exp(-y_in));

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
    subplot(iterations,2,2*current_it-1)
    hold on;
    axis equal;
    scatter(x_test(:,1) , x_test(:,2))
    scatter(x(:,2),x(:,3),[],t)
    title('No classification')


    subplot(iterations,2,2*current_it)
    hold on;
    axis equal;
    scatter(x_test(:,1) , x_test(:,2) , [] , labels)
    scatter(x(:,2),x(:,3),[],t)
    title(strcat('Current rate: ' , num2str(alpha)))
    
    current_it = current_it +1;
end

%% discussion of different learning rates:
% We try learning rates in the range from 0.001 to 100 and little
% surprising the extreme values do not produce good results. The values 0.5
% or 1 seem to work best. Presumably the extreme low value is bad because
% the weight vector is not changed much at all and therefore remains at the
% random initial state that doesn't capture the structure of the data. The
% extreme high value on the other hand changes the weights too much and
% therefore skips local/global optima.