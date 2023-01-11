function [row, col, num] = voiceInput(signal)
    
    addpath('./audioFiles/');
    
    % toma se señal y poner a 0 todas aquellas partes por debajo del umbral
    y = signal;
    umbral = 0.05 * max(abs(signal));
    pos = find(abs(signal) < umbral);
    y(pos) = 0;

    % diferencia de y
    arr = diff(y);
    
    % toma de puntos intermedios, para poder separar las señales
    f = 0;
    ini = [];
    fin = [];
    mods = abs(arr);
    inSignal = 0;
    for i=200:length(mods)
        if mods(i) > 0 && mean(mods(i-199:i) > 0.06) && inSignal == 0 % start of signal
            inSignal = 1;
            ini = [ini i];
        end

        if mods(i) == 0 && inSignal == 1 && f <= 2 && all(mods(i-199:i) == 0) % end of signal
            f = f + 1;
            inSignal = 0;
            fin = [fin i];
        end
    end
    
    % si la toma no es correcta notificamos del error seteando todos los
    % parametros de salida a 0
    if length(ini) ~= 3 && length(fin) ~= 3
        row = 0; col = 0; num = 0;
        return;
    end
    
    % aislamos la señales a traves de los punto de corte
    p1 = floor( (fin(1) + ini(2)) /2);
    p2 = floor( (fin(2) + ini(3)) /2);

    s1 = signal(1:p1);
    s2 = signal(p1:p2);
    s3 = signal(p2:end);

    % clasificamos las señales
    row = classifyAudio(s1);
    col = classifyAudio(s2);
    num = classifyAudio(s3);
end
