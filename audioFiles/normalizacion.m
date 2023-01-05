function caracteristicasNorm = normalizacion(caracteristicas)
    caracteristicasNorm = ...
        (caracteristicas - mean(caracteristicas))/std(caracteristicas);
end