function [salida] = tasaCrucesxCero(tramas, ventana)
    S = sign(tramas);
    result = (abs(S(1:end-1,:) - S(2:end, :))) / 2;
    salida=sum(enventanado(result,ventana)/size(tramas,1));
end

% Fs       = 8000 Hz
% t        = 30 mseg
% longitud = t * Fs = 0.03 * 8000 = 240 muestras

% es importante dividir por 30 milisegundos, el dato que nos de (tantos
% cruces por cero)
