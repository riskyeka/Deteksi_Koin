clc
clear all
img = imread('coins.jpg');
J = rgb2gray(img);
J = im2bw(img);
J = imcomplement(J);
J = imfill(J,'holes');
imshowpair(img,J,'montage');