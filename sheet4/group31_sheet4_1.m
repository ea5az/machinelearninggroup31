close all;

img = imread('parrot.jpg');
%imshow(img);

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

pts = double([X,Y,Z]);

%scatter3(X,Y,Z)
%%
colclust64sing = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'single');
colclust16sing = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'single');
colclust8sing = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'single');


%%

colors64sing = zeros([64,3],'uint8');
colors16sing = zeros([16,3],'uint8');
colors8sing = zeros([8,3],'uint8');

for i = 1:64
   colors64sing(i,:) = uint8(mean(pts(colclust64sing==i,:)));
end
for i = 1:16
   colors16sing(i,:) = uint8(mean(pts(colclust16sing==i,:)));
end
for i = 1:8
   colors8sing(i,:) = uint8(mean(pts(colclust8sing==i,:)));
end

%%
close all;
hold on;
imshow(reshape(colclust64sing,[86,128]),colors64sing);
figure()
imshow(reshape(colclust16sing,[86,128]),colors16sing);
figure()
imshow(reshape(colclust8sing,[86,128]),colors8sing);



%%
colclust64comp = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'complete');
colclust16comp = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'complete');
colclust8comp = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'complete');

%%

colors64comp = zeros([64,3],'uint8');
colors16comp = zeros([16,3],'uint8');
colors8comp = zeros([8,3],'uint8');

for i = 1:64
   colors64comp(i,:) = uint8(mean(pts(colclust64comp==i,:)));
end
for i = 1:16
   colors16comp(i,:) = uint8(mean(pts(colclust16comp==i,:)));
end
for i = 1:8
   colors8comp(i,:) = uint8(mean(pts(colclust8comp==i,:)));
end
%%
close all;
hold on;
imshow(reshape(colclust64comp,[86,128]),colors64comp);
figure()
imshow(reshape(colclust16comp,[86,128]),colors16comp);
figure()
imshow(reshape(colclust8comp,[86,128]),colors8comp);

%%
colclust64avrg = clusterdata(pts , 'maxclust' ,64 , 'linkage' , 'average');
colclust16avrg = clusterdata(pts , 'maxclust' ,16 , 'linkage' , 'average');
colclust8avrg = clusterdata(pts , 'maxclust' ,8 , 'linkage' , 'average');

%%

colors64avrg = zeros([64,3],'uint8');
colors16avrg = zeros([16,3],'uint8');
colors8avrg = zeros([8,3],'uint8');

for i = 1:64
   colors64avrg(i,:) = floor(mean(pts(colclust64avrg==i,:)));
end
for i = 1:16
   colors16avrg(i,:) = floor(mean(pts(colclust16avrg==i,:)));
end
for i = 1:8
   colors8avrg(i,:) = floor(mean(pts(colclust8avrg==i,:)));
end

%%
close all;
hold on;
imshow(reshape(colclust64avrg,[86,128]),colors64avrg);
figure()
imshow(reshape(colclust16avrg,[86,128]),colors16avrg);
figure()
imshow(reshape(colclust8avrg,[86,128]),colors8avrg);

%%
colclust64centr = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'centroid');
colclust16centr = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'centroid');
colclust8centr = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'centroid');

%%
colors64centr = zeros([64,3],'uint8');
colors16centr = zeros([16,3],'uint8');
colors8centr = zeros([8,3],'uint8');

for i = 1:64
   colors64centr(i,:) = floor(mean(pts(colclust64centr==i,:)));
end
for i = 1:16
   colors16centr(i,:) = floor(mean(pts(colclust16centr==i,:)));
end
for i = 1:8
   colors8centr(i,:) = floor(mean(pts(colclust8centr==i,:)));
end

%%
close all;
hold on;
imshow(reshape(colclust64centr,[86,128]),colors64centr);
figure()
imshow(reshape(colclust16centr,[86,128]),colors16centr);
figure()
imshow(reshape(colclust8centr,[86,128]),colors8centr);
