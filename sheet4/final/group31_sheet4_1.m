close all;

img = imread('parrot.jpg'); %choose a picture
%img = imread('parrot_med.png'); %
%img = imread('parrot_big.png'); % these work as well

resol = size(img); %get its specs
height = resol(1);
width = resol(2);

X = img(:,:,1); X = X(:); %extract individual color vectors
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

[pts,~,ic] = unique(double([X,Y,Z]),'rows'); %and put them back together, removing duplicates

%single linkage clustering, we're using the built-in function since we
%can't get the solution from last time to run in a reasonable time
colclust64sing = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'single');
colclust16sing = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'single');
colclust8sing = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'single');

colors64sing = zeros([64,3],'uint8'); %creating the respective color maps
colors16sing = zeros([16,3],'uint8');
colors8sing = zeros([8,3],'uint8');

for i = 1:64
   colors64sing(i,:) = uint8(mean(pts(colclust64sing==i,:))); %we average over the represented color vectors in the clusters
end
for i = 1:16
   colors16sing(i,:) = uint8(mean(pts(colclust16sing==i,:)));
end
for i = 1:8
   colors8sing(i,:) = uint8(mean(pts(colclust8sing==i,:)));
end

close all; % plotting and outputting picture files
hold on;
imshow(reshape(colclust64sing(ic),[height,width]),colors64sing);
print('sing64','-dpng')
figure()
imshow(reshape(colclust16sing(ic),[height,width]),colors16sing);
print('sing16','-dpng')
figure()
imshow(reshape(colclust8sing(ic),[height,width]),colors8sing);
print('sing8','-dpng')


%and repeat for complete-linkage
colclust64comp = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'complete');
colclust16comp = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'complete');
colclust8comp = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'complete');



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

close all;
hold on;
imshow(reshape(colclust64comp(ic),[height,width]),colors64comp);
print('comp64','-dpng')
figure()
imshow(reshape(colclust16comp(ic),[height,width]),colors16comp);
print('comp16','-dpng')
figure()
imshow(reshape(colclust8comp(ic),[height,width]),colors8comp);
print('comp8','-dpng')


%and repeat for average linkage
colclust64avrg = clusterdata(pts , 'maxclust' ,64 , 'linkage' , 'average');
colclust16avrg = clusterdata(pts , 'maxclust' ,16 , 'linkage' , 'average');
colclust8avrg = clusterdata(pts , 'maxclust' ,8 , 'linkage' , 'average');



colors64avrg = zeros([64,3],'uint8');
colors16avrg = zeros([16,3],'uint8');
colors8avrg = zeros([8,3],'uint8');

for i = 1:64
   colors64avrg(i,:) = uint8(mean(pts(colclust64avrg==i,:)));
end
for i = 1:16
   colors16avrg(i,:) = uint8(mean(pts(colclust16avrg==i,:)));
end
for i = 1:8
   colors8avrg(i,:) = uint8(mean(pts(colclust8avrg==i,:)));
end


close all;
hold on;
imshow(reshape(colclust64avrg(ic),[height,width]),colors64avrg);
print('avrg64','-dpng')
figure()
imshow(reshape(colclust16avrg(ic),[height,width]),colors16avrg);
print('avrg16','-dpng')
figure()
imshow(reshape(colclust8avrg(ic),[height,width]),colors8avrg);
print('avrg8','-dpng')

%and repeat for centroid clustering
colclust64centr = clusterdata(pts , 'maxclust' , 64 , 'linkage' , 'centroid');
colclust16centr = clusterdata(pts , 'maxclust' , 16 , 'linkage' , 'centroid');
colclust8centr = clusterdata(pts , 'maxclust' , 8 , 'linkage' , 'centroid');


colors64centr = zeros([64,3],'uint8');
colors16centr = zeros([16,3],'uint8');
colors8centr = zeros([8,3],'uint8');

for i = 1:64
   colors64centr(i,:) = uint8(mean(pts(colclust64centr==i,:)));
end
for i = 1:16
   colors16centr(i,:) = uint8(mean(pts(colclust16centr==i,:)));
end
for i = 1:8
   colors8centr(i,:) = uint8(mean(pts(colclust8centr==i,:)));
end


close all;
hold on;
imshow(reshape(colclust64centr(ic),[height,width]),colors64centr);
print('centr64','-dpng')
figure()
imshow(reshape(colclust16centr(ic),[height,width]),colors16centr);
print('centr16','-dpng')
figure()
imshow(reshape(colclust8centr(ic),[height,width]),colors8centr);
print('centr8','-dpng')

