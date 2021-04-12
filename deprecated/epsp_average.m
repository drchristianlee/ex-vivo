clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);
disp(path)
clearvars file path

vars = whos;
time = eval(vars(1, 1).name);

for num = 2:length(vars);
    if num == 2;
        data = eval((vars(2, 1).name));
    else
        data = vertcat(data, eval(vars(num, 1).name));
    end
end

use_filt = 1; %enter 0 to use unfiltered data or 1 to used filtered data for plot
NaNtrace = []; %enter any sweeps that should be changed to NaN values

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        data(NaNtrace(1, correctval), :) = NaN;
    end
else
end

average = nanmean(data, 1);

if use_filt == 0;
    figure
    for trials = 1:size(data, 1);
        plot(data(trials, 37000:44000) , 'y');
        hold all
    end
    plot(average(1, 37000:44000) , 'b')
    
    axis([0 7000 -0.1 -0.04])
    set(gca, 'box', 'off')
else
end

base_val = mean(average(1, 20000:30000));
[max_val , max_index] = max(average(1, 35000:45000));
amplitude = max_val - base_val;
result = {pwd, base_val, amplitude, max_index}

%optional filter data
fs = 20000;
fc = 50;
[B, A] = butter(2,fc/(fs/2));
average_filt = filtfilt(B, A, average);
base_val_filt = mean(average_filt(1, 20000:30000));
[max_val_filt, max_index_filt] = max(average_filt(1, 35000:45000));
amplitude_filt = max_val_filt - base_val_filt;

if use_filt == 1;
    figure
    plot(average)
    hold all
    plot(average_filt)
    figure
    for trials = 1:size(data, 1);
        plot(data(trials, 37000:44000) , 'y');
        hold all
    end
    plot(average_filt(1, 37000:44000), 'b')
    
    axis([0 7000 -0.1 -0.04])
    set(gca, 'box', 'off')
else
end

result_filtered = {pwd, base_val_filt, amplitude_filt, max_index_filt, 'filtered' , fc}