clear all; %remove all variables in workspace
close all; %close all opening figures
clc; %clear the command window

% Read images: Target and the Source
img_source = imread('UD_winter.jpg'); 
img_target = imread('UD_spring.jpg');

% Resize images
height = 200;
width = 300;
img_source = imresize(img_source,[height width]);
img_target = imresize(img_target,[height width]);

% Convert RGB to Lab color space
img_source_lab= rgb2lab(img_source);
img_target_lab= rgb2lab(img_target);

% Neighboring window size 
N = 13;
window_size = [N,N];

% Calculate the Indent
indent = (window_size-1)/2;

% Compute mean and sd of each color channel
tic
for i=indent+1 : height-indent
    for j=indent+1 : width-indent
        for c = 1:3
            % For source image
            temp = img_source_lab(:,:,c);
            Source_window=temp(i-indent:i+indent,j-indent:j+indent);
            mean_source= mean(Source_window(:));
            sd_source= std(Source_window(:));
            
            % For target image
            temp = img_target_lab(:,:,c);
            target_window=temp(i-indent:i+indent,j-indent:j+indent);
            mean_target= mean(target_window(:));
            sd_target= std(target_window(:));
            
            img_source_lab(:,:,c) = (sd_target/(eps+sd_source))*(img_source_lab(:,:,c) ...
                -mean_source) + mean_target;
        end
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
sgtitle('Pixels in the 9 x 9 window','FontSize',28,'FontName','Times New Roman','Color','r');


% Enlarge figure to full screen
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


