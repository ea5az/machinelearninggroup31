close all;

img = imread('parrot.jpg');
%imshow(img);

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

pts = double([X,Y,Z]);
%%
%Allocate and intialize
n = length(pts);
C = cell([n,1]);

single_link = false; %false for complete linkage
   
%create single element clusters for the start
%we represent the points with their indeces
for i = 1:n
    C{i} = i;
end
%calculate complete distance matrix once
distances = pdist2(pts,pts);
distances(distances==0)=Inf;

numclusts = n;
%%
tic()
[sorted,indices] = sort(distances(:));
toc()
%%
tic()
[Xind,Yind] = ind2sub([n,n],indices);
toc()
%%
%now merge clusters 195 times -> 5 clusters left
lookup = [indices ; zeros([n,1])];
%%
tic()

ptr = 1;

bit8 = cell([n,1]);
bit16 = cell([n,1]);
bit64 = cell([n,1]);

for i= n:-1:5
    numclusts   %get smallest distance 0.24 sec
    while isinf(distances(lookup(ptr)))
        ptr = ptr + 1;
    end
    xentr = Xind(ptr);
    yentr = Yind(ptr);
    %[~,ind] = min(distances(:));
    %[xentr,yentr] = ind2sub([n,n],ind);
    %merge the corresponding index-clusters 0.000036 sec
    C{min(xentr,yentr)} = [C{xentr},C{yentr}];
    C{max(xentr,yentr)} = [];
    %%% patching the distance-matrix up for the next step 0.000016 sec
    mergeInto = min(xentr,yentr); %merge them into the lower index
    mergeFrom = max(xentr,yentr); %and from the higher index
                                  %we don't move the n-th row into the
                                  %higher index because that's just
                                  %cosmetics
    %single link takes the smaller number, complete linkage the bigger number
    %because we only ever merge 2 clusters who already fulfill the
    %respective property this property is not lost in this step. 0.0059 sec
    if single_link
        distances(mergeInto,:) = min([distances(xentr,:);distances(yentr,:)]);
        distances(:,mergeInto) = min([distances(xentr,:);distances(yentr,:)]);
    else % 0.009 sec
        mask1 = double((distances(xentr,:)>distances(yentr,:)));
        mask1(mask1==0) = Inf;
        mask2 = double((distances(xentr,:)<=distances(yentr,:)));
        mask2(mask2==0) = Inf;
        distances(xentr,:) = distances(xentr,:).*mask1;
        distances(:,xentr) = distances(xentr,:).*mask1;
        distances(yentr,:) = distances(yentr,:).*mask2;
        distances(:,yentr) = distances(yentr,:).*mask2;
        
        %distances(mergeInto,:) = max([distances(xentr,:);distances(yentr,:)]);
        %distances(:,mergeInto) = max([distances(xentr,:);distances(yentr,:)]);
    end
    %by doing this the min funtion returns the correct value in the next
    %iteration 0.008859 sec
    distances(mergeInto,mergeInto) = Inf;
    distances(xentr,yentr) = Inf;
    distances(yentr,xentr) = Inf;       

    numclusts = numclusts - 1;
    
    if numclusts == 64
        bit64 = C;
    elseif numclusts == 16
        bit16 = C;
    elseif numclusts == 8
        bit8 = C;
    end
end
toc()
%%
hold on;
for i = 1:n
    if ~(isempty(C{i}))
        scatter3(pts(C{i},1),pts(C{i},2),pts(C{i},3)); 
    end
end