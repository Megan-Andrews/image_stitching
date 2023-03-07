% 1 ----------------------------------------------------------------------
% Take 4 sets of 2 photographs to be stitched together to create a panorama

% You need to take photograph pairs to be stitched together, similar to the pair we talked about in our transformations lecture. Take each pair of images from different scenes. I would recommend taking many pairs of images and determining which ones to use after some experimentation with your implementation and results. Make sure to resize your images to get the longer dimension of the image (height or width) to be 750.
% If you%d like to implement Part 5 for bonus points, at least two of your 4 image sets should contain 4 images to be stitched together.
% Submit your image pairs named as S1-im1.png, S1-im2.png, and so on.

% S1
S1_im1 =  im2double((imread("S1-im1.png")));
S1_im2 =  im2double((imread("S1-im2.png")));
S1_im3 =  im2double((imread("S1-im3.png")));
S1_im4 =  im2double((imread("S1-im4.png")));
S1 = {S1_im1, S1_im2, S1_im3, S1_im4};

S2_im1 =  im2double((imread("S2-im1.png")));
S2_im2 =  im2double((imread("S2-im2.png")));
S2_im3 =  im2double((imread("S2-im3.png")));
S2_im4 =  im2double((imread("S2-im4.png")));
S2 = {S2_im1, S2_im2, S2_im3, S2_im4};

S3_im1 =  im2double(im2gray(imread("S3-im1.png")));
S3_im2 =  im2double(im2gray(imread("S3-im2.png")));
S3_im3 =  im2double(im2gray(imread("S3-im3.png")));
S3_im4 =  im2double(im2gray(imread("S3-im4.png")));
S3 = {S3_im1, S3_im2, S3_im3, S3_im4};

S4_im1 =  im2double(im2gray(imread("S4-im1.png")));
S4_im2 =  im2double(im2gray(imread("S4-im2.png")));
%S4_im3 =  im2double(im2gray(imread("S4-im3.png")));
%S4_im4 =  im2double(im2gray(imread("S4-im4.png")));
S4 = {S4_im1, S4_im2};
% 
%     S4_im2 =  im2double(im2gray(imread("S4-im2.png")));
%     S4_im2=imresize(S4_im2, [750 NaN]);
%     imwrite(S4_im2,"S4-im2.png")
%     S4_im1 =  im2double(im2gray(imread("S4-im1.png")));
%     S4_im1=imresize(S4_im1, [750 NaN]);
%     imwrite(S4_im1,"S4-im1.png")

% 2 ----------------------------------------------------------------------
% FAST feature detector (3 pts.)

% Features from accelerated segment test, or FAST, is an efficient interest point detection method proposed by Rosten and Drummond. It works by comparing the brightness of a pixel with a ring surrounding it. You can find more detailed description in the links below:
% You need to implement FAST including the high-speed test as a function named my_fast_detector. It%s on you to learn about how to define functions in MATLAB.
% Hint: In MATLAB, using for loops is quite inefficient but using matrix operations are very efficient. You can do the pixel-wise comparisons by shifting the image for every pixel at once. For example, for the check if a pixel is brighter than their neighbor 3 pixels to the left, shift the image to the right by 3 pixels and compare against the original image in a single line!
% Save the visualization of the detected points in the first images of your 2 image sets as S1-fast.png and S2-fast.png

N = 9; % number of contiguous pixels
T = .15; % threshold 

[S1_im1_fast, et1]= my_fast_detector(S1_im1,N,T,1,"S1-fast.png");
[S1_im2_fast, et2] = my_fast_detector(S1_im2,N,T,0,"S1-fast.png");
[S1_im3_fast, et3] = my_fast_detector(S1_im3,N,T,0,"S1-fast.png");
[S1_im4_fast, et4] = my_fast_detector(S1_im4,N,T,0,"S1-fast.png");
S1_fast = {S1_im1_fast, S1_im2_fast, S1_im3_fast, S1_im4_fast};

[S2_im1_fast, et5]= my_fast_detector(S2_im1,N,T,1,"S2-fast.png");
[S2_im2_fast, et6] = my_fast_detector(S2_im2,N,T,0,"S2-fast.png");
[S2_im3_fast, et7] = my_fast_detector(S2_im3,N,T,0,"S2-fast.png");
[S2_im4_fast, et8] = my_fast_detector(S2_im4,N,T,0,"S2-fast.png");
S2_fast = {S2_im1_fast, S2_im2_fast, S2_im3_fast, S2_im4_fast};

[S3_im1_fast, et9]= my_fast_detector(S3_im1,N,T,0,"S3-fast.png");
[S3_im2_fast, et10] = my_fast_detector(S3_im2,N,T,0,"S3-fast.png");
[S3_im3_fast, et11] = my_fast_detector(S3_im3,N,T,0,"S3-fast.png");
[S3_im4_fast, et12] = my_fast_detector(S3_im4,N,T,0,"S3-fast.png");
S3_fast = {S3_im1_fast, S3_im2_fast, S3_im3_fast, S3_im4_fast};

[S4_im1_fast, et13]= my_fast_detector(S4_im1,N,T,0,"S4-fast.png");
[S4_im2_fast, et14] = my_fast_detector(S4_im2,N,T,0,"S4-fast.png");
%[S4_im3_fast, et15] = my_fast_detector(S4_im3,N,T,0,"S4-fast.png");
%[S4_im4_fast, et16] = my_fast_detector(S4_im4,N,T,0,"S4-fast.png");
S4_fast = {S4_im1_fast, S4_im2_fast};%, S4_im3_fast, S4_im4_fast};

mean([et1 et2 et3 et4 et5 et6 et7 et8 et9 et10 et11 et12 et13 et14])% et15 et16]) % mean time is 9.4010 seconds
% 2 ----------------------------------------------------------------------
% Robust FAST using Harris Cornerness metric (1 pts.)

% Compute the Harris cornerness measure for each detected FAST feature. Eliminate weak FAST points by defining a threshold for the Harris metric. This threshold must be fixed for every image you use. We will call these points FASTR points.
% Comment on which points were discarded after this thresholded by comparing your FAST and FASTR visualizations. Save the visualization of the detected points in the first images of your 2 image sets as S1-fastR.png and S2-fastR.png Note down the average computation time of FAST and FASTR features (average of all the images you have) and comment on the difference.

H_T = 0.00005; % Harris threshold

%S1
[S1_im1_fastR, et1]= fastr_harris_corner(S1_im1,S1_im1_fast,H_T,1,"S1-fastR.png");
[S1_im2_fastR, et2] = fastr_harris_corner(S1_im2,S1_im2_fast,H_T,0,"S1-fastR.png");
[S1_im3_fastR, et3] = fastr_harris_corner(S1_im3,S1_im3_fast,H_T,0,"S1-fastR.png");
[S1_im4_fastR, et4] = fastr_harris_corner(S1_im4,S1_im4_fast,H_T,0,"S1-fastR.png");
S1_fastR = {S1_im1_fastR, S1_im2_fastR, S1_im3_fastR, S1_im4_fastR};

[S2_im1_fastR, et5]= fastr_harris_corner(S2_im1,S2_im1_fast,H_T,1,"S2-fastR.png");
[S2_im2_fastR, et6] = fastr_harris_corner(S2_im2,S2_im2_fast,H_T,0,"S2-fastR.png");
[S2_im3_fastR, et7] = fastr_harris_corner(S2_im3,S2_im3_fast,H_T,0,"S2-fastR.png");
[S2_im4_fastR, et8] = fastr_harris_corner(S2_im4,S2_im4_fast,H_T,0,"S2-fastR.png");
S2_fastR = {S2_im1_fastR, S2_im2_fastR, S2_im3_fastR, S2_im4_fastR};

[S3_im1_fastR, et9]= fastr_harris_corner(S3_im1,S3_im1_fast,H_T,1,"S3-fastR.png");
[S3_im2_fastR, et10] = fastr_harris_corner(S3_im2,S3_im2_fast,H_T,0,"S3-fastR.png");
[S3_im3_fastR, et11] = fastr_harris_corner(S3_im3,S3_im3_fast,H_T,0,"S3-fastR.png");
[S3_im4_fastR, et12] = fastr_harris_corner(S3_im4,S3_im4_fast,H_T,0,"S3-fastR.png");
S3_fastR = {S3_im1_fastR, S3_im2_fastR, S3_im3_fastR, S3_im4_fastR};

[S4_im1_fastR, et13]= fastr_harris_corner(S4_im1,S4_im1_fast,H_T,0,"S4-fastR.png");
[S4_im2_fastR, et14] = fastr_harris_corner(S4_im2,S4_im2_fast,H_T,0,"S4-fastR.png");
%[S4_im3_fastR, et15] = fastr_harris_corner(S4_im3,S4_im3_fast,H_T,0,"S4-fastR.png");
%[S4_im4_fastR, et16] = fastr_harris_corner(S4_im4,S4_im4_fast,H_T,0,"S4-fastR.png");
S4_fastR = {S4_im1_fastR, S4_im2_fastR};%, S4_im3_fastR, S4_im4_fastR};

mean([et1 et2 et3 et4 et5 et6 et7 et8 et9 et10 et11 et12 et13 et14])% et15 et16]) % mean time is 0.3003 seconds

% 4 ----------------------------------------------------------------------
% Point description and matching (2 pts.)

% Use an existing implementation of one of ORB, SURF, or FREAK feature decription 
% methods to generate descriptors for your FAST and FASTR points. Note which decriptor you use in your report. Depending on the function you are using, you might need to put your keypoints in appropriate containers. Don’t forget to use MATLAB Help to get such definitions.

% Match the features between the first two images in each photo set. Save the visualization of the matched points between the two images of your first 2 image sets, using FAST and FASTR points, as S1-fastMatch.png, S1-fastRMatch.png, S2-fastMatch.png, and S2-fastRMatch.png 
% Comment on the performance differences if any.

% S1 
S1_fast_match = description_matching(S1_fast, S1, 1, "S1-fastMatch.png");
S1_fastR_match = description_matching(S1_fastR, S1, 1, "S1-fastRMatch.png");

% S2 
S2_fast_match = description_matching(S2_fast, S2, 1, "S2-fastMatch.png");
S2_fastR_match = description_matching(S2_fastR, S2, 1, "S2-fastRMatch.png");

% S3 
S3_fast_match = description_matching(S3_fast, S3, 0, "S3-fastMatch.png");
S3_fastR_match = description_matching(S3_fastR, S3, 0, "S3-fastRMatch.png");

% S4 
S4_fast_match = description_matching(S4_fast, S4, 1, "S4-fastMatch.png");
S4_fastR_match = description_matching(S4_fastR, S4, 1, "S4-fastRMatch.png");


% 4 ----------------------------------------------------------------------
% Estimate the homography between the two images using RANSAC

% To compute the homography between each pair, you will use RANSAC. You can use an existing implementation such as matchFeatures function in MATLAB, but you need to be able experiment with the RANSAC parameters for the optimum result.
% Find the homography between two images in all your image sets and stitch them together.
% Experiment with RANSAC parameters and find a setup where you use minimum number of trials while still getting a satisfactory result for all your image sets. You%ll find 2 different sets of RANSAC parameters, one for FAST and one for FASTR. The RANSAC parameters you decide should be the same for the 4 image sets.
% Save the stitched images for all your image sets only using FASTR points, as S1-panorama.png, S2-panorama.png, S3-panorama.png, and S4-panorama.png 
% Comment on the difference between optimal RANSAC parameters for FAST and FASTR.

blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port'); 

create_panorama(S1_fastR_match,S1,"S1-panorama.png",blender);

create_panorama(S2_fastR_match,S2,"S2-panorama.png",blender);

create_panorama(S3_fastR_match,S3,"S3-panorama.png",blender);

create_panorama(S4_fastR_match,S4,"S4-panorama.png",blender);

% 
 create_panorama(S1_fast_match,S1,"S1-panorama-fast.png",blender);
 create_panorama(S2_fast_match,S2,"S2-panorama-fast.png",blender);
 create_panorama(S3_fast_match,S3,"S3-panorama-fast.png",blender); 
 create_panorama(S4_fast_match,S4,"S4-panorama-fast.png",blender);
