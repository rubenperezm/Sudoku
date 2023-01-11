function res = classifyAudio(signal)
    addpath('./audioFiles/');


    caracteristics = getC(signal);
    dataset = {};
    
    % cargar datos del dataset
    for i=1:10
        for j=1:10
            load(strcat('audioDataset/track', num2str(i-1), num2str(j-1)));
            subset(j,:) = signal;
        end
        dataset{i} = subset;
    end   
    
    % votacion
    W = zeros(1,10);
    for i=1:width(dataset) % set de grabaciones
        for j=1:10 % 0-9 del subconjunto i
            subset = dataset{i};
            signal2 = subset(j,:);
            caracteristics2 = getC(signal2);
            Error(j) = dtw(caracteristics2, caracteristics); % obtencion de error
        end
        [~,pos] = min(Error); % numero estimado
        % 0-9 pero pos es de 1-10
        W(pos) = W(pos) + 1; % añadir +1 al contador
    end
    [~,pos] = max(W); % estimacion
%     disp(['num: ', num2str(pos-1)]);
    
    res = pos-1;
end