function [ OutputData, WeightMatrix ] = PCA( PCADatabase)
%PCA Summary of this function goes here
% Gets the PCA Eigen faces in OutputData and the weights in the
% weightMatrix
%   Detailed explanation goes here
%% Subtract mean Part 2
MeanSubData= zeros(size(PCADatabase));
for i=1:size(PCADatabase,2)
MeanSubData(:,i)=PCADatabase(:,i)- mean(PCADatabase(:,i));
end
%% Calculate covariance Matrix Part 3
covarianceMatrix = cov(MeanSubData);
%% Calculate Eigen Vectors and Eigen Values Part 4
[eigenVector,eigenValue]= eig(covarianceMatrix);
% %% Choosing new Dimesions based on eigen values Part 5
% newEigenVector(:,1)= eigenVector(:,4);
% newEigenVector(:,2)= eigenVector(:,5);
%% Calculating new Data Set Part 6 
OutputData= (MeanSubData)*(eigenVector);
%% weight of each image with the eigenvectors
WeightMatrix = MeanSubData' * OutputData;
end

