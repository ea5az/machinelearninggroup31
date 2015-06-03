load('oldfaithful.mat');
x = x(: , [2,1]); % we like this way of thinking bout the data better
n = length(y);
dim = length(x(1,:));
%% normalization
x_mean = mean(x);
x_norm = [(x(:,1)-x_mean(1)) (x(:,2)-x_mean(2))];
%% plotting normalized
close all;
figure()
subplot(1,2,1)
scatter(x(:,1),x(:,2),[],y)

subplot(1,2,2)
scatter(x_norm(:,1),x_norm(:,2),[],y)

% as expected the data looks exactly the same except for the fact that the
% normalized data was moved in the coordinate system so that the center is
% now at (0,0)

%%

%Calculating the covariance matrix and sorting the Eigenvectors so that the
% one corresponding to the biggest EW (highest variance) is in the leftmost
% column

C = cov(x);
[EV,EW] = eig(C);
[EW_sort, swapInd] = sort(sum(EW , 1) , 'descend');
EV_sort = EV(: , swapInd);

%%

% plotting the Eigenvectors in the scatterplot
% axis equal to see that they are orthogonal

hold on;
axis equal;
scatter(x_norm(:,1),x_norm(:,2),[],y)
for i = 1:dim
    quiver(0,0,EV_sort(1,i),EV_sort(2,i))
end
%%

% get first vector as principal component and then project all the data 
% on the corresponding eigenspace

principal = EV_sort(:,1);
U = principal.';
Z = U * x_norm.';
% one-dimensional plot of scalars Z
scatter(Z,zeros([1,length(Z)]),[],y)

%% reconstruction

% Since the eigenvectors are normalized (length 1) by default we can
% reconstruct the points in 2d space by simply multiplying the principal
% vector with the corresponding scalars from the projection. For discussion
% of plot see pdf.

projections = (principal * Z).';

close all;
hold on;
axis equal;
scatter(x_norm(:,1),x_norm(:,2),[],y+2)
for i = 1:dim
   quiver(0,0,EV_sort(1,i),EV_sort(2,i))
end
scatter(projections(:,1),projections(:,2),[],y)


%%

% TUTOR (timo): plots could be adjusted a bit for better readability.
% however, concept correctly understood and implemented. 12/12p
