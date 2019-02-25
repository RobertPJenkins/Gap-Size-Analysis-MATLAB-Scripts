%This script includes preprocessing to images to make them binary, remove
%small objects and reduce the resolution of the image.
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\CHANGE THESE!!!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%The directory for tif files to be read in.
directory='X:\Rob\Chris\GapAnalysis150415\EgInputImages\';
%The directory to save data to.
directoryDataOut='X:\Rob\Chris\GapAnalysis150415\EgOutputData\';
%The directory to save the processed tif images to.
directoryImagesOut='X:\Rob\Chris\GapAnalysis150415\EgOutputImages\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%File info
file_names=[directory '*.tif'];
files=dir(file_names);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\CHANGE THESE!!!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%The number of images to analyse
NoFiles=2;
%The level at which you threshold each image to convert to binary.
ThresholdLevel=0.001;
%The size of objects below which you wish to remove.
RemoveObjectSize=10;
%The factor to resize your objects by. Below around 300by300 or below is
%best if you have lots of images to process.
ResizeImage=0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

for i=1:2
    
    %Reading the tif info into matrix I.   
    [~, name, extension]=fileparts(files(i).name);
    input_name=[directory name extension];
    I=imread(input_name);
    
    %Basic image processing
    %figure;imshow(I)
    I1=im2bw(I,ThresholdLevel);%Threshold image at desired level. I is now binary.
    %figure;imshow(I1);
    I2=bwareaopen(I1, RemoveObjectSize, 8);%Removes objects below size 'RemoveObjectSize'. Pixels are 8-connected in 2d space. I.e. connected diagonally.
    %figure;imshow(I2)
    bw=imresize(I2,ResizeImage);%Resize your object.
    image=figure;imshow(bw)
    
    %Save the binary resized image (bw) as a .mat file with subscript '_Stage1'
    %and also save the tif of the binary image.
    mat_file_save_name=[directoryDataOut name '_Stage1'];
    save(mat_file_save_name, 'bw');
    image_file_save_name=[directoryImagesOut name '_Stage1.tif'];
    print(image,'-djpeg',image_file_save_name);
    close all
    clearvars -except directory directoryDataOut directoryImagesOut  filenames files ThresholdLevel RemoveObjectSize ResizeImage i NoFiles
end