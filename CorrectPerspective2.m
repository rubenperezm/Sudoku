function fixedImage = CorrectPerspective2(img)

    Igray = rgb2gray(img);
    binary = imbinarize(Igray,'adaptive','ForegroundPolarity','dark');
    puzzleFilled = imfill(~binary, 'holes');
    
    %CC = bwconncomp(BWComplement);
    
    %Las componentes conexas más grandes, con más pixeles, será el recuadro y
    %los bordes en el caso de que la imagen esté rotada mal(se quedan bordes
    %negros)
    diff_im = bwareaopen(puzzleFilled, 1500);
    ele =  strel('square',4);
    %BWComplement = imdilate(BWComplement,ele);
    %diff_im = imclose(diff_im,ele);

    diff_im = (imdilate(imdilate(edge(diff_im,'canny'), ele), ele)); 

    

    % Board line detection via Hough Transform:
    [ H, theta, rho ] = hough(diff_im);
    maxPeaks = 10;
    peakThreshold = ceil( 0.5 * max( H(:) ) );
    
    P = houghpeaks(H, maxPeaks, 'threshold', peakThreshold);
    
    x = theta( P(:,2) );
    y = rho( P(:,1) );
    
    % Apply the line detector:
    lines = houghlines(diff_im, theta, rho, P, 'FillGap', 100, 'MinLength', 200);
    
    % Get detected lines:
    totalLines = length(lines);

    if totalLines ~= 2
        fixedImage = zeros(height(img), width(img),3);
        return
    end
    % Get detected lines:
    points = zeros(2*totalLines, 2);


    % imprimimos las líneas detectadas
%     imshow(diff_im); hold on;
    for lineIndex = 1:totalLines
        xy = [ lines(lineIndex).point1; lines(lineIndex).point2 ];
        rowEnd = 2*lineIndex;
        rowStart = rowEnd - 1;
        points(rowStart:rowEnd,1:2) = xy;
       
%             plot( xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green' );
%             plot( xy(1,1), xy(1,2), 'x', 'LineWidth', 2, 'Color', 'yellow' );
%             plot( xy(2,1), xy(2,2), 'x', 'LineWidth', 2, 'Color', 'red' );
    
    end
 
    if lines(1).point1(2) < lines(2).point1(2)
        c1 = lines(1).point1;
        c2 = lines(1).point2;
        c3 = lines(2).point1;
        c4 = lines(2).point2;
    else
        c3 = lines(1).point1;
        c4 = lines(1).point2;
        c1 = lines(2).point1;
        c2 = lines(2).point2;
    end

    size = 1000;
    % Definimos las posiciones deseadas de las esquinas
    desiredCorners = [0, 0; 0, size; size, size; size, 0];
    
    %Rotamos la imagen para tener el sudoku recto
    tform = fitgeotrans([c1;c2;c4;c3],desiredCorners,'projective');
    
    % Transform the image
    fixedImage = imwarp(img, tform);
    %figure, imshow(fixedImage);
    %fixedImage = ~fixedImage;
end
