function output = description_matching(corners, images, show_image, image_name)
 
features = cell(length(corners));
valid_points = cell(length(corners));
[row, col] = find(corners{1});
    
[features{1}, valid_points{1}] = extractFeatures(im2gray(images{1}), [col,row], 'Method', 'SURF');

matches = cell([length(corners)-1 2]);
for i = 2:length(corners)
        [row, col] = find(corners{i});
        [features{i}, valid_points{i}] = extractFeatures(im2gray(images{i}), [col,row], 'Method', 'SURF');
              
        indexPairs = matchFeatures(features{i-1}, features{i}, 'Unique', true);
        valid1 = valid_points{i-1};
        valid2 = valid_points{i};
        matches{i-1,1} = valid1(indexPairs(:,1), :);
        matches{i-1,2} = valid2(indexPairs(:,2), :); 
        
        if show_image && i == 2
        figure; 
        showMatchedFeatures(images{1},images{2},matches{1,1},matches{1,2});
        saveas(gcf, image_name);
        end
end
    output = matches;
end