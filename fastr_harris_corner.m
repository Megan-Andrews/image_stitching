function [corners, elapsed_time] = fastr_harris_corner(image, points, threshold, show_image, image_name)
    tic
    sobel = [-1 0 1; -2 0 2; -1 0 1];
    gaus = fspecial('gaussian',5,1);
    dog = conv2(gaus,sobel);
    ix = imfilter(image, dog);
    iy = imfilter(image, dog');
    ix2g = imfilter(ix .* ix, gaus);
    iy2g = imfilter(iy .* iy, gaus);
    ixiyg = imfilter(ix .* iy, gaus);
    harcor = ix2g .* iy2g - ixiyg .* ixiyg - 0.05 * (ix2g + iy2g) .^ 2;
    
    localmax = imdilate(harcor, ones(3)); % this will give the local maximum 
    % imdilate it looks at the neighborhood of binary values, it puts the maximum of the neighborhood

    corners = (points.*(harcor == localmax).* (harcor>threshold)); % this gives the harris corners of the image
    elapsed_time = toc;
    % show the image with the FAST corners
    output = corners;
    if show_image
        % plot image
        figure;
        imshow(image);
        hold on;
        [row, col] = find(output);
        plot(col,row,'r+','MarkerSize', 3, 'LineWidth', 0.5);
        
        hold off;
        saveas(gcf, image_name);
    end
end
