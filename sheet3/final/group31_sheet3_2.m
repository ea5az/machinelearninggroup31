clear all; close all;
load('points.mat');

%Allocate and intialize
C = cell([200,1]);
n = length(pts);

single_link = false; %false for complete linkage
   
%create single element clusters for the start
%we represent the points with their indeces
for i = 1:n
    C{i} = i;
end
%calculate complete distance matrix once
distances = pdist2(pts,pts);
distances(distances==0)=Inf;

%now merge clusters 195 times -> 5 clusters left
for i= n:-1:6
    %get smallest distance
    [~,ind] = min(distances(:));
    [xentr,yentr] = ind2sub([n,n],ind);
    %merge the corresponding index-clusters
    C{min(xentr,yentr)} = [C{xentr},C{yentr}];
    C{max(xentr,yentr)} = [];

    %%% patching the distance-matrix up for the next step
    mergeInto = min(xentr,yentr); %merge them into the lower index
    mergeFrom = max(xentr,yentr); %and from the higher index
                                  %we don't move the n-th row into the
                                  %higher index because that's just
                                  %cosmetics
    
    %single link takes the smaller number, complete linkage the bigger number
    %because we only ever merge 2 clusters who already fulfill the
    %respective property this property is not lost in this step.
    if single_link
        distances(mergeInto,:) = min([distances(xentr,:);distances(yentr,:)]);
        distances(:,mergeInto) = min([distances(xentr,:);distances(yentr,:)]);
    else
        distances(mergeInto,:) = max([distances(xentr,:);distances(yentr,:)]);
        distances(:,mergeInto) = max([distances(xentr,:);distances(yentr,:)]);
    end
    %by doing this the min funtion returns the correct value in the next
    %iteration
    distances(mergeInto,mergeInto) = Inf;
    distances(xentr,yentr) = Inf;
    distances(yentr,xentr) = Inf;       
    distances(mergeFrom,:) = Inf([200,1]);
    distances(:,mergeFrom) = Inf([200,1]);
end


%plotting
figure();
hold on;
for i = 1:n
    if ~(isempty(C{i}))
        plot(pts(C{i},1),pts(C{i},2),'o')
    end
end

