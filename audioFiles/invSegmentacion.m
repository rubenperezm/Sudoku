function [palabra] = invSegmentacion (tramasPalabra, despl)
   palabra = tramasPalabra(:,1);
   palabra = [palabra; reshape(tramasPalabra(end-despl+1:end, 2:end), [], 1)];
end