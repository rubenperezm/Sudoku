function coefMel = MFCC(tramasPalabra, bancosFiltrosMele)
    tf = abs(fft(tramasPalabra));
    tffiltrado = bancosFiltrosMele * tf(1:width(bancosFiltrosMele),:);
    coefMel = log10(tffiltrado);
    coefMel = dct(coefMel)'; 
    % se hace la transpuesta, entonces las filas son las tramas
    % columnas son los centros
end