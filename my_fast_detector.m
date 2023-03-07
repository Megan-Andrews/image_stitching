function [corners, eTime] = my_fast_detector(image, num_of_points, threshold, show_image, image_name)
    tic
    I = image;
    T = threshold;
    N = num_of_points;
    
    I1 = circshift(image,[-3,0]);
    I1(end-2:end,:) = NaN;

    I2 = circshift(image,[-3,-1]);
    I2(end-2:end,:) = NaN;
    I2(:,end) = NaN;

    I3 = circshift(image,[-2,-2]);
    I3(end-1:end,:) = NaN;
    I3(:,end-1:end) = NaN;

    I4 = circshift(image,[-1,-3]);
    I4(end,:) = NaN;
    I4(:,end-2:end) = NaN;

    I5 = circshift(image,[0,-3]);
    I5(:,end-2:end) = NaN;

    I6 = circshift(image,[1,-3]);
    I6(1,:) = NaN;
    I6(:,end-2:end) = NaN;

    I7 = circshift(image,[2,-2]);
    I7(1:2,:) = NaN;
    I7(:,end-1:end) = NaN;

    I8 = circshift(image,[3,-1]);
    I8(1:3,:) = NaN;
    I8(:,end) = NaN;

    I9 = circshift(image,[3,0]);
    I9(1:3,:) = NaN;

    I10 = circshift(image,[3,1]);
    I10(1:3,:) = NaN;
    I10(:,1) = NaN;

    I11 = circshift(image,[2,2]);
    I11(1:2,:) = NaN;
    I11(:,1:2) = NaN;

    I12 = circshift(image,[1,3]);
    I12(1,:) = NaN;
    I12(:,1:3) = NaN;

    I13 = circshift(image,[0,3]);
    I13(:,1:3) = NaN;

    I14 = circshift(image,[-1,3]);
    I14(end,:) = NaN;
    I14(:,1:3) = NaN;

    I15 = circshift(image,[-2,2]);
    I15(end-1:end,:) = NaN;
    I15(:,1:2) = NaN;

    I16 = circshift(image,[-3,1]);
    I15(end-2:end,:) = NaN;
    I15(:,1) = NaN;
    
    imgs_list = {I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13,I14,I15,I16};
    circwndw = cat(16,imgs_list{:});

    % I is a 3D matrix, or a list of images of length 16, where each
    % element of the list is an indicator of whether the surrounding pixel
    % differs from the particular pixel p by the threshold amount
    
    darkerWindow = arrayfun(@(i) darkCompare(I, circwndw(:,:,i), T), 1:16, "UniformOutput",false);
    darkerWindow = cat(3, darkerWindow{:,:});

    lighterWindow = arrayfun(@(i) lightCompare(I, circwndw(:,:,i), T), 1:16, "UniformOutput",false);
    lighterWindow = cat(3, lighterWindow{:,:});

    % permute 3D matrix to obtain a single matrix of arrays of length 16
    darkerWindow = num2cell(permute(darkerWindow, [3 1 2]),1);
    lighterWindow = num2cell(permute(lighterWindow, [3 1 2]),1);

    % determine whether there are corners

    darkerCorner = cellfun(@(x) examineCircle(x, N), darkerWindow);
    lighterCorner = cellfun(@(x) examineCircle(x, N), lighterWindow);
    
    % undo the permutation to obtain the original matrix
    darkerCorner = permute(darkerCorner, [2 3 1]);
    lighterCorner = permute(lighterCorner, [2 3 1]);
    
    % output is a 2D matrix with values that indicate the detected corners
    corners = darkerCorner | lighterCorner;
    eTime = toc;
    output = corners;
    % show the image with the FAST corners
    if show_image
        % plot image
        figure;
        imshow(I);
        hold on;
        [row, col] = find(output);
        plot(col,row,'r+','MarkerSize', 3, 'LineWidth', 0.5)
        hold off;
        saveas(gcf, image_name);
    end
end

function output = darkCompare(Ip, Ix, T)
    output = Ix < Ip-T;
end
function output = lightCompare(Ip, Ix, T)
    output = Ix > Ip+T;
end

function output = examineCircle(A, N)
%A:  an array of the 16 surrounding pixels
    result =0;
    for i = 1:16
        if i+N-1 > 16
            %l = length(A(i:end)) + length(A(1:i+N-17))
            if sum(A(i:end))+ sum(A(1:i+N-17)) == N
                result = 1; % Change the result to true if there are N contiguous pixels
                break; % Stop the loop if N contiguous pixels are found
            end 
        else
            if sum(A(i:i+N-1)) == N
                result = 1; % Change the result to true if there are N contiguous pixels
                break; % Stop the loop if N contiguous pixels are found
            end
        end
    end
    output = result;
end

