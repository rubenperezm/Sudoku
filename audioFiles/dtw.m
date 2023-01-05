function res = dtw(p, t)
    N = width(p)+1;
    M = width(t)+1;
    DTW = zeros(N, M);
    DTW(2:end, 1) = Inf;
    DTW(1, 2:end) = Inf;
    
    for i=2:N
        for j=2:M
            dist = euclidea(p(:,i-1), t(:,j-1));
            DTW(i,j) = dist + min( [DTW(i-1, j) DTW(i, j-1) DTW(i-1, j-1)] );
        end
    end
    
    res = DTW(end, end);
end

function d = euclidea(x, y)
    aux = x-y*ones(1,size(x,2));
    d = calc(aux);
end

function d = calc(x)
    if size(x,1)==1
       x=x';
    end
    d=sqrt(sum(x.*x));
end