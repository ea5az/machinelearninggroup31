clear all;
close all;
load('iris.mat');

%%
% change this to project to either two or three dimensional eigenspace
num_eig_vec = 2;

n = length(y);
dim = length(x(1,:));
%% normalization
x_mean = mean(x);
x_norm = [(x(:,1)-x_mean(1)) (x(:,2)-x_mean(2)) (x(:,3)-x_mean(3)) (x(:,4)-x_mean(4))];
%%
%Calculating the covariance matrix and sorting the Eigenvectors so that the
% one corresponding to the biggest EW (highest variance) is in the leftmost
% column
C = cov(x);
[EV,EW] = eig(C);
[EW_sort, swapInd] = sort(sum(EW , 1) , 'descend');
EV_sort = EV(: , swapInd);

%% one or two dimension version
% get first vector or first two vectors as principal component and 
% then project all the data on the corresponding eigenspace

figure()
if num_eig_vec == 2
    principal = EV_sort(:,[1,2]);
    U = principal.';
    Z = U * x_norm.';
    % two-dimensional plot of scalars Z
    scatter(Z(1,:),Z(2,:),[],y)
else
    principal = EV_sort(:,[1,2,3]);
    U = principal.';
    Z = U * x_norm.';
    % three-dimensional plot of scalars Z
    scatter3(Z(1,:),Z(2,:),Z(3,:),[],y)
end

%% Chernov faces to visualize 4 dimensional data
% since we don't know which feature corresponds to which column we cannot
% really say what the features of the faces stand for. The faces look funny
% though.
figure();
labels = int2str(y+1);

glyphplot(x, 'glyph','face','obslabels',labels,'Features',[1,12,14,16]);
title('Chernov faces of iris data');


