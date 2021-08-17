% This is a sample script
% It demos the face expression recognition using the Eigenface method

disp('Face Expression Recognition Demo Using the Eigenface Method')
%disp('After your face appeared in the camera window, please left click your mouse to take a picture of youself')
%disp('Please save your cute picture to D:\CS6527-Computer Vision\Final Project\Project Code\TestImage')

%pictureCapture

TrainImagePath = 'D:\CS6527-Computer Vision\Final Project\Project Code\TrainingImage';
TestImagePath = 'D:\CS6527-Computer Vision\Final Project\Project Code\TestImage';
LabelPath = 'D:\CS6527-Computer Vision\Final Project\Project Code\ImageLabel.txt';

[NumTrainImg,TrainImg] = loadImage( TrainImagePath );
[NumTestImg,TestImg] = loadImage( TestImagePath );

[C,minDist,minDistIndex] = eigenFaceRecognition(TrainImg,TestImg,NumTrainImg,NumTestImg );

% Display the result
RecognizedExpression = strcat(int2str(minDistIndex),'.jpg');
    % read in the image label
    fid=fopen(LabelPath);
    imageLabel=textscan(fid,'%s %s','whitespace',',');
    fclose(fid);
    
    % export the matched label
    Best_Match = cell2mat(imageLabel{1,1}(minDistIndex));
    ExprLabel = cell2mat(imageLabel{1,2}(minDistIndex));

str1 = strcat('Your face expression is like this one:  ',RecognizedExpression);
str2 = strcat('It tells me that you are:  ',ExprLabel);
disp(str1)
disp(str2)

%SelectedImage = strcat(TrainImagePath,'\',RecognizedExpression);
%SelectedImage = imread(SelectedImage);
%imshow(SelectedImage)
function [numImage,img] = loadImage( strImagePath )
%LOADIMAGE read in the images from given file Path
%   numImage is the number of loaded Images
%   img is the matrix as the input for PCA process
%   to prepare for PCA, the loaded images are all substracted by mean image

% Constructing Image Loading Space and counting image numbers
structImages = dir(strImagePath);
lenImages = length(structImages);
Images='';

if (lenImages==0)
    disp('Error: No image was detected in the Image Folder');
    return;
end

i=0;
for j = 3:lenImages
     if ((~structImages(j).isdir))
         if  (structImages(j).name(end-3:end)=='.jpg')
             i=i+1;
             Images{i,1} = [strImagePath,'\',structImages(j).name];
         end
     end
end
numImage = i; % this is the number of loaded Images

% All Images are resized into a common size
imageSize = [280,180]; 


% Loading images
img = zeros(imageSize(1)*imageSize(2),numImage);
for i = 1:numImage
    aa = imresize(faceDetection(imresize(imread(Images{i,1}),[375,300])),imageSize);
    img(:,i) = aa(:);
    % disp(sprintf('Loading Image # %d',i));
end
% Generating the mean image
meanImage = mean(img,2);        

% Substracting the mean image from loaded image
img = (img - meanImage*ones(1,numImage))';     
end

function pictureCapture
% PICTURECAPTURE captures the picture from the real time video of the front camera
% The picture would be captured when user left click the mouse once.
% User could choose to save the captured picture into any path.

% Set up the front camera
frontCam = videoinput('winvideo', 1,'YUY2_640x480');
set(frontCam,'TriggerRepeat',inf);
set(frontCam,'FramesPerTrigger',1);
set(frontCam,'ReturnedColorSpace','rgb');
vidRes=get(frontCam,'VideoResolution');
nBands=get(frontCam,'NumberOfBands');

% Set up the capture window and function
fig1 = figure;
set(fig1,'doublebuffer','on');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
set(fig1,'Name','Please left click your mouse to capture a picture');
set(fig1,'WindowButtonDownFcn',@LeftClickFcn);

fig2 = 0;
% once left click the mouse, one picture would be captured
% the last captured picture would be saved defautly as "snap.jpg"
    function LeftClickFcn(~,~)
        frame = getsnapshot(frontCam);
        if fig2 == 0
            fig2 = figure;
        else
            figure(fig2)
        end
        imshow(frame);
        title('The picture we just captured¡¡^_< ')
        imwrite(frame,'snap.jpg','jpg');
    end

% Set up the real time video preview window
preview(frontCam, hImage);
            
end


