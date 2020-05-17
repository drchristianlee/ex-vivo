% Run this script and choose the traces_cell_* file to plot the individual
% traces with average overlaid. 

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);


NaNtrace = [];%enter any sweeps that should be changed to NaN values
filtered = 0; %set to 1 if data was filtered for analysis

zoom = str2num(cell2mat(inputdlg('Use zoom view? 1 for yes 0 for no')));

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

if zoom == 1;
    axis([39500 42500 -0.09 -0.04]);
else
    axis([35000 85000 -0.09 -0.04]);
end

set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')

if zoom == 1;
    set(gcf, 'position', [680 558 210 210]);
else
    set(gcf, 'position',[680 558 560 210]);
end
    
set(gca,'FontSize',9);

%to save figure in high resolution format
% print -painters -depsc output.eps 