function [row, col, num] = voiceInput(signal)
    
    addpath('./audioFiles/');
    
%     figure, plot(signal);
%     title('original');
%     envelope = imdilate(abs(signal), true(1500, 1));
%     quite = envelope < 0.05;
%     signal(quite) = [];
%     figure, plot(signal);
%     title('quite removed');



%     res = conv(signal, zeros(1,500));
%     figure, plot(res); 
    y = signal;
    umbral = 0.05 * max(abs(signal));
    pos = find(abs(signal) < umbral);
    y(pos) = 0;

 
%     figure, plot(y);
%     title('silent to 0');

    arr = diff(y);
%     figure, plot(1:length(arr), abs(arr));

    
    f = 0;
    ini = [];
    fin = [];
    mods = abs(arr);
    inSignal = 0;
    for i=200:length(mods)
        if mods(i) > 0 && mean(mods(i-200:i) > 0.06) && inSignal == 0 % inicio de señal
            inSignal = 1;
            ini = [ini i];
        end

        if mods(i) == 0 && inSignal == 1 && f <= 2 && all(mods(i-200:i) == 0) % fin de señal
            f = f + 1;
            inSignal = 0;
            fin = [fin i];
        end
    end

    if length(ini) ~= 3 && length(fin) ~= 3
        row = 0; col = 0; num = 0;
        return;
    end
    
    p1 = floor( (fin(1) + ini(2)) /2);
    p2 = floor( (fin(2) + ini(3)) /2);

    s1 = signal(1:p1);
    s2 = signal(p1:p2);
    s3 = signal(p2:end);

%     sound(s1, 8000, 16);
%     pause(1);
%     sound(s2, 8000, 16);
%     pause(1);
%     sound(s3, 8000, 16);

    row = classifyAudio(s1);
    col = classifyAudio(s2);
    num = classifyAudio(s3);
end
