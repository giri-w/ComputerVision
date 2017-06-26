function [densHead densLEye densREye densMoustache densBeard]=wrinkleDetection(im_eq)
% Wrinkle Detection 
% Features are extracted based on the position of eyes, nose and mouth that
% are detected using Voila Jones Algorithm


%% Feature Extraction
% ===============================================
close all;
%% Face Ratio
%% Finding ratios of different face features
% Left eye detection
leyeDetect = vision.CascadeObjectDetector('LeftEye', 'UseROI',true);
BBleye= step(leyeDetect,im_eq,[1,1,64,128]);
% finding the center of left eye
leyexy(1,1)= BBleye(1,1)+(BBleye(1,3)/2);
leyexy(1,2)= BBleye(1,2)+(BBleye(1,4)/2);

% Right eye detection
reyeDetect = vision.CascadeObjectDetector('RightEye', 'UseROI',true);
BBreye= step(reyeDetect,im_eq,[64,1,64,128]);
% finding the center of right eye
reyexy(1,1)= BBreye(1,1)+(BBreye(1,3)/2);
reyexy(1,2)= BBreye(1,2)+(BBreye(1,4)/2);

%% Nose detection
noseDetect = vision.CascadeObjectDetector('Nose','UseROI',true);
BBnose= step(noseDetect,im_eq, [1,32,128,96]);
% finding the center of nose
nosexy = [64 64];
temp_nose = zeros(size(BBnose,1),2);

for i=1:size(BBnose,1)
    temp_nose(i,1) = BBnose(i,1)+(BBnose(i,3)/2);
    temp_nose(i,2) = BBnose(i,2)+(BBnose(i,4)/2);
    
    if (abs(temp_nose(i,1) - 64) < abs(nosexy(1,1)))
        nosexy(1,1) = temp_nose(i,1);
        nosexy(1,2) = temp_nose(i,2);
    end    
end

% figure, imshow(im_eq,[]);
% for i = 1:size(BBnose,1)
% 	hold on
%  rectangle('Position',BBnose(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r');
% end

%%

% Mouth detection
mouthDetect = vision.CascadeObjectDetector('Mouth', 'UseROI',true);
BBmouth= step(mouthDetect,im_eq,[1,64,128,64]);
% finding the center of mouth
mouthxy = [64 96];
temp_mouth = zeros(size(BBmouth,1),2);

for i=1:size(BBmouth,1)
    temp_mouth(i,1) = BBmouth(i,1)+(BBmouth(i,3)/2);
    temp_mouth(i,2) = BBmouth(i,2)+(BBmouth(i,4)/2);
    
    if (temp_mouth(i,2) > mouthxy(1,2))
        if (abs(temp_mouth(i,1) - 64) < abs(mouthxy(1,1)))
            mouthxy(1,1) = temp_mouth(i,1);
            mouthxy(1,2) = temp_mouth(i,2);
        end    
    end

end

%% Plot figure
% figure, imshow(im_eq,[]);
% figure, imshow(im_eq,[]); hold on;
% plot(leyexy(1,1),leyexy(1,2),'ob');hold on;
% plot(reyexy(1,1),reyexy(1,2),'ob');hold on;
% plot(nosexy(1,1),nosexy(1,2),'oy');hold on;
% plot(mouthxy(1,1),mouthxy(1,2),'or');

%% Scaling Measurement
% find distances between diferent features
distEyes= reyexy(1,1)- leyexy(1,1);
distEye_Mouth= abs(leyexy(1,2)- mouthxy(1,2));
distEye_Nose = abs(leyexy(1,2) - nosexy(1,2));
distNose_Mouth= nosexy(1,2)- mouthxy(1,2);
distEyeR_Nose = reyexy(1,1)- nosexy(1,1);
distEyeL_Nose = nosexy(1,1)- leyexy(1,1);
distEyeR_Mouth = reyexy(1,1) - mouthxy(1,1);
distEyeL_Mouth = mouthxy(1,1) - leyexy(1,1);
% find the ratios
ratio1=distEye_Mouth/distEyes;
ratio2=distEye_Nose/distEyes;
ratio3=distNose_Mouth/distEyes;
ratio4=distEyeR_Nose/distEyes;
ratio5=distEyeL_Nose/distEyes;
ratio6=distEyeR_Mouth/distEyes;
ratio7=distEyeL_Mouth/distEyes;
ratio8=distEye_Nose/distEye_Mouth;
ratio9=distNose_Mouth/distEye_Mouth;
ratio10=distEyeR_Nose/distEye_Mouth;
ratio11=distEyeL_Nose/distEye_Mouth;
ratio12=distEyeR_Mouth/distEye_Mouth;
ratio13=distEyeL_Mouth/distEye_Mouth;
ratio14=distNose_Mouth/distEye_Nose;
ratio15=distEyeR_Nose/distEye_Nose;
ratio16=distEyeL_Nose/distEye_Nose;
ratio17=distEyeR_Mouth/distEye_Nose;
ratio18=distEyeL_Mouth/distEye_Nose;
ratio19=distEyeR_Nose/distNose_Mouth;
ratio20=distEyeL_Nose/distNose_Mouth;
ratio21=distEyeR_Mouth/distNose_Mouth;
ratio22=distEyeL_Mouth/distNose_Mouth;
ratio23=distEyeL_Nose/distEyeR_Nose;
ratio24=distEyeR_Mouth/distEyeR_Nose;
ratio25=distEyeL_Mouth/distEyeR_Nose;
ratio26=distEyeR_Mouth/distEyeL_Nose;
ratio27=distEyeL_Mouth/distEyeL_Nose;
ratio28=distEyeL_Mouth/distEyeR_Mouth;





%% Wrinkles
% Forehead Area
lowerHead = leyexy(1,2) - distEyes*0.4;
upperHead = leyexy(1,2) - distEyes*1;
rightHead = reyexy(1,1);
leftHead  = leyexy(1,1); 
M1 = [leftHead upperHead (rightHead-leftHead) (lowerHead-upperHead)];
im_wrHead = imcrop(im_eq, M1);
% figure, imshow(im_wrHead,[]);

% Left Eye Area
lowerLEye = leyexy(1,2) + distEye_Mouth*0.40;
upperLEye = leyexy(1,2) + distEye_Mouth*0.08;
rightLEye = leyexy(1,1) + distEyes*0.26;
leftLEye  = leyexy(1,1) - distEyes*0.2;
M2 = [leftLEye upperLEye (rightLEye-leftLEye) (lowerLEye-upperLEye)];
im_wrLeftEye = imcrop(im_eq, M2);
% figure, imshow(im_wrLeftEye,[]);

% Right Eye Are
lowerREye = leyexy(1,2) + distEye_Mouth*0.40;
upperREye = leyexy(1,2) + distEye_Mouth*0.08;
rightREye = reyexy(1,1) + distEyes*0.25;
leftREye  = reyexy(1,1) - distEyes*0.18;
M3 = [leftREye upperREye (rightREye-leftREye) (lowerREye-upperREye)];
im_wrRightEye = imcrop(im_eq, M3);
% figure, imshow(im_wrRightEye,[]);

%% Moustache
lowerMous = mouthxy(1,2) + distNose_Mouth*0.2;
upperMous = nosexy(1,2) - distNose_Mouth*0.35;
rightMous = reyexy(1,1);
leftMous  = leyexy(1,1);
M4 = [leftMous upperMous (rightMous-leftMous) (lowerMous-upperMous)];
M5 = [upperMous lowerMous leftMous rightMous];
im_Moustache = imcrop(im_eq, M4);
% figure, imshow(im_Moustache,[]);

%% Beard
templowerBeard = mouthxy(1,2) - distNose_Mouth*0.7;
if (templowerBeard < 128)
    lowerBeard = templowerBeard;
else
    lowerBeard = 128;
end
upperBeard = mouthxy(1,2) - distNose_Mouth*0.1;
rightBeard = reyexy(1,1);
leftBeard  = leyexy(1,1);
M5 = [leftBeard upperBeard (rightBeard-leftBeard) (lowerBeard-upperBeard)];
im_Beard = imcrop(im_eq, M5);
% figure, imshow(im_Beard,[]);


%% Wrinkle Detection
% Forehead Wrinkle
sizeHead = size(im_wrHead,1) * size(im_wrHead,2);
[GxHead, GyHead] = imgradientxy(im_wrHead,'prewitt');
[GxxHead, GyyHead] = imgradientxy(GyHead,'prewitt');
% BW_Head = edge(mat2gray(GyyHead),'Roberts',0.3);
% densHead = (sum(sum(BW_Head)))/sizeHead; %Dens of Head Wrinkle

% Left Eye Wrinkle
sizeLEye = size(im_wrLeftEye,1) * size(im_wrLeftEye,2);
[GxLEye, GyLEye] = imgradientxy(im_wrLeftEye,'prewitt');
[GxxLEye, GyyLEye] = imgradientxy(GyLEye,'prewitt');
% BW_LEye = edge(mat2gray(GyyLEye),'Roberts',0.3);
% densLEye = (sum(sum(BW_LEye)))/sizeLEye; %Dens of Left Eye Wrinkle

% Right Eye Wrinkle
sizeREye = size(im_wrRightEye,1) * size(im_wrRightEye,2);
[GxREye, GyREye] = imgradientxy(im_wrRightEye,'prewitt');
[GxxREye, GyyREye] = imgradientxy(GyREye,'prewitt');
% BW_REye = edge(mat2gray(GyyREye),'Roberts',0.3);
% densREye = (sum(sum(BW_REye)))/sizeREye; %Dens of Right Eye Wrinkle


% Moustache
sizeMoustache = size(im_Moustache,1) * size(im_Moustache,2);
[GxMoustache, GyMoustache]   = imgradientxy(im_Moustache,'prewitt');
[GxxMoustache, GyyMoustache] = imgradientxy(GyMoustache,'prewitt');
% BW_Moustache = edge(mat2gray(GyyMoustache),'Roberts',0.3);
% densMoustache = (sum(sum(BW_Moustache)))/sizeMoustache; %Dens of Moustache

% Beard
sizeBeard = size(im_Beard,1) * size(im_Beard,2);
[GxBeard, GyBeard]   = imgradientxy(im_Beard,'prewitt');
[GxxBeard, GyyBeard] = imgradientxy(GyBeard,'prewitt');
% BW_Beard = edge(mat2gray(GyyBeard),'Roberts',0.3);
% densBeard = (sum(sum(BW_Beard)))/sizeBeard; %Dens of Beard

%% Binary Method
thresholdValue = 0.35;
BW_Head = mat2gray(GyyHead) < thresholdValue; % Bright objects will be chosen if you use >.
BW_Head = imfill(BW_Head, 'holes');
BW_REye = mat2gray(GyyREye) < thresholdValue; % Bright objects will be chosen if you use >.
BW_REye = imfill(BW_REye, 'holes');
BW_LEye = mat2gray(GyyLEye) < thresholdValue; % Bright objects will be chosen if you use >.
BW_LEye = imfill(BW_LEye, 'holes');
BW_Moustache = mat2gray(GyyMoustache) < thresholdValue; % Bright objects will be chosen if you use >.
BW_Moustache = imfill(BW_Moustache, 'holes');
BW_Beard = mat2gray(GyyBeard) < thresholdValue; % Bright objects will be chosen if you use >.
BW_Beard = imfill(BW_Beard, 'holes');

densHead = (sum(sum(BW_Head)))/sizeHead; %Dens of Head Wrinkle
densLEye = (sum(sum(BW_LEye)))/sizeLEye; %Dens of Left Eye Wrinkle
densREye = (sum(sum(BW_REye)))/sizeREye; %Dens of Right Eye Wrinkle
densMoustache = (sum(sum(BW_Moustache)))/sizeMoustache; %Dens of Moustache
densBeard = (sum(sum(BW_Beard)))/sizeBeard; %Dens of Beard


%% Plot Value
figure,
subplot(2,5,1), imshow(im_wrHead), title (['Size Head ' num2str(size(im_wrHead))]);
subplot(2,5,2), imshow(im_wrLeftEye), title (['Size Left Eye ' num2str(size(im_wrLeftEye))]);
subplot(2,5,3), imshow(im_wrRightEye), title (['Size Right Eye ' num2str(size(im_wrRightEye))]);
subplot(2,5,4), imshow(im_Moustache), title (['Size Moustache ' num2str(size(im_Moustache))]);
subplot(2,5,5), imshow(im_Beard), title (['Size Beard ' num2str(size(im_Beard))]);
subplot(2,5,6), imshow(BW_Head), title (['Dens Head ' num2str(densHead)]);
subplot(2,5,7), imshow(BW_LEye), title (['Dens Left Eye ' num2str(densLEye)]);
subplot(2,5,8), imshow(BW_REye), title (['Dens Right Eye ' num2str(densREye)]);
subplot(2,5,9), imshow(BW_Moustache), title (['Dens Moustache ' num2str(densMoustache)]);
subplot(2,5,10),imshow(BW_Beard), title (['Dens Beard' num2str(densBeard)]);

%% Add Weights
densHead= densHead*10;
densLEye = densLEye*25;
densREye = densREye *25;
densMoustache = densMoustache *10;
densBeard = densBeard *30;

end