clear all;
close all;
load('iris.mat');
%% parameters
% change this to project to either two or three dimensional eigenspace
num_eig_vec = 3;

n = length(y);
dim = length(x(1,:));
%% Calculate Cov-Matrix and EV's
%Calculating the covariance matrix and sorting the Eigenvectors so that the
% one corresponding to the biggest EW (highest variance) is in the leftmost
% column
C = cov(x);
[EV,EW] = eig(C);
[EW_sort, swapInd] = sort(sum(EW , 1) , 'descend');
lambda = zeros(dim);
for i = 1:dim
    lambda(i,i) = (EW_sort(i)).^(-0.5); %we take the inverse squareroot of 
                                        %the original values
                                        %because that's the form we need it
                                        %in for the whitening part
end
EV_sort = EV(: , swapInd);
%% normalization
x_mean = mean(x);
x_norm = [(x(:,1)-x_mean(1)) (x(:,2)-x_mean(2)) (x(:,3)-x_mean(3)) (x(:,4)-x_mean(4))];
%% we apply whitening to the normalized data
p_w = lambda * EV_sort.';

x_white = (p_w * x_norm.').';


%% one or two dimension version with comparison between whitened and unwhitened data
% get first vector or first two vectors as principal component and 
% then project all the data on the corresponding eigenspace

figure()
if num_eig_vec == 2
    principal = EV_sort(:,[1,2]);
    U = principal.';
    Z = U * x_white.';
    % two-dimensional plot of scalars Z
    subplot(1,2,1)
    scatter(Z(1,:),Z(2,:),[],y)
    title('whitened data')

    principal = EV_sort(:,[1,2]);
    U = principal.';
    Z = U * x_norm.';
    % two-dimensional plot of scalars Z
    subplot(1,2,2)
    scatter(Z(1,:),Z(2,:),[],y)
    title('normalized data')


else
    principal = EV_sort(:,[1,2,3]);
    U = principal.';
    Z = U * x_white.';
    % three-dimensional plot of scalars Z
    subplot(1,2,1);
    scatter3(Z(1,:),Z(2,:),Z(3,:),[],y)
    title('whitened data')    
    
    principal = EV_sort(:,[1,2,3]);
    U = principal.';
    Z = U * x_norm.';
    % three-dimensional plot of scalars Z
    subplot(1,2,2);
    scatter3(Z(1,:),Z(2,:),Z(3,:),[],y)
    title('normalized data')

end

%% Chernov faces to visualize 4 dimensional data
% since we don't know which feature corresponds to which column we cannot
% really say what the features of the faces stand for. The faces look funny
% though.
figure();
labels = int2str(y+1);

glyphplot(x, 'glyph','face','obslabels',labels,'Features',[1,12,14,16]);
title('Chernov faces of iris data');


