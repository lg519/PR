% Load images
numImages = 5;
files = cell(1, numImages);
for i = 1:numImages
    % Read in the calibration images
    files{i} = fullfile('CV_pictures','Calibration_images',strcat('empty_',num2str(i),'.JPG'));
    
end

% Display one of the calibration images
% magnification = 25;
I = imread(files{1});
% figure(1);
% imshow(I);
% title("One of the Calibration Images");

% Detect the checkerboard corners in the images.
[imagePoints, boardSize] = detectCheckerboardPoints(files);

% Generate the world coordinates of the corners of the squares.
squareSize = 20; % in millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera.
imageSize = [size(I, 1), size(I, 2)];
cameraParams = estimateCameraParameters(imagePoints, worldPoints,ImageSize = imageSize);

% Evaluate calibration accuracy.
figure(2);
showReprojectionErrors(cameraParams);
title("Reprojection Errors");
hold off;


% Plot detected and reprojected points.
figure(3); 
hold on;
img_number = 5;
I = imread(files{img_number});
imshow(I); 
hold on;
plot(imagePoints(:,1,img_number), imagePoints(:,2,img_number),'go');
hold on;
plot(cameraParams.ReprojectedPoints(:,1,img_number),cameraParams.ReprojectedPoints(:,2,img_number),'r+');
legend('Detected Points','ReprojectedPoints');
hold off;


% Remove lens distortion and display results.
I = imread(files{img_number});
J1 = undistortImage(I,cameraParams);
figure(4);
imshowpair(I,J1,'montage');
title('Original Image (left) vs. Corrected Image (right)');



