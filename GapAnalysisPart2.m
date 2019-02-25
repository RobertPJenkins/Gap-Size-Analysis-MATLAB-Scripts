%In this script we search for the maximum circle that can be placed at any
%given point in the image (such that it fits entirley on the image and it
%does not overlap with fibres.
clear
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\CHANGE THIS!!!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%This is the folder where the data for each image is stored. The data needs
%to already have been preprocessed such that we load data corresponding to
%the binary processed image.
directoryData='X:\Rob\Chris\GapAnalysis150415\EgOutputData\'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

%We search for files ending in 'Stage1.mat' as saved in the last stage and analyse each in turn.
file_names=[directoryData '*Stage1.mat'];
files=dir(file_names);

for fileno=1:length(files)
    [~, name, extension]=fileparts(files(fileno).name);
    input_name=[directoryData name extension];
    load(input_name);
    %The only data in each .mat file is bw. This is a binary matrix giving
    %the representation of your processed tif file.
    [irows,icols]=size(bw);%Calculates size of bw matrix.
    
    %We ignore pixels on the boundary as we wish to consider disks of at least radius 1. We record the index of pixels not on
    %the boundary.
    %These are recorded in index notation.
    index_start=irows+1;%Where we start the iterations.
    index_end=irows*(icols-1);% The end of the iterative scheme (in index terms) to avoid the boundary of the image
    total_pixels=index_end-index_start+1;%Total number of pixels in the image that we wish to determine maximum disk size for.
    
    R=zeros(index_end,1);%To store the maximum radius at each pixel location in the image.

    map1=zeros(irows,icols);%A temporary matrix to store a disk of radius r at location i. 


    %For each pixel, we find the maximum radius that a
    %circle can possess and still fit completely in the image. These values are
    %stored in the matrix xy_rad.
    %Max radius in x dimension
    x_low=meshgrid(1:icols,1:irows);
    x_low=x_low-1;
    x_high=meshgrid(1:icols,1:irows);
    x_high=icols-x_high;
    x_val=min(x_low,x_high);
    x_val=max(x_val,0);
    %Max radius in y dimension
    y_low=meshgrid(1:irows,1:icols)';
    y_low=y_low-1;
    y_high=meshgrid(1:irows,1:icols)';
    y_high=irows-y_high;
    y_val=min(y_low,y_high);
    y_val=max(y_val,0);
    %Stores the overall maximum radius possible for each pixel 
    xy_rad=min(x_val,y_val);

    %For each pixel not on the boundary of the image we analyse the maximum circle that can fit in the gaps in the image.  
    for i=index_start:index_end
        index_end-i%Timer
        %We do not consider the boundary of the image. Since we work in indices
        %this means ignoring all values in which mod(i,irows)=1 (top boundary in
        %y domain) and in which mod(i,irows)=0 (bottom boundary in y domain).
        %The column boundaries are taken into account via index_start and
        %index_end so we do not need to explicitely do so here.
        %We also consider only locations where a disk of radius 1 or above can
        %be constructed i.e. where the pixel and its neighbours are not fibres.
        if((mod(i,irows)~=1)||(mod(i,irows)~=0))&&((bw(i)==0)&&(bw(i+1)==0)&&(bw(i-1)==0)&&(bw(i+irows)==0)&&(bw(i-irows)==0))
            %In map we store the current pixel location
            map= false(irows,icols);
            map(i)=1;%Used to create location of centroid of the disk
            %min_radius and max_radius give the minimum and maximum radius
            %of the circle. They are updated iteratively as we search for
            %the maximum circle size.
            min_radius=1;
            max_radius=xy_rad(i);%The maximum possible radius that can fit entirely in the image.
            while ((max_radius-min_radius)>1)
                radtest=ceil((min_radius+max_radius)/2);%We test the circle with radius halfway between the max and min.
                %We create an disk of radius radtest at location i.
                SE=strel('disk',radtest,0);
                map1=imdilate(map,SE);
                %map1_bw gives the fibre matrix added to the circle matrix.
                map1_bw=map1+bw;
                if(max(map1_bw(:))>1)
                    %If the maximum is greater than 1 then the circle must
                    %overlap with the fibres. Therefore, the max_radius is then
                    %reset to reflect this
                    max_radius=radtest;
                else
                    %If the maximum is equal to one then the circle does
                    %not overlap with the fibres and we can increase
                    %min_radius accordingly.
                    min_radius=radtest;
                end;
            end;
            %When the gap between min_radius and max_radius is only one we
            %run one final iteration to find the maximum circle radius.
            %We store this in R.
            radtest=max_radius;
            SE=strel('disk',radtest,0);
            map1=imdilate(map,SE);
            map1_bw=map1+bw;%We create an disk of radius r at location i.
            if(max(map1_bw(:))>1)
               R(i)=min_radius;
            else
               R(i)=max_radius;
            end;
            
            
        end;
    end;
    %Here we save the data
    name(end-6:end)=[];
    mat_file_save_name=[directoryData name '_Stage2'];
    save(mat_file_save_name,'irows', 'icols', 'R');
    clearvars -except directoryData file_names files fileno
end;