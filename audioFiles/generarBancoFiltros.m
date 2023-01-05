function [bancoFiltros] = generarBancoFiltros (Fs, longTrama)
    bancoFiltros = designAuditoryFilterBank(Fs,"FFTLength",longTrama);
end