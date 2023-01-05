function sudoku = getSudoku(img)
    

    img = CorrectPerspective(img);

    %Obtemos las casillas
    s = getSquares(img);

   

    if length(s) == 81
        roi = sortByCoordinates(s);
        umbral = graythresh(img);
        Igray = rgb2gray(img);
        
        binary = imbinarize(Igray,'adaptive','ForegroundPolarity','dark');
    
        %binary = imbinarize(Igray,umbral);%a binaria
        
        %Eliminamos todo lo que no es un número, es decir, las casillas
        
        BWComplement = ~binary;
    
        ele =  strel('square',4);
        %BWComplement = imdilate(BWComplement,ele);
        BWComplement = imclose(BWComplement,ele);
        %Buscamos todas las componentes conexas de la imagen
        CC = bwconncomp(BWComplement);
        
        %Las componentes conexas más grandes, con más pixeles, será el recuadro y
        %los bordes en el caso de que la imagen esté rotada mal(se quedan bordes
        %negros)
        numberPixels = cellfun(@numel, CC.PixelIdxList);
        idx = find(numberPixels > 5000);
        for i=1: length(idx)
            BWComplement(CC.PixelIdxList{idx(i)}) = 0;
        end
        idx = find(numberPixels < 400);
        for i=1: length(idx)
            BWComplement(CC.PixelIdxList{idx(i)}) = 0;
        end
        
        BWComplement = imclose(BWComplement, ele);
        %BWComplement = imclose(BWComplement,ele);
        %Le indicamos donde tiene que buscar los numeros, es decir, 
        %en las casillas que ya hemos calculado
    %     roi = vertcat(s(:).BoundingBox);
        
        %Obtenemos los números de la siguiente imagen (Sin esqueleto)
    %     BWComplement = imerode(BWComplement, strel('square',3));
    %     BWComplement = imerode(BWComplement, strel('square',3));
    
        %Esqueleto
        ele =  strel('square',4);
        BWComplement=bwmorph(BWComplement,'thin',Inf);
        BWComplement = imclose(BWComplement,ele);
        BWComplement = imdilate(BWComplement,ele);
    
    
    
        figure, imshow(BWComplement);
        results = ocr(BWComplement, roi, 'TextLayout', 'Character','CharacterSet','0':'9');
        
        % Eliminamos los espacios en blanco de los resultados
        ce = cell(1,numel(results));
        for i = 1:numel(results)
            ce{i} = deblank(results(i).Text);
        end
        
        final = insertObjectAnnotation(im2uint8(binary), 'Rectangle', roi, ce);
        figure
        imshow(final)

        sudoku = zeros(9,9);
        for i = 1: length(ce)
            %pos = ind2sub([9 9],i)
            if strcmp(ce{i}, '')
                r = uint16(roi(i, :));
                img = binary(r(2): r(2)+r(4), r(1):r(1)+r(3));
                if i == 76
                    figure, imshow(img);
                end
                if(length(find(img == 0)) > 0.1 * numel(img))
                    sudoku((ind2sub([9 9],i))) = 8;
                end
            else 
                sudoku((ind2sub([9 9],i))) = str2num(ce{i});
            end
        end
    else
        sudoku = 0;
    end
    sudoku = sudoku';
end