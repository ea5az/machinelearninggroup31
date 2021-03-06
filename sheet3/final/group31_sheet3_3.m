clear all; close all;
load('points.mat');

%Allocate and intialize
C = cell([200,1]);
n = length(pts);

average_linkage = true; %false for centroid_clusteringe

%create single element clusters for the start
%we represent the points with their indeces
for i = 1:n
    C{i} = i;
end

%calculate complete distance matrix once
distances = pdist2(pts,pts);
distances(distances==0)=Inf;
min_distance = 0;

%try different stop conditions - doesn't take too long.
stop_distances = linspace(0.05 , 0.65 , 15);
figure();

for index = 1:15
    stop_distance = stop_distances(index);

    %while the distance between the last two merged clusters (and 
    %therefore the last two closest clusters) is smaller than the current
    %condition we continue merging
    while min_distance < stop_distance
        %get smallest distance
        [~,ind] = min(distances(:));
        [xentr,yentr] = ind2sub([n,n],ind);
        %merge the corresponding index-clusters
        C{min(xentr,yentr)} = [C{xentr},C{yentr}];
        C{max(xentr,yentr)} = [];

        %%% patching the matrix up for the next step
        mergeInto = min(xentr,yentr); %merge them into the lower index
        mergeFrom = max(xentr,yentr); %and from the higher index
                                      %we don't move the n-th row into the
                                      %higher index because that's just
                                      %cosmetics
                                      
        %for average linkage: we have to recalculate the distance from the
        % current cluster to all other non-empty clusters. We use the
        % pdist2 funtion to get all distances between the elements of the
        % two clusters (that's also where the scalar 2 in factor comes
        % from, the pdist2 matrix is symmetric).
        %for centroid_clustering: similar procedure only that we don't need
        % the pdsit2 function here since we only have to compute the distance
        % between the average clusters.
        if average_linkage
            for j = 1:200
                if (j ~= mergeInto) && (j ~= mergeFrom) && ~(isempty(C{j}))
                    factor = 1./(2*length(C{mergeInto})*length(C{j}));
                    d_mean = factor * sum(sum(pdist2(pts(C{mergeInto},:),pts(C{j},:))));
                    distances(mergeInto,j) = d_mean;
                    distances(j,mergeInto) = d_mean;
                else %its one of the two clusters that we are merging currently
                     %or the cluster is already empty
                    distances(mergeInto,j) = Inf;
                    distances(j,mergeInto) = Inf;
                end
            end
        else
            for j = 1:200
                if (j ~= mergeInto) && (j ~= mergeFrom) && ~(isempty(C{j}))
                    x_1 = (1./length(C{mergeInto}))*sum(pts(C{mergeInto},:),1);
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
        
        %patching it up
        distances(mergeInto,mergeInto) = Inf;
        distances(xentr,yentr) = Inf;
        distances(yentr,xentr) = Inf;       
        distances(mergeFrom,:) = Inf([200,1]);
        distances(:,mergeFrom) = Inf([200,1]);
        %get the minimal distance between two clusters
        min_distance = min(distances(mergeInto,:));
    end

    %plotting
    subplot(5,3,index);
    hold on;
    cnt = 0;
    for i = 1:n
        if ~(isempty(C{i}))
            plot(pts(C{i},1),pts(C{i},2),'o')
            cnt = cnt+1;
        end
    end
    title(strvcat(strcat('# of clusters: ' , num2str(cnt)) , strcat(' stop_distance: ' , num2str(stop_distance))));
    hold off;
end

