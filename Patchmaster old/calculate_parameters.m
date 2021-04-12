clear;
close all
[path] = uigetdir;
cd(path);
file = dir('*.mat');
for load_stepper = 1:size(file, 1);
    load(file(load_stepper, 1).name);
end


base_val = mean(average_keeper(20000:30000, 1));
[max_val , max_index] = max(average_keeper(35000:45000, 1));
amplitude = max_val - base_val;
result = {pwd base_val, amplitude, max_index}
figure
plot(average_keeper(37000:44000))
hold all

%optional filter for data with action potentials
fs = 20000;
%fc = 25; orig
fc = 50;
[B, A] = butter(2,fc/(fs/2));

figure
for single_trace = 1: size(sorted_data, 2);
    plot(sorted_data(37000:44000, single_trace), 'y');
    hold all
end

average_filt = filtfilt(B, A, average_keeper(:, 1));
base_val_filt = mean(average_filt(20000:30000, 1));
[max_val_filt, max_index_filt] = max(average_filt(35000:45000, 1));
amplitude_filt = max_val_filt - base_val_filt;
result_filtered = {pwd base_val_filt, amplitude_filt, max_index_filt, 'filtered' , fc};
plot(average_filt(37000:44000, 1), 'b');

figure
plot(average_keeper(37000:44000));
hold all
plot(average_filt(37000:44000), 'r');



axis([0 7000 -0.1 -0.04])
set(gca, 'box', 'off')

save('result.mat' , 'result');
save('result_filtered.mat' , 'result_filtered');
