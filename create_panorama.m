function output = create_panorama(matches, images, image_name, blender)
% adapted from: https://www.mathworks.com/help/vision/ug/feature-based-panoramic-image-stitching.html
numImages = length(images);
tforms(numImages) = projtform2d;

xlim = zeros([length(tforms) 2]);
ylim = zeros([length(tforms) 2]);

for i = 2:length(images)
match2 = matches{i-1,2};
match1 = matches{i-1,1};
tforms(i) = estgeotform2d(match2, match1,'projective', 'MaxNumTrials', 1000, ...
    'Confidence', 99, 'MaxDistance', 3);

tforms(i).A = tforms(i-1).A * tforms(i).A;    
[xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 size(images{i},2)], [1 size(images{i},1)]);

end

% avgXLim = mean(xlim, 2);
% [~,idx] = sort(avgXLim);
% centerIdx = floor((numel(tforms)+1)/2);
% centerImageIdx = idx(centerIdx);
% 
% Tinv = invert(tforms(centerImageIdx));
% for i = 1:numel(tforms)    
%     tforms(i).A = Tinv.A * tforms(i).A;
% end

% Find the minimum and maximum output limits. 
xMin = min([1; xlim(:)]);
xMax = max([size(images{1},1); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([size(images{1},2); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width]);%, 'like', images{centerImageIdx});

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];

panoramaView = imref2d([height width], xLimits, yLimits);


% Create the panorama.
for i = 1:length(images)
    I = images{i};   
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

imwrite(panorama, image_name);

output=panorama;

end