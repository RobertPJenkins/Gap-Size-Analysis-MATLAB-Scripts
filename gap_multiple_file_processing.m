%This script includes preprocessing to images to make them binary, remove
%small objects and reduce the resolution of the image.
clear
close all

%The directory for tif files to be read in.
directory='C:\documents\Gap Analysis\';
%The directory to save data to.
directoryDataOut='C:\documents\Gap Analysis\OutputData\';
%The directory to save the processed tif images to.
directoryImagesOut='C:\documents\Gap Analysis\OutputImages\';

%File info
file_names=[directory '*.jpg'];
files=dir(file_names);

%The number of images to analyse
NoFiles=8;
%The level at which you threshold each image to convert to binary.
ThresholdLevel=0.001;
%The size of objects below which you wish to remove.
RemoveObjectSize=10;
%The factor to resize your objects by. Below around 300by300 or below is
%best if you have lots of images to process.
ResizeImage=0.5;

for i=1:NoFiles
    
    %Reading the tif info into matrix I.   
    [~, name, extension]=fileparts(files(i).name);
    input_name=[directory name extension];
    I=imread(input_name);
    se = strel('disk',10);
    background = imopen(I,se);
    imshow(background);
    I=I - background;
    %Basic image processing
    I1=im2bw(I,ThresholdLevel);%Threshold image at desired level. I is now binary.
    I1=im2bw(I,graythresh(I(:)));%Threshold image at desired level. I is now binary.
    I2=bwareaopen(I1, RemoveObjectSize, 8);%Removes objects below size 'RemoveObjectSize'. Pixels are 8-connected in 2d space. I.e. connected diagonally.
    bw=imresize(I2,ResizeImage);%Resize your object.
    image=figure;imshow(bw)
    
    %Save the binary resized image (bw) as a .mat file 
    mat_file_save_name=[directoryDataOut name '_binary_data'];
    save(mat_file_save_name, 'bw');
    image_file_save_name=[directoryImagesOut name '_binary_image.tif'];
    print(image,'-djpeg',image_file_save_name);
    close all
    input_gap_matrix = bw;

    [...
          label_matrix,...
          radius_label_matrix,...
          centroid_row,...
          centroid_col,...
          circle_radius...
        ] = circle_gap_fitting(input_gap_matrix,1);
        ImName=[directoryImagesOut name '_overlaid_gaps.tif']
        circle_gap_plotting(label_matrix,ImName);

       mat_file_save_name=[directoryDataOut name '_gap_fitting_data'];
       save(mat_file_save_name);

       clearvars -except directory directoryDataOut directoryImagesOut  filenames files ThresholdLevel RemoveObjectSize ResizeImage i NoFiles
end