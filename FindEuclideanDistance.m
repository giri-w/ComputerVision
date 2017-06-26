function [ distance] = FindEuclideanDistance( testim,Eigenfacematrix, weightMatrix )
%FINDEUCLIDEANDISTANCE Summary of this function goes here
%Returns the euclidean distance between the differences in testimage and
%the set of images whose PCA is calculated
%   Detailed explanation goes here
%% Subtract mean Part 2
MeanSubDatatest=testim(:)- mean(testim);
%% Find the weight of the input image with respect to eigen faces
weightMatrixtest = MeanSubDatatest' * Eigenfacematrix;
%% Find euclidean distance between the weights of the other image. to find out which set it belongs to
for i=1:size(weightMatrix,1)
        distance(i)=pdist2(weightMatrixtest,weightMatrix(i,:),'euclidean');
end

end

