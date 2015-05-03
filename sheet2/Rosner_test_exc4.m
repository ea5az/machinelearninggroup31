load('zPoints.mat');
method = 'median'
zPoints = x;
deletedSomething = true;
while(deletedSomething)
    deletedSomething = false;
    if (strcmp(method , 'mean'))
        zvals = abs(zPoints - mean(zPoints))/std(zPoints);
    else
        zvals = abs(zPoints - median(zPoints))/std(zPoints);
    end
    [val , ind] = max(zvals);
    if(val > 3)
        zPoints(ind)=[];
        deletedSomething = true;
    end
end
plot(zPoints,'o')