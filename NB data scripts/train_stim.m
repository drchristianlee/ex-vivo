% Use this script to plot train stimulation data and save results

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);
mkdir(file(1:end-4))
newdir = file(1:end-4);
cd(newdir);
prefix = file(1:6);
clear file path newdir

vars = whos;

cell = 3;
manipulation = 3;
NaNtrace = []; %enter any sweeps that should be changed to NaN values
filter = 0; %0 for no filter, 1 for filter. Use filter if action potentials are present and can't be changed to NaN
fc = 30; 
first_filt = 0; %0 to use unfiltered data for first pulse 1 to use filtered
use_filt = 0; %set to 1 to use all filtered data in amp check

for findcell = 1:size(vars, 1);
    if str2num(vars(findcell, 1).name(7)) == cell && str2num(vars(findcell, 1).name(9)) == manipulation;
        holdstepper = findcell;
        for savetrace = 1:5;
            holder = eval(vars(holdstepper, 1).name);
            data(:, savetrace) = holder(:, 2);
            holdstepper = holdstepper + 1;
        end
        break
    else
    end
end

sorted_data = data;

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        sorted_data(:, NaNtrace(1, correctval)) = NaN;
    end
else
end

figure

for plot_step = 1:size(sorted_data, 2)
    plot(sorted_data(20000:end, plot_step));
    hold on
    axis([0 100000 -0.08 0.04]);
    %axis([16000 26000 -0.06 -0.03]);
end


%analysis on averaged data with and without filtering
sorted_data_avg = nanmean(sorted_data, 2);
baseline_avg = mean(sorted_data_avg(10000:30000));
quant_start = 40000;
for stim_num_avg = 1:50;
    max_peak_keeper_avg(1, stim_num_avg) = max(sorted_data_avg(quant_start:quant_start + 800, 1));
    quant_start = quant_start + 800;
end
if filter == 1;
    fs = 20000;
    [B, A] = butter(4,fc/(fs/2));
    sorted_data_avg_filt = filtfilt(B, A, sorted_data_avg);
    baseline_avg_filt = mean(sorted_data_avg_filt(10000:30000));
    quant_start_filt = 40000;
    for stim_num_avg_filt = 1:50;
        max_peak_keeper_avg_filt(1, stim_num_avg_filt) = max(sorted_data_avg_filt(quant_start_filt:quant_start_filt + 800, 1));
        quant_start_filt = quant_start_filt + 800;
    end
end

diff_peak_keeper_avg = max_peak_keeper_avg - baseline_avg;

if filter == 1;
    diff_peak_keeper_avg_filt = max_peak_keeper_avg_filt - baseline_avg_filt;
else
end

if use_filt == 1;
    amp_keeper = diff_peak_keeper_avg_filt;
else
    for amp_check = 1:50;
        if amp_check == 1;
            if first_filt == 1;
                amp_keeper(1, 1) = diff_peak_keeper_avg_filt(1,1);
            else
                amp_keeper(1, 1) = diff_peak_keeper_avg(1,1);
            end
        else
            if filter == 0 || diff_peak_keeper_avg(1, amp_check)  < (1.5 * (amp_keeper(1, amp_check - 1)));
                amp_keeper(1, amp_check) = diff_peak_keeper_avg(1, amp_check);
            else
                amp_keeper(1, amp_check) = (diff_peak_keeper_avg_filt(1, amp_check));
            end
        end
    end
end

perc_keeper = (amp_keeper / amp_keeper(1,1)) * 100;

figure
plot(perc_keeper)

figure
plot(sorted_data_avg(20000:end));
hold on
if filter == 1;
    plot(sorted_data_avg_filt(20000:end));
else
end

mkdir(num2str(cell))
cd(num2str(cell))
mkdir(num2str(manipulation))
savedir = num2str(manipulation);
cd(savedir);

% save(['average_keeper_cell_' num2str(cell)] , 'average_keeper');
save(['traces_cell_' num2str(cell)] , 'sorted_data')

if isempty(NaNtrace) == 0;
    save('NaNtrace.mat' , 'NaNtrace')
end

if filter == 1;
    save('filter.mat' , 'filter')
    save('fc.mat' , 'fc')
end

save('manipulation.mat' , 'manipulation')
% save('perc_keeper.mat', 'perc_keeper')
save([prefix '_perc_keeper_cell' num2str(cell) '.mat'] , 'perc_keeper');