function [salida] = magnitud(tramas, ventana)
    
    N = height(ventana);
    switch ventana
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
    
    salida = sum(abs(tramas) .* w);
    

    % deberia de enventanar y el reultado en valor absoluto, lo de arriba es lo
    % mismo.
end