function [salida] = tasaCrucesxCero(tramas, ventana)
    S = sign(tramas);
    result = (abs(S(1:end-1,:) - S(2:end, :))) / 2;
    salida=sum(enventanado(result,ventana)/size(tramas,1));
end