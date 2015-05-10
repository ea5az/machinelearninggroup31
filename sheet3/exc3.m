clear all; close all;
load('points.mat');

C = cell([200,1]);
n = length(pts);

average_linkage = false; %false for centroid_clusteringe

for i = 1:n
    C{i} = i;
end
%calculate complete distance matrix once
distances = pdist2(pts,pts);
distances(distances==0)=Inf;
min_distance = 0;

stop_distance = 0.8;


while min_distance < stop_distance
    %get smallest distance
    [~,ind] = min(distances(:));
    [xentr,yentr] = ind2sub([n,n],ind);
    C{min(xentr,yentr)} = [C{xentr},C{yentr}];
    C{max(xentr,yentr)} = [];

    %%% patching the matrix up for the next step
    mergeInto = min(xentr,yentr);
    mergeFrom = max(xentr,yentr);
    
    
    if average_linkage
        for j = 1:200
            if (j ~= mergeInto) && (j ~= mergeFrom) && ~(isempty(C{j}))
                factor = 1./(length([C{mergeInto},C{mergeFrom}])*length(C{j}));
                d_mean = factor * sum(sum(pdist2(pts([C{mergeInto},C{mergeFrom}],:),pts(C{j},:))));
                distances(mergeInto,j) = d_mean;
                distances(j,mergeInto) = d_mean;
            else
                distances(mergeInto,j) = Inf;
                distances(j,mergeInto) = Inf;
            end
        end
    else
        for j = 1:200
            if (j ~= mergeInto) && (j ~= mergeFrom) && ~(isempty(C{j}))
                x_1 = (1./length([C{mergeInto},C{mergeFrom}]))*sum(pts([C{mergeInto},C{mergeFrom}],:),1);
                x_2 = (1./length(C{j}))*sum(pts(C{j},:),1);
                
                d_centroid = sqrt(sum((x_1-x_2).^2));
                distances(mergeInto,j) = d_centroid;
                distances(j,mergeInto) = d_centroid;
            else
                distances(mergeInto,j) = Inf;
                distances(j,mergeInto) = Inf;
            end
            distances(mergeInto,:) = min([distances(xentr,:);distances(yentr,:)]);
            distances(:,mergeInto) = min([distances(xentr,:);distances(yentr,:)]);
        end
    end
        
    distances(mergeInto,mergeInto) = Inf;
    distances(xentr,yentr) = Inf;
    distances(yentr,xentr) = Inf;       
    distances(mergeFrom,:) = Inf([200,1]);
    distances(:,mergeFrom) = Inf([200,1]);
    
    min_distance = min(distances(mergeInto,:));
end



figure();
hold on;
for i = 1:n
    if ~(isempty(C{i}))
        plot(pts(C{i},1),pts(C{i},2),'o')
    end
end

%high = max([distances(xentr,:);distances(yentr,:)])

