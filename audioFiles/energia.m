function [salida] = energia(tramas, ventana)
    
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
     salida = sum(tramas.^2 .* w.^2);
    % deberia de enventanar y el reultado al cuadrado, lo de arriba es lo
    % mismo.
end