function s = getSquares(data)

    % Primero pasamos la imagen a binaria con el umbral para poder usarla bien
    % en las siguientes operaciones
    umbral = graythresh(data);
    Igray = rgb2gray(data);

    ele = strel('square',5);
    %Dilatación
    imagen_erosionada = imerode(Igray,ele);
    umbral = graythresh(imagen_erosionada);
    %figure, imshow(imagen_erosionada)
    
%     El sudoku está en negro y ajustamos la sensibilidad para pillar todas
%     las líneas
    binary = imbinarize(Igray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.55);
    
    %Cómo hay algunas líneas que se entrecortan aumentamos la zonas negras
    %con erosión paraintentar evitar estas pequeñas zonas en blanco, no
    %queremos reconocer números aquíi así que no nos importa que se queden
    %irreconocibles
    ele = strel('square',5);
    
    binary = imerode(binary,ele);
    binary = imerode(binary,ele);
    binary = imclose(binary,ele);
    binary = imerode(binary,ele);

    %Tapa los agujeros para que no pille un hueco dentro(apertura de area)
    diff_im = bwareaopen(binary, 400);%elimina componentes conectadas con menos de p pixeles
%     figure, imshow(diff_im);
%     s = regionprops(diff_im, 'BoundingBox','Centroid','Area');

    %Obtenemos las casillas
    s = regionprops(diff_im, 'BoundingBox');


    % Eliminamos los cuadrados pequeños (caso de comando por video)
    if length(s) >= 5 && length(s) <= 7
        mat = vertcat(s(:).BoundingBox);
        mat2 = mat(:,4);
        [~,ind] = sort(mat2, 'descend');
        s = s(ind(1:4));
    end
    %Eliminamos el primer rectangulo que siempre es el borde de toda la imagen
    s = s(2:end);
    
    %imprimir_imagen(s, data)
end