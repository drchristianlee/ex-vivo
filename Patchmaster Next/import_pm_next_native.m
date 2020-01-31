% To run this script have the folder containing this script as well as
% HEKA_Patchmaster_Importer in the path.

% This script uses HEKA_Patchmaster_Importer to import data. As of January
% 27, 2020, the solutions data do not match what was used, so ignore these
% data until fixed. 

clear;
close all

cell = str2num(cell2mat(inputdlg('Please enter the cell you would like to plot data from')));
manipulation = str2num(cell2mat(inputdlg('Please enter the manipulation you would like to plot')));
NaNtrace = str2num(cell2mat(inputdlg('Please enter any sweeps to change to NaN or else leave empty')));

HEKA_Importer.GUI %runs importer

for protocols = 1:size(ans.RecTable, 1);
    if ans.RecTable{protocols, 1} == cell;
        break
    else
    end
    
end

manipulation = (manipulation - 1) + protocols;

time_vector = 0:0.05:899.995; %hard coded at the present

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        ans.RecTable.dataRaw{manipulation, 1}{1,1}(1:end, NaNtrace(1,correctval)) = NaN;
    end
else
end

for sweep = 1:size(ans.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
    ax1 = subplot(2,1,1);
    plot(time_vector , ans.RecTable.dataRaw{manipulation, 1}{1,1}(:, sweep));
    hold on
    axis tight
    ax2 = subplot(2,1,2);
    plot(time_vector , ans.RecTable.stimWave{manipulation, 1}.DA_3(:, sweep));
    hold on
    axis([0 900 -2 2])
end

[pks, locs, w, p] = findpeaks(ans.RecTable.dataRaw{10,1}{1,1}(:,10), 'MinPeakHeight' , 0); %hard coded for dev purposes also try integrating sampling rate
figure
plot(ans.RecTable.dataRaw{10,1}{1,1}(:,10))
hold on
plot(locs, pks, 'o');

set(ax1,'TickDir','out')
set(ax2,'TickDir','out')
set(ax1, 'TickLength', [0.025 0.025]);
set(ax2, 'TickLength', [0.025 0.025]);
set(ax1, 'box', 'off')
set(ax2, 'box', 'off')
set(gcf,'position',[1100 470 310 410]);
set(ax1,'FontSize',9);
set(ax2,'FontSize',9);
% set(gcf, 'renderer' , 'Painters');

%to save figure in high resolution format
% print -painters -depsc output.eps 