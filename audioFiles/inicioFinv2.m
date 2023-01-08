function [tramasPalabra, inicioPalabra, finPalabra] = inicioFinv2(tramas, numTramasRuido, ventana)
        
    % paso 1
    z = tasaCrucesxCero(tramas, ventana);
    m = magnitud(tramas, ventana);
    M = m; Z = z;

    % paso 2
    mediaZ = mean(z(1:numTramasRuido));
    mediaZ2 = mean(z(end-numTramasRuido+1));
    desvZ  = std(z(1:numTramasRuido));
    desvZ2  = std(z(end-numTramasRuido+1));

    mediaM = mean(m(1:numTramasRuido));
    mediaM2 = mean(m(end-numTramasRuido+1:end));
    desvM  = std(m(1:numTramasRuido));
    desvM2 = std(m(end-numTramasRuido+1:end));
    
    % paso 3
    UmbSupEnrg = 0.1 * max(m);
    UmbInfEnrg = max(mediaM + 2*desvM, mediaM2 + 2*desvM2); % me quedo con el maximo
    UmbCruCero = max(mediaZ + 2*desvZ, mediaZ2 + 2*desvZ2); % me quedo con el maximo
    
    inicioPalabra = steps(M, Z, UmbSupEnrg, UmbInfEnrg, UmbCruCero, numTramasRuido);
    finPalabra = steps(flip(M), flip(Z), UmbSupEnrg, UmbInfEnrg, UmbCruCero, numTramasRuido);
    finPalabra = width(M) - finPalabra;

 
    tramasPalabra = tramas(:, inicioPalabra:finPalabra);
end

function [inicioPalabra] = steps(M, Z, UmbSupEnrg, UmbInfEnrg, UmbCruCero, numTramasRuido)
    % paso 4
    i = numTramasRuido + 1;
    ln = i;
    while i <= width(M) && M(i) <= UmbSupEnrg
        i = i + 1;
        ln = i;
    end

    % paso 5
    i = ln;
    le = i;
    while i >= numTramasRuido+1 && M(i) >= UmbInfEnrg
        i = i - 1;
        le = i;
    end
   
    % paso 6
    i = max(le-25, numTramasRuido+1);
    ind = find(Z(i:le) > UmbCruCero);
    
    % por defecto vale le;
    inicioPalabra = le;
    
    % si ecnotramos consecutivas actualizamos
    consecutivas = ind(find(diff(ind) == 1));
    consecutivas = consecutivas(find(diff(consecutivas) == 1));

    if ~isempty(consecutivas)
        inicioPalabra = i + consecutivas(1);
    end
end