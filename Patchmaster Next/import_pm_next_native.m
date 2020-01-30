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
HEKA_Importer.GUI

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
        sorted_data{1, NaNtrace(1, correctval)}(:, 2) = NaN;
    end
else
end

for sweep = 1:size(ans.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
    subplot(2,1,1);
    plot(time_vector , ans.RecTable.dataRaw{manipulation, 1}{1,1}(:, sweep));
    hold on
    subplot(2,1,2);
    plot(time_vector , ans.RecTable.stimWave{manipulation, 1}.DA_3(:, sweep));
    hold on
    axis([0 900 -2 2])
end



% axis([0 1 -0.15 0.075]) %this can be modified to make plot more attractive
% set(gca,'TickDir','out')
% set(gca, 'TickLength', [0.025 0.025]);
% set(gca, 'box', 'off')
% set(gcf,'position',[680 558 280 210]);
% set(gca,'FontSize',9);
% set(gcf, 'renderer' , 'Painters');

%to save figure in high resolution format
% print -painters -depsc output.eps 