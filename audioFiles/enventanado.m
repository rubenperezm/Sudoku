function [res] = enventanado(tramas, window)
    N = height(tramas);
    switch window
        case 'rectangular'
            w = rectwin(N);
        case 'hamming'
            w = hamming(N);
        case 'hanning'
            w = hanning(N);
        otherwise
            disp('Invalid Input')
            res = -1;
            return;
    end
    
    res = tramas .* w;

end