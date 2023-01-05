function coefMel = liftering (coefMel, numCepstrum)
    coefMel = coefMel(:, 3:numCepstrum+2);
end