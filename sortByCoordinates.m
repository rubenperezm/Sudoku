function final = sortByCoordinates(s)

%Obtenemos los cuadrados a ordenar
    mat = vertcat(s(:).BoundingBox);

    %Los dos primeros valores de BoundingBox son la coordenada de la
    %esquina superior izquierda, ordenaremos según eso
    %Ordenamos primero de más alto a más bajo, es decir, por filas
    mat2 = mat(:,2);

    [~,ind] = sort(mat2);
    mat = mat(ind,:);

    %Después, cada fila la queremos ordenar de izquierda a derecha
    final = [];
    i = 0;
    while i <81
        row = mat(i+1:i+9,:);
        row2 = row(:,1);
        [~,ind] = sort(row2);
        row = row(ind,:);
        final = [final; row];
        i = i+9;
    end

end