numImages_Fun = 5;
files_Fun = cell(1, numImages_Fun);
for i = 1:numImages_Fun
    files_Fun{i} = fullfile('CV_pictures','Task1a_with_object',strcat('object_',num2str(i),'.JPG'));
    
end

% Load the two images to match
img1_Fun = imread(files_Fun{1});
img2_Fun = imread(files_Fun{2});

% Detect features in both images
pts1_Fun = detectSIFTFeatures(rgb2gray(img1_Fun));
pts2_Fun = detectSIFTFeatures(rgb2gray(img2_Fun));

% Extract feature descriptors for the detected features
[features1_Fun, validPts1_Fun] = extractFeatures(rgb2gray(img1_Fun), pts1_Fun);
[features2_Fun, validPts2_Fun] = extractFeatures(rgb2gray(img2_Fun), pts2_Fun);

% Match the feature descriptors between the two images
indexPairs_Fun = matchFeatures(features1_Fun, features2_Fun);

% Retrieve the matched feature points
matchedPts1_Fun = validPts1_Fun(indexPairs_Fun(:, 1));
matchedPts2_Fun = validPts2_Fun(indexPairs_Fun(:, 2));

% Visualize the matched feature points
figure;
showMatchedFeatures(img1_Fun, img2_Fun, matchedPts1_Fun, matchedPts2_Fun, "montag");
title("Matched Points (Including Outliers)");


% Estimate the fundamental matrix
[F,inliersIndex] = estimateFundamentalMatrix(matchedPts1_Fun, matchedPts2_Fun);

% get the number of inliers
numInliers = sum(inliersIndex);

% get the number of outliers
numOutliers = size(matchedPts1_Fun,1) - numInliers;

% print the number of inliers and outliers
fprintf('Number of inliers: %d , Number of outliers: %d \n', numInliers, numOutliers);


% ESTIMATE STEREO RECTIFICATION
% CAN DO IT IN TWO WASY: 1) USING THE CALIBRATION MATRIX 2) NOT USING THE CALIBRATION MATRIX

% estimate uncalibrated rectification

inlierPoints1 = matchedPts1_Fun(inliersIndex, :);
inlierPoints2 = matchedPts2_Fun(inliersIndex, :);

% visualize the inliers
figure;
showMatchedFeatures(img1_Fun, img2_Fun, inlierPoints1, inlierPoints2);
title("Matched Points (Inliers Only)");

[tform1,tform2] = estimateStereoRectification(F,inlierPoints1.Location,inlierPoints2.Location, [size(img1_Fun, 1), size(img1_Fun, 2)])

[img1_Fun_rect, img2_Fun_rect] = rectifyStereoImages(img1_Fun, img2_Fun, tform1, tform2);

imshow(stereoAnaglyph(img1_Fun_rect,img2_Fun_rect));
title("Rectified Stereo Images (Red - Left Image, Cyan - Right Image)");

% calculate epipolar lines



% ESTIMATE CALIBRATED RECTIFICATION, USING THE CALIBRATION MATRIX (THIS SHOULD FIX THE NARROW IMAGE PROBLEM)


