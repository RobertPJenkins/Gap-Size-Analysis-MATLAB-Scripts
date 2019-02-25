# Gap-Size-Analysis-MATLAB-Scripts
Analysis of sizes of gaps in images by finding the largest circles that can fill the image in order to analyse the distributions of circle radii. 

Used in the papers 'Dendritic cells control fibroblastic reticular network tension and lymph node expansion' by Acton et al. and 'Matrix geometry determines optimal cancer cell migration strategy and modulates response to interventions' by Tozluoğlu et al.  

There are four Matlab scripts. Run each in turn.

GapAnalysisPart1.m gives an example of how your tif files could be processed in order to reduce the resolution, make the image binary and remove small objects. This file then saves the necessary data for stage 2. You may wish to edit this script to pre-process your own images better. There are parameters you will need to edit (e.g. the threshold level to convert colour images to binary).

GapAnalysisPart2.m finds the maximum circle that can fit in any one location in the image whilst not overlapping with the fibres or not fitting on the entire image. This stage takes the longest. It's speed could be increased (e.e. by incorporating the Matlab function Imfilter) but it has never needed to be for our images.

GapAnalysisPart3.m goes through the circles from largest to smallest and only keeps a circle if it does not overlap with any others.

GapAnalysisPart4.m gives a plot of the circles overlaid onto the fibres.

The key output is generated in GapAnalysisPart3.m and is in the variable ' stored_R '. This gives the data from which to analyse circle radius distributions.

Example images are included for analysis. The example images are already binary, but GapAnalysisPart1.m can read in non-binary images and convert them.

Before you run the code you will have to go through the code and change the target directories for opening and saving data. 

I intend to optimise the circle search part of the code at some point in order to speed up the algorithm.
