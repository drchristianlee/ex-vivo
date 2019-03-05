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
        if holder(sample, pulse) < 36.8;
            res(sample, stepper) = pulse;
            stepper = stepper + 1;
        else
        end
    end
end

res(res == 0)= 50;

file_name = path(end-8 : end-1);
save([file_name '_tau'] , 'res');

for cell = 1:size(holder, 1);
for stim = 1:50;
    if stim == 1;
        cumul(cell, 1) = holder(cell, 1);
    else
        cumul(cell, stim) = holder(cell, stim) + cumul(cell, stim -1);
    end
end
end

cumul_plot(1, :) = colon(1, 50);
cumul_plot(2, :) = nanmean(cumul, 1);
cumul_plot(3, :) = nanstd(cumul, 1) / (sqrt(size(cumul, 1)));

save([file_name 'cumul'] , 'cumul');
save([file_name 'cumul_plot'] , 'cumul_plot');
