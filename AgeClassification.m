% clear all;
close all;
%% Initialization 
flagTrainDatabase = 0; %Set '1' to train the Database
listOfCtg = ['10s';'40s']; %Set age group
numberOfIm = 10; %Set number of Image for each catagories

%% Create Database for different age group
if flagTrainDatabase == 1
    [EigenSet,WeightMatrix]=trainSet(listOfCtg,numberOfIm);
end
%---------------------------------------------------------------------------------------
%% Test image Euclidean checking
testim= imread('ds_10_6.JPG');

% converttograyscale
newimagetest= GetCroppedImage(testim);
% find Wrinkles of test image
[WrinkleTest(1),WrinkleTest(2),WrinkleTest(3),WrinkleTest(4),WrinkleTest(5)]= wrinkleDetection(newimagetest);
% Create Reordering in Column wise

% Find Euclidean Distance
EigenSet40 = squeeze(EigenSet(2,:,:));
EigenSet10 = squeeze(EigenSet(1,:,:));
WeightMatrix40 = squeeze (WeightMatrix(2,:,:));
WeightMatrix10 = squeeze (WeightMatrix(1,:,:));

distance1= FindEuclideanDistance(WrinkleTest,EigenSet40,WeightMatrix40);
distance2= FindEuclideanDistance(WrinkleTest,EigenSet10,WeightMatrix10);

if(mean(distance1)>mean(distance2))
    disp('The person is young');
else
    disp('The person is old');
end