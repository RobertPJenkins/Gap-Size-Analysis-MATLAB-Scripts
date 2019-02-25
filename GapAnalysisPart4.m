%Here we create the image with the randomly coloured discs overlaid onto the white fibres.
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\CHANGE THESE!!!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%Directory of binary image of collagen fibre
directoryDataOutOverlay='X:\Rob\Chris\GapAnalysis150415\EgOutputData\';
%Directory of circles and locations.
directoryImagesOutOverlay='X:\Rob\Chris\GapAnalysis150415\EgOutputImages\'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%File extraction info
file_namesOverlayStage3=[directoryDataOutOverlay '*Stage3.mat'];
filesOverlayStage3=dir(file_namesOverlayStage3);
file_namesOverlayStage1=[directoryDataOutOverlay '*Stage1.mat'];
filesOverlayStage1=dir(file_namesOverlayStage1);


for filenoOverlay=1:length(filesOverlayStage1)
    close all
    %Loading the binary fibre information
    [~, nameOverlayStage1, extension]=fileparts(filesOverlayStage1(filenoOverlay).name);
    input_nameOverlayStage1=[directoryDataOutOverlay nameOverlayStage1 extension];
    load(input_nameOverlayStage1);
    clearvars -except bw directoryDataOutOverlay  directoryImagesOutOverlay file_namesOverlayStage1 filesOverlayStage1 file_namesOverlayStage3 filesOverlayStage3 nameOverlayStage1 input_nameOverlayStage1 filenoOverlay
    %loading the circle information
    [~, nameOverlayStage3, extension]=fileparts(filesOverlayStage3(filenoOverlay).name);
    input_nameOverlayStage3=[directoryDataOutOverlay nameOverlayStage3 extension];
    load(input_nameOverlayStage3);
    clearvars -except bw directoryDataOutOverlay  directoryImagesOutOverlay file_namesOverlayStage1 filesOverlayStage1 file_namesOverlayStage3 filesOverlayStage3 nameOverlayStage1 input_nameOverlayStage1 filenoOverlay input_nameOverlayStage3 nameOverlayStage3 stored_R stored_index
    [irows,icols]=size(bw);%size of the fibre image
     
    
    
    %We only plot circles above a certain size.
    circle_cutoff_size=2;% We do not consider circles of radius smaller than this value
    index=find(stored_R<circle_cutoff_size);
    stored_R2=stored_R;stored_index2=stored_index;%The locations of all circles of radius equal to or greater than circle_cutoff_size are stored in the vectors stored_R2 and stored_index2
    stored_R2(index)=[];
    stored_index2(index)=[];

    %final_colour provides a random colour for each disk and produces an image from all the disks.
    final_colour=zeros(irows,icols,3);
    %Loop to overlay randomly colured circles onto fibres.
    %stored_R2 gives the radius of each circle.
    %stored_index2 gives the centroid index of each circle.
    for(i=1:length(stored_R2))
        i
        %For each circle we generate a matrix just with this circle in it.
        map=zeros(irows,icols);
        map(stored_index2(i))=1;
        SE=strel('disk',stored_R2(i),0);
        map=imdilate(map,SE);%construct an image mask for each circle and store in the temporary matrix map.
        %We make a new matrix colour_temp of this randomly coloured circle.
        a=rand(1)*255;
        b=rand(1)*255;
        c=rand(1)*255;
        colour_temp=zeros(irows,icols,3);
        colour_temp(:,:,1)=map*a;
        colour_temp(:,:,2)=map*b;
        colour_temp(:,:,3)=map*c;
        %We add this random coloured disc to final_colour to produce an overall image of these coloured discs.
        final_colour=final_colour+colour_temp;
    end;

    %We then create an overall image made up of the collagen (in bw_colour)
    %and the circles (final_colour)
    bw_colour=zeros(irows,icols,3);%Create a white (but colour) image of the skeletonized collagen.
    bw_colour(:,:,1)=255*bw;
    bw_colour(:,:,2)=255*bw;
    bw_colour(:,:,3)=255*bw;
    image=figure;imshow(uint8(final_colour+bw_colour))%Show the cloured circles and skeletonized collagen.
    %Save the images.
    nameOverlayStage3(end-6:end)=[];
    image_file_save_name=[directoryImagesOutOverlay nameOverlayStage3 '_ColouredCircles.tif'];
    print(image,'-djpeg',image_file_save_name);
end;    