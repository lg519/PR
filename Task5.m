numImages_Fun = 5;
files_Fun = cell(1, numImages_Fun);
for i = 1:numImages_Fun
    files_Fun{i} = fullfile('CV_pictures','Task1a_with_object',strcat('object_',num2str(i),'.JPG'));
    
end

% Load the two images to match
img1_Fun = imread(files_Fun{3});
img2_Fun = imread(files_Fun{4});

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




% Detect features in both images
pts1_Fun_rect = detectSIFTFeatures(rgb2gray(img1_Fun_rect));
pts2_Fun_rect = detectSIFTFeatures(rgb2gray(img2_Fun_rect));

% Extract feature descriptors for the detected features
[features1_Fun_rect, validPts1_Fun_rect] = extractFeatures(rgb2gray(img1_Fun_rect), pts1_Fun_rect);
[features2_Fun_rect, validPts2_Fun_rect] = extractFeatures(rgb2gray(img2_Fun_rect), pts2_Fun_rect);

% Match the feature descriptors between the two images
indexPairs_Fun_rect = matchFeatures(features1_Fun_rect, features2_Fun_rect);

% Retrieve the matched feature points
matchedPts1_Fun_rect = validPts1_Fun_rect(indexPairs_Fun_rect(:, 1));
matchedPts2_Fun_rect = validPts2_Fun_rect(indexPairs_Fun_rect(:, 2));

% Visualize the matched feature points
figure;
showMatchedFeatures(img1_Fun_rect, img2_Fun_rect, matchedPts1_Fun_rect, matchedPts2_Fun_rect, "montag");
title("Matched Points (Including Outliers)");


% Estimate the fundamental matrix
[F_rect,inliersIndex_rect] = estimateFundamentalMatrix(matchedPts1_Fun_rect, matchedPts2_Fun_rect);

% Show the inliers in the first image
figure;
subplot(1,2,1);
imshow(img1_Fun_rect);
hold on;
title('Inliers and Epipolar Lines in First Image');
plot(matchedPts1_Fun_rect.Location(inliersIndex_rect,1),matchedPts1_Fun_rect.Location(inliersIndex_rect,2),'go');

epilines = epipolarLine(F_rect',matchedPts2_Fun_rect.Location);
points = lineToBorderPoints(epilines,size(img1_Fun_rect));

line(points(:,[1,3])',points(:,[2,4])');

% Show the inliers in the second image
subplot(1,2,2);
imshow(img2_Fun_rect);
hold on;

title('Inliers and Epipolar Lines in Second Image');
plot(matchedPts2_Fun_rect.Location(inliersIndex_rect,1),matchedPts2_Fun_rect.Location(inliersIndex_rect,2),'go');

epilines = epipolarLine(F_rect,matchedPts1_Fun_rect.Location);
points = lineToBorderPoints(epilines,size(img2_Fun_rect));

line(points(:,[1,3])',points(:,[2,4])');





% Show the inliers in the first image
% figure;
% subplot(1,2,1);
% imshow(img1_Fun);
% hold on;
% title('Inliers and Epipolar Lines in First Image');
% plot(matchedPts1_Fun.Location(inliersIndex,1),matchedPts1_Fun.Location(inliersIndex,2),'go');

% epilines = epipolarLine(F',matchedPts2_Fun.Location);
% % points = lineToBorderPoints(epilines,size(img1_Fun));

% %line(points(:,[1,3])',points(:,[2,4])');

% % Show the inliers in the second image
% subplot(1,2,2);
% imshow(img2_Fun);
% hold on;
% title('Inliers and Epipolar Lines in Second Image');
% plot(matchedPts2_Fun.Location(inliersIndex,1),matchedPts2_Fun.Location(inliersIndex,2),'go');

% epilines = epipolarLine(F,matchedPts1_Fun.Location);
% points = lineToBorderPoints(epilines,size(img2_Fun));

% line(points(:,[1,3])',points(:,[2,4])');







% visualize the rectified images
% figure;
% imshowpair(img1_Fun_rect, img2_Fun_rect, 'montage');
% title("Rectified Images");






% calculate the disparity map





% calculate epipolar lines



% ESTIMATE CALIBRATED RECTIFICATION, USING THE CALIBRATION MATRIX (THIS SHOULD FIX THE NARROW IMAGE PROBLEM)


