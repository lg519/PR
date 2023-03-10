clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% for i = 1:numImages
%     % Read in the calibration images
%     files{i} = fullfile('CV_pictures','Task1b_changing_zoom_rotation',strcat('changing_zoom_rotation_',num2str(i),'.JPG'));
    
% end

% for i = 1:numImages
%     % Read in the calibration images
%     files{i} = fullfile('CV_pictures','Task1a_with_object',strcat('object_',num2str(i),'.JPG'));
    
% end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 4.1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% numImages_hom = 5;
% files_hom = cell(1, numImages_hom);
% for i = 1:2
    
%     files_hom{i} = fullfile('CV_pictures','Test_rotation',strcat('object_',num2str(i),'.JPG'));
    
% end

% % Load the two images to match
% img1_hom = imread(files_hom{1});
% img2_hom = imread(files_hom{2});

% % Detect features in both images
% pts1_hom = detectSIFTFeatures(rgb2gray(img1_hom));
% pts2_hom = detectSIFTFeatures(rgb2gray(img2_hom));

% % Extract feature descriptors for the detected features
% [features1_hom, validPts1_hom] = extractFeatures(rgb2gray(img1_hom), pts1_hom);
% [features2_hom, validPts2_hom] = extractFeatures(rgb2gray(img2_hom), pts2_hom);

% % Match the feature descriptors between the two images
% indexPairs_hom = matchFeatures(features1_hom, features2_hom);

% % Retrieve the matched feature points
% matchedPts1_hom = validPts1_hom(indexPairs_hom(:, 1));
% matchedPts2_hom = validPts2_hom(indexPairs_hom(:, 2));

% % Visualize the matched feature points
% figure;
% showMatchedFeatures(img1_hom, img2_hom, matchedPts1_hom, matchedPts2_hom, "montag");



% % Estimate the homography transformation 
% tform = estgeotform2d(matchedPts1_hom, matchedPts2_hom, 'projective');


% % Apply the transformation to image1
% outputImage = imwarp(img1_hom, tform);

% % Display the registered images side by side
% figure;
% imshowpair(outputImage, img2_hom, 'montage');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 4.2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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
[F,inliersIndex] = estimateFundamentalMatrix(matchedPts1_Fun, matchedPts2_Fun,Method="RANSAC", NumTrials=4000, DistanceThreshold=1);

% get the number of inliers
numInliers = sum(inliersIndex);

% get the number of outliers
numOutliers = size(matchedPts1_Fun,1) - numInliers;

% print the number of inliers and outliers
fprintf('Number of inliers: %d , Number of outliers: %d \n', numInliers, numOutliers);



% Show the inliers in the first image
figure;
subplot(1,2,1);
imshow(img1_Fun);
hold on;
title('Inliers and Epipolar Lines in First Image');
plot(matchedPts1_Fun.Location(inliersIndex,1),matchedPts1_Fun.Location(inliersIndex,2),'go');

epilines = epipolarLine(F',matchedPts2_Fun.Location);
% points = lineToBorderPoints(epilines,size(img1_Fun));

%line(points(:,[1,3])',points(:,[2,4])');

% Show the inliers in the second image
subplot(1,2,2);
imshow(img2_Fun);
hold on;
title('Inliers and Epipolar Lines in Second Image');
plot(matchedPts2_Fun.Location(inliersIndex,1),matchedPts2_Fun.Location(inliersIndex,2),'go');

epilines = epipolarLine(F,matchedPts1_Fun.Location);
points = lineToBorderPoints(epilines,size(img2_Fun));

line(points(:,[1,3])',points(:,[2,4])');





















% % Calculate the epipolar lines
% lines1_Fun = epipolarLine(F', matchedPts2_Fun.Location);
% lines2_Fun = epipolarLine(F, matchedPts1_Fun.Location);

% % Find the endpoints of the epipolar lines
% points1_Fun = lineToBorderPoints(lines1_Fun, size(img1_Fun));
% points2_Fun = lineToBorderPoints(lines2_Fun, size(img2_Fun));

% % Display the image with the epipolar lines
% figure;
% imshow(img1_Fun);
% hold on;
% line(points1_Fun(:, [1,3])', points1_Fun(:, [2,4])');
% title('Epipolar lines in image 1');

% % Display the image with the epipolar lines
% figure;
% imshow(img2_Fun);
% hold on;
% line(points2_Fun(:, [1,3])', points2_Fun(:, [2,4])');
% title('Epipolar lines in image 2');

% % Display the inliers and outliers
% figure;
% showMatchedFeatures(img1_Fun, img2_Fun, matchedPts1_Fun(inliersIndex), matchedPts2_Fun(inliersIndex), "montage");
% title('Inliers');

% figure;
% showMatchedFeatures(img1_Fun, img2_Fun, matchedPts1_Fun(~inliersIndex), matchedPts2_Fun(~inliersIndex), "montage");
% title('Outliers');









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



