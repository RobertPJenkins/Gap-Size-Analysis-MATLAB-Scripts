%In this script we search for nonoverlapping cirlces. We find the largest
%circle in the image and then remove all other circles whose centroid is
%within the area enclosed by this circle. We also remove all circles that overlap 
%this largest circle. Subject to this we then search for the next largest circle and proceed as above. 
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\CHANGE THIS!!!\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%Directory where stage2 data is stored
directoryDataOutStage3='X:\Rob\Chris\GapAnalysis150415\EgOutputData\'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%/////////////////////////////////////////////////////////////////////////
%\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


%File access variables
file_namesStage3=[directoryDataOutStage3 '*Stage2.mat'];
filesStage3=dir(file_namesStage3);

for filenoStage3=1:length(filesStage3)
    %Load the data from Stage2
    [~, nameStage3, extension]=fileparts(filesStage3(filenoStage3).name);
    input_name=[directoryDataOutStage3 nameStage3 extension];
    load(input_name);
    clearvars -except directoryDataOutStage3 file_namesStage3 filesStage3 filenoStage3 irows icols R nameStage3

    

    %R gives the radius of maximum circle size at a given location in the
    %image matrix.
    %The index of this circle radius also corresponds to its index location in the image matrix. 
    Z=find(R>0);

    %We find all values in the radius vector R that
    %equal zero and remove these from R and Z (now called R1 and Z1).
    index=find(R==0);
    R1=R;Z1=Z;
    R1(index)=[];
    
    %We create a matrix that stores the maximum radius of a circle (that can
    %fit between fibres) with centroid located at the correct point
    %in R_mat.
    R_mat=zeros(irows,icols);
    R_mat(Z1)=R1;
    
    %Total number of circles to consider.
    R_len=length(R1);
    
    %We create two vectors, one to store the final radii or circles (stored_R) and one to
    %store locations (stored_index). The 3000 is arbitrarily set to speed up
    %the Matlab loop.
    stored_R=zeros(3000,1);
    stored_index=zeros(3000,1);

    %We use no_overlap to store regions in the matrix image that already
    %contain a disk. These regions are filled in with the number -999. Any new
    %disks that overlap onto this region are immediately discarded.
    no_overlap=zeros(irows,icols);

    %In this loop we search for the largest disks that can fit through the
    %collagen.
    %The counter gives a rough idea of how long the analysis will take.
    counter=0;
    %Each time we add the next largest circle to our results we set all values within the area of the circle to zero. 
    %Thus, eventually all elements in the circle will equal zero. Hence, the loop continues until all these values are zero.
    while(max(R_mat(:))>0)
        [R_max,R_ind]=max(R_mat(:));%Find the largest circle in the matrix and store the radius in R_max and the index in R_ind.
        %Create an image mask (map) with a circle of radius R_max at the point R_ind
        map=zeros(irows,icols);
        map(R_ind)=1;
        SE=strel('disk',R_max,0);
        map=imdilate(map,SE);
        %overlap region is found by multiplying our image mask (map) with no_overlap. 
        %In regions where disks have already been recorded no_overlap will equal -999.
        overlap_region=map.*no_overlap;
        if(min(overlap_region(:))<0)
            %If our disk overlaps with a region already recorded (i.e. overlap_region equals -999 somewhere) 
            %then we set this index value in the matrix to zero and find the next largest circle.
            R_mat(R_ind)=0;
        else
            %If the new disk does not overlap with previous disks then this
            %circle is the largest current circle that does not overlap
            %with others.
            %We store the radius and index of this disk in stored_R and stored_index.
            counter=counter+1;
            stored_R(counter,1)=R_max;
            stored_index(counter,1)=R_ind;
            %All other values within this disk area are then set to zero in our matrix.
            map1=~(map);
            R_mat=map1.*R_mat;
            % Pixels of the disk are stored as -999.
            %This is so we can make sure that no smaller circles overlap
            %with this one.
            no_overlap=no_overlap-999*map;
            R_len-counter%Timer
        end;
    end;
    %Here we save the data.
    nameStage3(end-6:end)=[];
    mat_file_save_name=[directoryDataOutStage3 nameStage3 '_Stage3'];
    save(mat_file_save_name);
    clearvars -except directoryDataOutStage3 file_namesStage3 filesStage3 filenoStage3
end;