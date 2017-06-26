function [WrinklePCA,WrinklePCAweight] = trainSet(list,numIM)


for i=1:size(list,1)
    var=cd;
    path=strcat(var,'\Simple Database\',list(i,:),'\');
    dataAdd=dir(path);
    %dataAdd=dir(strcat(cd,'\Simple Database\',list(i,:),'\'));
    for j=3:(3+numIM-1)
        image_name = dataAdd(j).name;
        image_path = strcat(path,image_name);
        %image_path = strcat(dataAdd(j).folder,'\',image_name);
        im = imread(image_path);
        newimageDB(:,:,i,j-2)= GetCroppedImage(im);
        [WrData(i,1,j-2),WrData(i,2,j-2),WrData(i,3,j-2),WrData(i,4,j-2),WrData(i,5,j-2)]= wrinkleDetection(newimageDB(:,:,i,j-2));
    end
    PCAWrData(:,:) = WrData(i,:,:);
    [WrinklePCA(i,:,:),WrinklePCAweight(i,:,:)] = PCA(PCAWrData);
    
    figure,
    for k=1:size(newimageDB,4)
        subplot(2,5,k), imshow(newimageDB(:,:,i,k)), title (['Face ' num2str(k)]);
    end
    
end

% 
% 
% % Train Set for Categoriy 10s
% data10=dir(strcat(cd,'\Simple Database\10s\'));
% for j=3:(3+9)
%     image_name = data10(j).name;
%     image_path = strcat(data10(j).folder,'\',image_name);
%     im = imread(image_path);
%     newimageDatabase10(:,:,j-2)= GetCroppedImage(im);
%     [Wrinkle10(1,j-2),Wrinkle10(2,j-2),Wrinkle10(3,j-2),Wrinkle10(4,j-2),Wrinkle10(5,j-2)]= wrinkleDetection(newimageDatabase10(:,:,j-2));
% end
% [WrinklePCA10,WrinklePCAweight10] = PCA(Wrinkle10);

% % Train Set for Categoriy 40s
% data40=dir(strcat(cd,'\Simple Database\40s\'));
% for j=3:(3+9)
%     image_name = data40(j).name;
%     image_path = strcat(data40(j).folder,'\',image_name);
%     im = imread(image_path);
%     newimageDatabase40(:,:,j-2)= GetCroppedImage(im);
%     [Wrinkle40(1,j-2),Wrinkle40(2,j-2),Wrinkle40(3,j-2),Wrinkle40(4,j-2),Wrinkle40(5,j-2)]= wrinkleDetection(newimageDatabase40(:,:,j-2));
% end
% [WrinklePCA40,WrinklePCAweight40] = PCA(Wrinkle40);
% 
% 
% %% Show the Database
% figure,
% for i=1:size(newimageDatabase10,3)
% subplot(2,5,i), imshow(newimageDatabase10(:,:,i)), title (['Face ' num2str(i)]);
% end
% 
% figure,
% for i=1:size(newimageDatabase40,3)
% subplot(2,5,i), imshow(newimageDatabase40(:,:,i)), title (['Face ' num2str(i)]);
% end
% 


end