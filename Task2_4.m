

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


numImages = 5;
files = cell(1, numImages);
% for i = 1:numImages
%     % Read in the calibration images
%     files{i} = fullfile('CV_pictures','Task1b_changing_zoom_rotation',strcat('changing_zoom_rotation_',num2str(i),'.JPG'));
    
% end

% for i = 1:numImages
%     % Read in the calibration images
%     files{i} = fullfile('CV_pictures','Task1a_with_object',strcat('object_',num2str(i),'.JPG'));
    
% end

for i = 1:2
    % Read in the calibration images
    files{i} = fullfile('CV_pictures','Test_rotation',strcat('object_',num2str(i),'.JPG'));
    
end

% Load the two images to match
img1 = imread(files{1});
img2 = imread(files{2});

% Detect features in both images
pts1 = detectSURFFeatures(rgb2gray(img1));
pts2 = detectSURFFeatures(rgb2gray(img2));

% Extract feature descriptors for the detected features
[features1, validPts1] = extractFeatures(rgb2gray(img1), pts1);
[features2, validPts2] = extractFeatures(rgb2gray(img2), pts2);

% Match the feature descriptors between the two images
indexPairs = matchFeatures(features1, features2);

% Retrieve the matched feature points
matchedPts1 = validPts1(indexPairs(:, 1));
matchedPts2 = validPts2(indexPairs(:, 2));

% Visualize the matched feature points
figure;
showMatchedFeatures(img1, img2, matchedPts1, matchedPts2, "montag");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TASK 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







% Estimate the homography transformation 
tform = estgeotform2d(matchedPts1, matchedPts2, 'projective');


% Apply the transformation to image1
outputImage = imwarp(img1, tform);

% Display the registered images side by side
figure;
imshowpair(outputImage, img2, 'montage');