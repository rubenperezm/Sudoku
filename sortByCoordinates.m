function final = sortByCoordinates(s)


    mat = vertcat(s(:).BoundingBox);

    mat2 = mat(:,2);

    [~,ind] = sort(mat2);
    mat = mat(ind,:);
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