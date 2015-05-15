close all;

img = imread('parrot.jpg');
%imshow(img);

X = img(:,:,1); X = X(:);
Y = img(:,:,2); Y = Y(:);
Z = img(:,:,3); Z = Z(:);

pts = double([X,Y,Z]);
%%