close all;

img = imread('parrot.jpg');

resol = size(img);
height = resol(1);
width = resol(2);
%imshow(img);

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

[pts,~,ic] = unique(double([X,Y,Z]),'rows');
%pts = double([X,Y,Z]);
%%
%start of sample solution last time
no = size(pts,1);
clusters = cell(no,1);
d = pdist2(pts,pts);

useCompleteLinkage = 0;

for i = 1:no
    clusters{i} = i;
    d(i,i) = inf;        
end 

while (size(clusters,1) > 8) %changed this to 8
    size(clusters,1)
    % find closest elements
    minDist = min(min(d));
    [r,c] = find(d==minDist);
    r = r(1);
    c=c(1);
    % merge clusters r and c
    clusters{r} = [clusters{r},clusters{c}];
    clusters(c) = [];
    % update distance
    if (useCompleteLinkage)
        % complete linkage
        d(r,:) = max([d(r,:);d(c,:)],[],1);

    else
        % single linkage
        d(r,:) = min([d(r,:);d(c,:)],[],1);
    end
    d(:,r) = d(r,:)';
    d(r,r) = inf;
    d(c,:) = [];
    d(:,c) = [];

end
%%
figure;
col = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;0,0,0];
for i = 1:5
    ix = clusters{i}';
    hold on;
    scatter(pts(ix,1),pts(ix,2),'*','MarkerEdgeColor',col(i,:));    
end

figure;
if (useCompleteLinkage)
     T = clusterdata(pts,'maxclust',5,'linkage','complete');
else
    T = clusterdata(pts,'maxclust',5,'linkage','single');
end
 for i = 1:5
    ix = find(T==i);
    hold on;
    scatter(pts(ix,1),pts(ix,2),'*','MarkerEdgeColor',col(i,:));    
end
