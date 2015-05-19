close all;

img = imread('parrot.jpg'); %importing low res picture

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

pts = double([X,Y,Z]); % extracting color vectors and putting them back together
n = length(pts);

Kvals = [8,16,64]; % for different compression rates
for cnt = 1:3
    K = Kvals(cnt);
    
    w = zeros([K,3],'double');

    for i = 1:K %create random initial vectors
        w(i,:) = randi([0,255],[3,1]);
    end

    diff = Inf; % initial difference is big
    eps = 0.5; 

    while diff > eps % while the reference vectors are still changing significantly
        diff % print current difference
        C = cell([K,1]);

        for i = 1:n % assign each vector to its nearest reference vector
            [~,kstar] = min(pdist2(pts(i,:) , w));
            C{kstar} = [C{kstar} ; pts(i,:)];
        end

        wold = w; % update reference vector to be at the center of cluster
        for k = 1:K
            if ~(isempty(C{k}))
                w(k,:) = (1./length(C{k}))*sum(C{k});
            end
        end

        diff = max(sqrt(sum((w-wold).^2,2))); % what was the biggest change that occured? 
    end

    indpic = zeros([n,1]);
    indices = zeros([n,1]);
    for i = 1:K % assemble picture from clusters
        if ~(isempty(C{i}))
            inds = find(ismember( pts,C{i},'rows'));
            indpic(inds) = i;
        end
    end

    indpic = reshape(indpic,[86,128]);
    colmap = uint8(w);
     
    close all;
    figure() % and display it
    imshow(indpic,colmap)
    print(strcat('kmeans',int2str(K)),'-dpng')
end
