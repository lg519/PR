rng(1);

numImages_Fun = 5;
files_Fun = cell(1, numImages_Fun);
for i = 1:numImages_Fun
    files_Fun{i} = fullfile('CV_pictures','FD',strcat('object_',num2str(i),'.JPG'));
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KEYPOINT MATCHING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the two images to match
img1_Fun = imread(files_Fun{1});
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
title("Matched Points (Including Outliers) no rectification");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RECTIFICATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Estimate the fundamental matrix
[F,inliersIndex,status] = estimateFundamentalMatrix(matchedPts1_Fun, matchedPts2_Fun);


if status ~= 0 || isEpipoleInImage(F,size(img1_Fun)) ...
  || isEpipoleInImage(F',size(img2_Fun))
  error(["Not enough matching points were found or "...
         "the epipoles are inside the images. Inspect "...
         "and improve the quality of detected features ",...
         "and images."]);
end


% get the number of inliers
numInliers = sum(inliersIndex);

% get the number of outliers
numOutliers = size(matchedPts1_Fun,1) - numInliers;

% print the number of inliers and outliers
fprintf('Number of inliers: %d , Number of outliers: %d \n', numInliers, numOutliers);


% estimate uncalibrated rectification
inlierPoints1 = matchedPts1_Fun(inliersIndex, :);
inlierPoints2 = matchedPts2_Fun(inliersIndex, :);

% visualize the inliers
figure;
showMatchedFeatures(img1_Fun, img2_Fun, inlierPoints1, inlierPoints2);
title("Matched Points (Inliers Only) no rectification");

[tform1,tform2] = estimateStereoRectification(F,inlierPoints1.Location,inlierPoints2.Location, [size(img1_Fun, 1), size(img1_Fun, 2)])

[img1_Fun_rect, img2_Fun_rect] = rectifyStereoImages(img1_Fun, img2_Fun, tform1, tform2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%












%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% KEYPOINT MATCHING IN RECTIFIED IMAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
title("Matched Points (Including Outliers) with rectification");


% Estimate the fundamental matrix
[F_rect,inliersIndex_rect,status] = estimateFundamentalMatrix(matchedPts1_Fun_rect, matchedPts2_Fun_rect);

if status ~= 0 || isEpipoleInImage(F_rect,size(img1_Fun_rect)) ...
  || isEpipoleInImage(F_rect',size(img2_Fun_rect))
  error(["Not enough matching points were found or "...
         "the epipoles are inside the images. Inspect "...
         "and improve the quality of detected features ",...
         "and images."]);
end


inlierPoints1_rect = matchedPts1_Fun_rect(inliersIndex_rect, :);
inlierPoints2_rect = matchedPts2_Fun_rect(inliersIndex_rect, :);


% Show the rectified images with the epipolar lines
figure;
subplot(1,2,1);
imshow(img1_Fun_rect);
hold on;
title('Inliers and Epipolar Lines in First Image');
plot(inlierPoints1_rect.Location(:,1),inlierPoints1_rect.Location(:,2),'go');

epilines = epipolarLine(F_rect',inlierPoints2_rect.Location);
points = lineToBorderPoints(epilines,size(img1_Fun_rect));

line(points(:,[1,3])',points(:,[2,4])');

% Show the inliers in the second image
subplot(1,2,2);
imshow(img2_Fun_rect);
hold on;

title('Inliers and Epipolar Lines in Second Image');
plot(inlierPoints2_rect.Location(:,1),inlierPoints2_rect.Location(:,2),'go');

epilines = epipolarLine(F_rect,inlierPoints1_rect.Location);
points = lineToBorderPoints(epilines,size(img2_Fun_rect));

line(points(:,[1,3])',points(:,[2,4])');

hold off;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Visualize the disparity map
figure;
% Estimate the depth map
disparityRange = [-64 64];
disparityMap = disparitySGM(rgb2gray(img1_Fun_rect),rgb2gray(img2_Fun_rect),'DisparityRange',disparityRange,'UniquenessThreshold',20);
hold on;
imshow(disparityMap,disparityRange);
title('Disparity Map');
hold on;
colormap jet;
hold on;
colorbar;














% Show the inliers in the first image
% figure;
% subplot(1,2,1);
% imshow(img1_Fun_rect);
% hold on;
% title('Inliers and Epipolar Lines in First Image');
% plot(matchedPts1_Fun_rect.Location(inliersIndex_rect,1),matchedPts1_Fun_rect.Location(inliersIndex_rect,2),'go');

% epilines = epipolarLine(F_rect',matchedPts2_Fun_rect.Location);
% points = lineToBorderPoints(epilines,size(img1_Fun_rect));

% line(points(:,[1,3])',points(:,[2,4])');

% % Show the inliers in the second image
% subplot(1,2,2);
% imshow(img2_Fun_rect);
% hold on;

% title('Inliers and Epipolar Lines in Second Image');
% plot(matchedPts2_Fun_rect.Location(inliersIndex_rect,1),matchedPts2_Fun_rect.Location(inliersIndex_rect,2),'go');

% epilines = epipolarLine(F_rect,matchedPts1_Fun_rect.Location);
% points = lineToBorderPoints(epilines,size(img2_Fun_rect));

% line(points(:,[1,3])',points(:,[2,4])');

% hold off;




% Show the disparity map
% figure;
% disparityMap = disparity(rgb2gray(img1_Fun_rect), rgb2gray(img2_Fun_rect));
% imshow(disparityMap, [0, 64]);
% title('Disparity Map');
% colormap jet
% colorbar







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


