function [res] = segmentacion(signal, numSamples, offset)
    res = buffer(signal, numSamples, numSamples-offset, 'nodelay');
end 
