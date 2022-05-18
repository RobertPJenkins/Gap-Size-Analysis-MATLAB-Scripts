function circle_gap_plotting(label_matrix,non_tissue_mask,filename)
%CIRCLE_GAP_PLOTTING plots the gap filling circles with random colour
%alongside the fibres in white.
% pixel and the nearest fibre for a logical input matrix of fibres and
% produces related output data.
%
%    circle_gap_plotting(label_matrix,filename) takes the index notated 
%    label matrix of all fitted circles and converts to rgb with each 
%    circle shown in a different, random colour. Alongside this the fibres
%    are shown in white. The resulting rgb image is then saved as a tiff.
%
%   Input:
%   label_matrix: Pixels labelled by unsigned integer values determining 
%   correspondence to a given circle.
%   filename: The directory, filename and file extension used to save the 
%   resulting rgb image.
%
%
%   Class support for input label_matrix:
%      float: single, double
%   Class support for input filename:
%      string
%   
%
%   This work is licensed under a Creative Commons Attribution 4.0 
%   International License.

cm=rand(length(unique(label_matrix))+1,3);
cm(1,:)=1;
RGB = ind2rgb(label_matrix+1,cm);
RGB(:,:,1)=RGB(:,:,1).*non_tissue_mask;
RGB(:,:,2)=RGB(:,:,2).*non_tissue_mask;
RGB(:,:,3)=RGB(:,:,3).*non_tissue_mask;
imwrite(RGB,filename)
end