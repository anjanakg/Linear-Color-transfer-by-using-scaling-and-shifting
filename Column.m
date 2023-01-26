clear all; %remove all variables in workspace
close all; %close all opening figures
clc; %clear the command window

% Read images: Target and the Source
img_source = imread('source.jpg'); 
img_target = imread('target.jpg');

% Resize the images
height = 200;
width = 300;
img_source = imresize(img_source,[height width]);
img_target = imresize(img_target,[height width]);

% Convert RGB to Lab color space
img_source_lab= rgb2lab(img_source);
img_target_lab= rgb2lab(img_target);


% Compute mean and sd of each color channel
tic
for j = 1 : width
        for c = 1:3
            % For source image
            temp = img_source_lab(:,j,c);
            mean_source= mean(temp(:));
            sd_source= std(temp(:));
            
            % For target image
            temp = img_target_lab(:,j,c);
            mean_target= mean(temp(:));
            sd_target= std(temp(:));
            
            img_source_lab(:,:,c) = (sd_target/sd_source)*(img_source_lab(:,:,c)-mean_source)+ mean_target;
        end
end
toc
% Transform back to RGB
img_result= lab2rgb(img_source_lab);

% Display the result
subplot(1,3,1); imshow(img_source); mt(1) = title('SOURCE');
subplot(1,3,2); imshow(img_target); mt(2) = title('TARGET');
subplot(1,3,3); imshow(img_result,[]); mt(3) = title('RESULTS');
set(mt,'Position',[150 200],'VerticalAlignment','top','Color',[0 0 0]);
sgtitle('Pixels in the same column ','FontSize',28,'FontName','Times New Roman','Color','r');


% Enlarge figure to full screen
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

