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

average = nanmean(data, 1);

figure
plot(average)

base_val = mean(average(1, 20000:30000));
[max_val , max_index] = max(average(1, 35000:45000));
amplitude = max_val - base_val;
result = {pwd, base_val, amplitude, max_index}

%optional filter data
fs = 20000;
fc = 100;
[B, A] = butter(4,fc/(fs/2));
average_filt = filtfilt(B, A, average);
base_val_filt = mean(average_filt(1, 20000:30000));
[max_val_filt, max_index_filt] = max(average_filt(1, 35000:45000));
amplitude_filt = max_val_filt - base_val_filt;
figure
plot(average)
hold all
plot(average_filt)
figure
plot(average_filt)
result_filtered = {pwd, base_val_filt, amplitude_filt, max_index_filt}