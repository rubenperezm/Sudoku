close all; clear all; clc;

Fs = 8000;
ch = 1;
nBits = 16;
time = 1;

fid = fopen('./audioDataset/data.txt', 'r');
number = fscanf(fid, '%d');
fclose(fid);

for i=1:1
    recObj = audiorecorder(Fs, nBits, ch);
    disp('Start speaking');
    recordblocking(recObj, time);
    disp('End of recording');
    
    signal = getaudiodata(recObj);
  
    filenameAud = strcat("./audioDataset/track", num2str(number), num2str(i-1), ".wav");
    filename = strcat("./audioDataset/track", num2str(number), num2str(i-1), ".mat");
    audiowrite(filenameAud, signal, Fs);   
    save(filename, 'signal');

    number = number + 1;
end

disp('Tanda terminada... espera 2s');
fid = fopen('./audioDataset/data.txt', 'w');
fprintf(fid, '%d', number);
fclose(fid);
