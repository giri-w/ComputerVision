function [ imout ] = GetCroppedImage( im )
%GETCROPPEDIMAGE Summary of this function goes here
% returns the in put image after straightening it and cropping it to the
% dimension of 128X128 pixels
%   Detailed explanation goes here

% converttograyscale
grayImage= rgb2gray(im);
% figure, imshow(grayImage,[]);

% Detecting Face
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
BBFace= step(FaceDetect,grayImage);
% Select face
facexy = [1 1 1 1];
temp_Face = zeros(size(BBFace,1),4);
for i=1:size(BBFace,1)
    temp_Face(i,:) = BBFace(i,:);
    
    if (temp_Face(i,3) > facexy(1,3))
        facexy(1,:) = temp_Face(i,:);
    end    
end
BBFace = facexy;


for i = 1:size(BBFace,1)
	hold on
 rectangle('Position',BBFace(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
end


% Detecting Left Eye
EyeDetectLeft = vision.CascadeObjectDetector('LeftEye','UseROI',true);
BBLeft=step(EyeDetectLeft,grayImage,[BBFace(1),BBFace(2),BBFace(3)/2,BBFace(4)]);

% Detecting Right Eye
EyeDetectRight = vision.CascadeObjectDetector('RightEye','UseROI',true);
BBRight=step(EyeDetectRight,grayImage,[(BBFace(1)+ BBFace(3)/2),BBFace(2),BBFace(3)/2,BBFace(4)]);

%% Show Eye Location
% figure, imshow(grayImage,[]);
% for i = 1:size(BBRight,1)
% 	hold on
%  rectangle('Position',BBRight(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
% end
% for i = 1:size(BBLeft,1)
% 	hold on
%  rectangle('Position',BBLeft(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
% end

%% Center of the Right eye
rightxy = [size(im,2) size(im,1) 1 1];
temp_Right = zeros(size(BBRight,1),2);
for i=1:size(BBRight,1)
    temp_Right(i,1) = BBRight(i,1)+(BBRight(i,3)/2);
    temp_Right(i,2) = BBRight(i,2)+(BBRight(i,4)/2);
    
    if (temp_Right(i,2) < rightxy(1,2))
        if (abs(temp_Right(i,1) - (BBFace(1)+ 3*BBFace(3)/4)) < abs(rightxy(1,1)))
            rightxy(1,1) = temp_Right(i,1);
            rightxy(1,2) = temp_Right(i,2);
        end 
    end
end

%% Center of the Left eye
leftxy = [size(im,2) size(im,1) 1 1];
temp_Left = zeros(size(BBLeft,1),2);
for i=1:size(BBLeft,1)
    temp_Left(i,1) = BBLeft(i,1)+(BBLeft(i,3)/2);
    temp_Left(i,2) = BBLeft(i,2)+(BBLeft(i,4)/2);
    
    if (temp_Left(i,2) < leftxy(1,2))
        if (abs(temp_Left(i,1) - (BBFace(1)+ BBFace(3)/4)) < abs(leftxy(1,1)))
            leftxy(1,1) = temp_Left(i,1);
            leftxy(1,2) = temp_Left(i,2);
        end    
    end
end

% for i = 1:size(BBRight,1)
%  eyex(i)= BBRight(i,1)+(BBRight(i,3)/2);
%  eyey(i)= BBRight(i,2)+(BBRight(i,4)/2);
% end

%% Show Eye Location
% figure, imshow(grayImage,[]);
% hold on;
% plot(rightxy(1,1),rightxy(1,2),'ob');
% hold on;
% plot(leftxy(1,1),leftxy(1,2),'or');


%% Rotate the image

theta = atan((rightxy(1,2) - leftxy(1,2))/(rightxy(1,1) - leftxy(1,1)));
M1   = [1 0 0;0 1 0;-(size(grayImage,2)/2) -(size(grayImage,1)/2)  1];
Mrot = [cos(-theta) sin(-theta) 0; -sin(-theta) cos(-theta) 0; 0 0 1];
tform1 = maketform('affine',M1);
tform2 = maketform('affine',M1*Mrot);

pic1 = imtransform(grayImage,tform1);
% figure,imshow(pic1,[]);
pic2 = imtransform(pic1,tform2);
% figure,imshow(pic2,[]);

%% Crop the Image
rotim= pic2;
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
BBFace= step(FaceDetect,rotim);
% Select face
facexy = [1 1 1 1];
temp_Face = zeros(size(BBFace,1),4);
for i=1:size(BBFace,1)
    temp_Face(i,:) = BBFace(i,:);
    
    if (temp_Face(i,3) > facexy(1,3))
        facexy(1,:) = temp_Face(i,:);
    end    
end

cropim= imcrop(rotim, facexy);
% figure, imshow(cropim)

%% Resize the image
ratioresize= 128/size(cropim,1);
im_r=imresize(cropim,ratioresize);

%% Image Equalization
im_eq = histeq(im_r);
% figure, imshow(im_eq,[]);
imout=im_eq;
end

