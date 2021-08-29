disp('Face Expression Recognition Demo Using the Eigenface Method')
TrainImagePath = 'D:\CS6527-Computer Vision\Final Project\Project Code\TrainingImage';
TestImagePath = 'D:\CS6527-Computer Vision\Final Project\Project Code\TestImage';
LabelPath = 'D:\CS6527-Computer Vision\Final Project\Project Code\ImageLabel.txt';
[NumTrainImg,TrainImg] = loadImage( TrainImagePath );
[NumTestImg,TestImg] = loadImage( TestImagePath );
[C,minDist,minDistIndex] = eigenFaceRecognition(TrainImg,TestImg,NumTrainImg,NumTestImg );
RecognizedExpression = strcat(int2str(minDistIndex),'.jpg');
    fid=fopen(LabelPath);
    imageLabel=textscan(fid,'%s %s','whitespace',',');
    fclose(fid);
    Best_Match = cell2mat(imageLabel{1,1}(minDistIndex));
    ExprLabel = cell2mat(imageLabel{1,2}(minDistIndex));
str1 = strcat('Your face expression is like this one:  ',RecognizedExpression);
str2 = strcat('It tells me that you are:  ',ExprLabel);
disp(str1)
disp(str2)
function [numImage,img] = loadImage( strImagePath )
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
numImage = i; 
imageSize = [280,180]; 
img = zeros(imageSize(1)*imageSize(2),numImage);
for i = 1:numImage
    aa = imresize(faceDetection(imresize(imread(Images{i,1}),[375,300])),imageSize);
    img(:,i) = aa(:);
end
meanImage = mean(img,2);        
img = (img - meanImage*ones(1,numImage))';     
end
function pictureCapture
frontCam = videoinput('winvideo', 1,'YUY2_640x480');
set(frontCam,'TriggerRepeat',inf);
set(frontCam,'FramesPerTrigger',1);
set(frontCam,'ReturnedColorSpace','rgb');
vidRes=get(frontCam,'VideoResolution');
nBands=get(frontCam,'NumberOfBands');
fig1 = figure;
set(fig1,'doublebuffer','on');
hImage=image(zeros(vidRes(2),vidRes(1),nBands));
set(fig1,'Name','Please left click your mouse to capture a picture');
set(fig1,'WindowButtonDownFcn',@LeftClickFcn);
fig2 = 0;
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
preview(frontCam, hImage);          
end
