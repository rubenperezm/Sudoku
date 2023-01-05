function [caracteristics] = getC(senal)

Fs = 8000;
tiempoTrama = 0.03;
tiempoDesplTrama = 0.01;
a = 0.95;

ventana = 'rectangular';
numTramasRuido = 10;
longTrama = round(Fs * tiempoTrama);
longDespTrama = round (Fs * tiempoDesplTrama);
longVentanaDelta = 5; %Nº de tramas utilizadas para calcular los coeficientes delta y delta-delta
numCepstrum = 12;

% Creación del banco de filtros de Mel
bancoFiltrosMel = generarBancoFiltros(Fs,longTrama);
% preenfasis
senal = preenfasis(senal, a);
% Extracción de características en el dominio del tiempo
tramas = segmentacion(senal,longTrama, longDespTrama);
[tramasPalabra, inicio, fin] = inicioFinv2 (tramas, numTramasRuido, ventana);
palabra = invSegmentacion (tramas(:,inicio:fin), longDespTrama);

% figure, subplot(1,2,1), plot(senal);
% subplot(1,2,2),plot(palabra);

% obj_senal = audioplayer(palabra,Fs);

% play(obj_senal);
% pause (2);

% Obtención de los coeficientes cepstrales en la escala de Mel
coefMel = MFCC (tramasPalabra,bancoFiltrosMel);

% Liftering
coefMel = liftering (coefMel, numCepstrum);

% Obtención de los coeficientes delta cepstrum
deltaCoefMel = MCCDelta (coefMel,longVentanaDelta);

% Obtención de los coeficientes delta-delta cepstrum
deltaDeltaCoefMel = MCCDelta (deltaCoefMel,longVentanaDelta);
% Obtención del logaritmo de la Energía de cada trama
energia = logEnergia(tramasPalabra);

% Crear vectores de características
caracteristics = [energia; coefMel'; deltaCoefMel'; deltaDeltaCoefMel'];

% Normalización de los coeficientes cepstrales
% VCN = normalizacion(caracteristicas);
% car4 = VCN';

end