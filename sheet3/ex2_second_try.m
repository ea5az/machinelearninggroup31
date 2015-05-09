clear all; close all;
load('points.mat');

C = cell([200,1]);
n = length(pts);

single_link = false; %false for complete linkage

for i = 1:n
    C{i} = i;
end
%calculate complete distance matrix once
distances = pdist2(pts,pts);
distances(distances==0)=Inf;
for i= n:-1:6
    %get smallest distance
    [~,ind] = min(distances(:));
    [xentr,yentr] = ind2sub([n,n],ind);
    C{min(xentr,yentr)} = [C{xentr},C{yentr}];
    C{max(xentr,yentr)} = [];

    %%% patching the matrix up for the next step
    mergeInto = min(xentr,yentr);
    mergeFrom = max(xentr,yentr);
    
    if single_link
        distances(mergeInto,:) = min([distances(xentr,:);distances(yentr,:)]);
        distances(:,mergeInto) = min([distances(xentr,:);distances(yentr,:)]);
    else
        distances(mergeInto,:) = max([distances(xentr,:);distances(yentr,:)]);
        distances(:,mergeInto) = max([distances(xentr,:);distances(yentr,:)]);
    end
    distances(mergeInto,mergeInto) = Inf;
    distances(xentr,yentr) = Inf;
    distances(yentr,xentr) = Inf;       
    distances(mergeFrom,:) = Inf([200,1]);
    distances(:,mergeFrom) = Inf([200,1]);
end



figure();
hold on;
for i = 1:n
    if ~(isempty(C{i}))
        plot(pts(C{i},1),pts(C{i},2),'o')
    end
end

%high = max([distances(xentr,:);distances(yentr,:)])

