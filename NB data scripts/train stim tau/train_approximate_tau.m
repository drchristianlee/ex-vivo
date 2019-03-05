% Use this script to calculate the index (or pulse number) of where the psp
% amplitude falls below 36.8% which is approximately tau. Run this file and
% choose the _holder.mat file in the averages, then input-neuron
% combination type. For example, choose _holder in Z:\DATA\corticostriatal\NB whole cell data\2018\train stim analysis\averages\M1 to D1

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);

res(1:size(holder, 1), 1) = zeros;

for sample = 1:size(holder, 1);
    stepper = 1;
    for pulse = 1:size(holder, 2);
        if holder(sample, pulse) < 75;
            res(sample, stepper) = pulse;
            stepper = stepper + 1;
        else
        end
    end
end

res(res == 0)= 50;

file_name = path(end-8 : end-1);
save([file_name '_tau'] , 'res');