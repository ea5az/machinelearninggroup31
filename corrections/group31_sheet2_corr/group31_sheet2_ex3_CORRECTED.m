%% Exercise sheet 2
clear all; close all;

% Exercise 3
% a+b)
%decision tree:
load('Iris.mat')
tree = fitctree(iris, irisNames)
view(tree, 'mode', 'graph')
model = crossval(tree, 'kfold', 3) % 3-fold cross-validation


%% c)
treenew = fitctree(iris, irisNames, 'Crossval', 'on', 'KFold', 3)
performance = kfoldLoss(treenew, 'mode', 'individual') %calculate error
[~,min]= min(performance);
[~,max] = max(performance);
%shows best tree
view(treenew.Trained{min}, 'mode', 'graph' )
%shows worst tree
view(treenew.Trained{max}, 'mode', 'graph')

%