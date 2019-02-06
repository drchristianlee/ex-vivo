% Run this script and choose the traces_cell_* file to plot the individual
% traces with average overlaid. 

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);


NaNtrace = [];%enter any sweeps that should be changed to NaN values
filtered = 1; %set to 1 if data was filtered for analysis

if filtered == 1;
    sorted_data = sorted_data_unfilt;
else
end

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        sorted_data(:, NaNtrace(1, correctval)) = NaN;
    end
else
end

avg_trace = nanmean(sorted_data, 2);

figure

for plot_step = 1:size(sorted_data, 2)
    plot(sorted_data(:, plot_step), 'y');
    hold on
end

plot(avg_trace, 'k');

set(gcf, 'renderer' , 'Painters');
axis([35000 85000 -0.09 -0.04]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 560 210]);
set(gca,'FontSize',9);

%to save figure in high resolution format
% print -painters -depsc output.eps 