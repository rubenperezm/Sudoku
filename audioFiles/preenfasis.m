function [signal] = preenfasis(inputSignal, a)
    signal = filter([1 -a], 1, inputSignal);    
% signal = inputSignal - a*[0 inputSignal(1:end-1)]; 

%%% lo de arriba es equivalente a esto
%     y_deps2(1) = y(1);
%     for i=2:length(y)
%         y_desp2(i) = y(i) - a*y(i-1);
%     end
end

