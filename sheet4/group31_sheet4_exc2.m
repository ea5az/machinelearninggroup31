close all;

img = imread('parrot.jpg');

%imshow(img);

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

pts = double([X,Y,Z]);
n = length(pts);

t = 0;

K = 64;

w = zeros([K,3],'double');

for i = 1:K
    w(i,:) = randi([0,255],[3,1]);
end

%scatter3(w(:,1),w(:,2),w(:,3));

diff = Inf;
eps = 0.5;

while diff > eps
    diff
    C = cell([K,1]);
    
    for i = 1:n
        [~,kstar] = min(pdist2(pts(i,:) , w));
        C{kstar} = [C{kstar} ; pts(i,:)];
    end
    
    wold = w;
    for k = 1:K
        if ~(isempty(C{k}))
            w(k,:) = (1./length(C{k}))*sum(C{k});
        else
            wold(k,:) = [Inf,Inf,Inf];
        end
    end
    
    diff = min(sqrt(sum((w-wold).^2,2)));
end


% close all;
% hold on;
% %subplot(1,2,1)
% %scatter3(pts(:,1),pts(:,2),pts(:,3))
% %subplot(1,2,2)
% for i = 1:K
%     if ~(isempty(C{i}))
%         scatter3(C{i}(:,1),C{i}(:,2),C{i}(:,3))
%     end
%end

indpic = zeros([n,1]);
indices = zeros([n,1]);
for i = 1:K
    if ~(isempty(C{i}))
        inds = find(ismember( pts,C{i},'rows'));
        indpic(inds) = i;
    end
end

indpic = reshape(indpic,[86,128]);
colmap = uint8(w);

imshow(indpic,colmap)

