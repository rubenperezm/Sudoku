function res = classifyAudio(signal)
    addpath('./audioFiles/');


    caracteristics = getC(signal);
    dataset = {};

    for i=1:10
        for j=1:10
            load(strcat('audioDataset/track', num2str(i-1), num2str(j-1)));
            subset(j,:) = signal;
        end
        dataset{i} = subset;
    end

%     db = cell2mat(dataset);
%     save('audioDB', 'db');    
    
    W = zeros(1,10);
    for i=1:width(dataset) % set of recordings
        for j=1:10 % 0-9 of the i-subset
            subset = dataset{i};
            signal2 = subset(j,:);
            caracteristics2 = getC(signal2);
            Error(j) = dtw(caracteristics2, caracteristics);
        end
        [~,pos] = min(Error); % selected number
        % remember that if the pos is 1,
        % the number is 0, and not 1
        W(pos) = W(pos) + 1;
    end
    [~,pos] = max(W);
    disp(['num: ', num2str(pos-1)]);
    
    res = pos-1;
end