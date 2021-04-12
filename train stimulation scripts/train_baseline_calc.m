% Use to plot baseline from sorted_data file. Load sorted_data by dragging
% to command window and run this script to get the baseline_avg. 

sorted_data_avg = nanmean(sorted_data, 2);
baseline_avg = mean(sorted_data_avg(10000:30000));