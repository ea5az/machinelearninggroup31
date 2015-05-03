load('iris.mat')
t = fitctree(iris , irisNames);
view(t , 'mode' , 'graph')


t2 = fitctree(iris , irisNames , 'Crossval', 'on' , 'KFold' , 3);
L = kfoldLoss(t2 , 'mode' , 'individual')
[~,min_mod] = min(L)
[~,max_mod] = max(L)

view(t2.Trained{min_mod} , 'mode' , 'graph')
view(t2.Trained{max_mod} , 'mode' , 'graph')