function hierarchical2()

    load('points');
    no = size(pts,1);
    clusters = cell(no,1);
    clustDist = pdist2(pts,pts);
    ptDist = clustDist;

    
    useCentroid =0;
    thresh = 0.48; % good for centroid and mean, difference visible at 0.8
    
    for i = 1:no
        clusters{i} = i;
        clustDist(i,i) = inf;
        
    end

   
    minDist = min(min(clustDist));
  
    while (minDist < thresh)
        
       
        [r,c] = find(clustDist==minDist);
        r = r(1);
        c=c(1);
        % merge clusters r and c
        clusters{r} = [clusters{r},clusters{c}];
      
        % get coordinates of points in new cluster
        clustPts = pts(clusters{r}',:);
        
        % update distance
        if (useCentroid)
            % centroid - distance to centers
            
            
            % get centroid 
            clustCentr = getClusterCentroid(clustPts);
            for i = 1:size(clustDist,1)
                clustDist(r,i) = pdist2(clustCentr, getClusterCentroid(pts(clusters{i}',:)));
            end
            
        else
            % mean - mean of all distances
            for y = 1:size(clustDist,1)
                clustY = pts(clusters{y}',:);
                s = 0;
                for i = 1:size(clusters{r},2)
                    for j = 1:size(clustY,1)
                        s = s+ptDist(clusters{r}(i),clusters{y}(j)) ;
                    end
                end
                clustDist(r,y) = 1/(size(clusters{r},2)*size(clusters{y},2))*s;
            end
        end
        clustDist(:,r) = clustDist(r,:)';
        clustDist(r,r) = inf;
        clustDist(c,:) = [];
        clustDist(:,c) = [];
        clusters(c) = [];
         % find closest elements
        minDist = min(min(clustDist));
        minDist
    end

    figure;
    col = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0;0.5,0.5,0.5;0.5,0,0;0,0.5,0;0,0,0.5];
    for i = 1:size(clusters,1)
        ix = clusters{i}';
        hold on;
        scatter(pts(ix,1),pts(ix,2),'*','MarkerEdgeColor',col(mod(i,size(col,1))+1,:));    
    end
    
end

function centr = getClusterCentroid(clustPts)
   % centr = [((max(clustPts(:,1))-min(clustPts(:,1)))/2+min(clustPts(:,1))),...
   %             ((max(clustPts(:,2))-min(clustPts(:,2)))/2+min(clustPts(:,2)))];
   centr = [1/size(clustPts,1) * sum(clustPts(:,1)),1/size(clustPts,1) * sum(clustPts(:,2))];
end