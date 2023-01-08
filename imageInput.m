function [row, col, num] = imageInput(img)
    

    %Corregimos la perspectiva
    img = CorrectPerspective(img);

    %Obtemos las casillas
    s = getSquares(img);

   
    %Si no hemos encontrado 81 casillas exactemente vamos a tener problemas
    %al clasificar los números así que en el caso de que no la pillemos
    %bien devolvemos 0 para volver a intentarlo.
    if length(s) == 3
        %Obtenemos los recuadros ordenados por sus coordenadas
        roi = sortByCoord(s);
        umbral = graythresh(img);
        Igray = rgb2gray(img);
        
        binary = imbinarize(Igray,'adaptive','ForegroundPolarity','dark');
    
        
        % A partir de ahora eliminamos todo lo que no es un número, 
        % es decir, las casillas

        
        BWComplement = ~binary;
    
        ele =  strel('square',4);

        %BWComplement = imdilate(BWComplement,ele);
        BWComplement = imclose(BWComplement,ele);
        %Buscamos todas las componentes conexas de la imagen (Conjuntos de
        %píxeles conectados de color blanco)
        CC = bwconncomp(BWComplement);
        
        %Las componentes conexas más grandes, con más pixeles, será el recuadro y
        %los bordes en el caso de que la imagen esté rotada (se quedan bordes
        %negros)
        numberPixels = cellfun(@numel, CC.PixelIdxList);
        idx = find(numberPixels > 5000);
        for i=1: length(idx)
            BWComplement(CC.PixelIdxList{idx(i)}) = 0;
        end
        %Por la iluminación a veces detecta pequeñas zonas pintadas
        % dónde no hay nada así que también los eliminamos para no tener
        % problema al clasificar números
        idx = find(numberPixels < 400);
        for i=1: length(idx)
            BWComplement(CC.PixelIdxList{idx(i)}) = 0;
        end
       
        %Le indicamos donde tiene que buscar los numeros, es decir, 
        %en las casillas que ya hemos calculado
    %     roi = vertcat(s(:).BoundingBox);
        
        %Moldeamos los números de la siguiente imagen para que no haya
        % Problema por si un número es demasiado gordo(Sin esqueleto)
        BWComplement = imclose(BWComplement, ele);
        ele =  strel('square',3);
        BWComplement = imerode(BWComplement, ele);
        BWComplement = imerode(BWComplement, ele);
    
        %Esqueleto y dilatar, así pillaba mejor los 8 pero empezaba a
        %fallar con los 6
%         ele =  strel('square',4);
%         BWComplement=bwmorph(BWComplement,'thin',Inf);
%         BWComplement = imclose(BWComplement,ele);
%         BWComplement = imdilate(BWComplement,ele);
    
    
    
        %Obtenemos los numeros de la siguiente imagen
        %figure, imshow(BWComplement);
        results = ocr(BWComplement, roi, 'TextLayout', 'Character','CharacterSet','0':'9');
        
%         % Eliminamos los espacios en blanco de los resultados
        ce = cell(1,numel(results));
        for i = 1:numel(results)
            ce{i} = deblank(results(i).Text);
        end
        
        %Imprimir los numeros detectados en la imagen
%         final = insertObjectAnnotation(im2uint8(binary), 'Rectangle', roi, ce);
%         figure
%         imshow(final)

        rowcolnum = [0 0 0];
        for i = 1: length(ce)
            if strcmp(ce{i}, '')
                r = uint16(roi(i, :));
                img = binary(r(2): r(2)+r(4), r(1):r(1)+r(3));
                if(length(find(img == 0)) > 0.2 * numel(img))
                    rowcolnum(i) = 8;
                else
                    row = 0; col = 0; num = 0;
                    return
                end
            else 
                rowcolnum(i) = str2num(ce{i});
            end
        end
        row = rowcolnum(1); col = rowcolnum(2); num = rowcolnum(3);
    else
        row = 0; col = 0; num = 0;
    end
end

function final = sortByCoord(s)
    mat = vertcat(s(:).BoundingBox);

    mat2 = mat(:,1);

    [~,ind] = sort(mat2);
    final = mat(ind,:);
end