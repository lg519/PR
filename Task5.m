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


% Estimate the fundamental matrix
[F,inliersIndex] = estimateFundamentalMatrix(matchedPts1_Fun, matchedPts2_Fun);


% ESTIMATE STEREO RECTIFICATION
% CAN DO IT IN TWO WASY: 1) USING THE CALIBRATION MATRIX 2) NOT USING THE CALIBRATION MATRIX

% estimate uncalibrated rectification

[tform1,tform2] = estimateStereoRectification(F,matchedPts1_Fun(inliersIndex),matchedPts2_Fun(inliersIndex), size(img1_Fun))

[img1_Fun_rect, img2_Fun_rect] = rectifyStereoImages(img1_Fun, img2_Fun, tform1, tform2);

% plot the rectified images
figure;
imshowpair(img1_Fun_rect, img2_Fun_rect, 'montage');


