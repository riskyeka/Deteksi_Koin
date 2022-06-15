%% membersihkan display command window dan menghapus variable tersimpan 
clc
clear all
%% membaca citra rgb
img = imread('coins.jpg');
%% mengkonversi citra rgb menjadi grayscale
J = rgb2gray(img);
%% mengkonversi citra grayscale menjadi biner
J = im2bw(J,graythresh(J));
%% melakukan komplemen citra agar objek bernilai satu dan background bernilai nol
J = imcomplement(J);
%% operasi morfologi untuk menyempurnakan hasil segmentasi area opening untuk menghilangkan noise
J = bwareaopen(J,100);
%% filling holes untuk mengisi objek yang berlubang
J = imfill(J,'holes');
%% closing untuk membuat bentuk objek lebih smooth
str = strel('disk',5);
J = imclose(J,str);
%% menghilangkan objek yang menempel pada border(tepian citra)
J = imclearborder(J);
%% pelabelan terhadap masing2 objek
[B,L] = bwlabel(J);
stats = regionprops(B,'All');
%% mengkonversi citra rgb menjadi YCbCr
YCbCr = rgb2ycbcr(img);
%% mengekstrak komponen Cb(Chrominance-blue)
Cb = YCbCr(:,:,2);
%% menampilkan citra rgb
figure, imshow(img);
hold on
%% membuat boundary pada koin yang terdeteksi
Boundaries = bwboundaries(J,'noholes');
%% untuk n=1 s/d n=jumlah objek
for n=1:L
    boundary = Boundaries{n};
    
    %menghitung nilai Cb dari masing2 objek
    bw_label = (B==n);
    Cb_label = immultiply(Cb,bw_label);
    Cb_label = (sum(sum(Cb_label)))/(sum(sum(bw_label)));
    
    %menghitung luas dan centroid masing2 objek
    Area = stats(n).Area;
    centroid = stats(n).Centroid;
    
    %jika nilai Cb > 115 maka dikenali sebagai koin silver
    if Cb_label > 115
        %jika luas < 160000 maka dikenali sebagai koin 1000
        if Area < 160000
            nilai = 1000;
        %jika luas > 160000 maka dikenali sebagai koin 500
        else
            nilai = 500;
        end
        
        %menampilkan boundary pada objek
        plot(boundary(:,2), boundary(:,1), 'y', 'LineWidth', 4)
        
        %menampilkan nilai koin pada centroid objek
        text(centroid(1)-50,centroid(2),num2str(nilai),...
            'Color','y','FontSize',20,'FontWeight','bold');
        
        %jika nilai Cb < 115 maka dikenali sebagai koin kuning
    else
        %jika luas < 160000 maka dikenali sebagai koin 500
        if Area < 160000 
            nilai = 500; 
        %jika luas > 160000 maka dikenali sebagai koin 1000
        else
            nilai = 1000;
        end
        
        %menampilkan boundary pada objek
        plot(boundary(:,2), boundary(:,1), 'c', 'LineWidth', 4)
        
        % menampilkan nilai koin pada centroid objek
        text(centroid(1)-50,centroid(2),num2str(nilai),...
            'Color','c','FontSize',20,'FontWeight','bold');
    end
end