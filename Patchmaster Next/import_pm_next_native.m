% This script uses HEKA_Patchmaster_Importer to import data. As of January
% 27, 2020, the solutions data do not match what was used, so ignore these
% data until fixed. 

clear;
close all


vars = whos;

cell = str2num(cell2mat(inputdlg('Please enter the cell you would like to plot data from')));
manipulation = str2num(cell2mat(inputdlg('Please enter the manipulation you would like to plot')));
NaNtrace = str2num(cell2mat(inputdlg('Please enter any sweeps to change to NaN or else leave empty')));

for findcell = 1:size(vars, 1);
    if str2num(vars(findcell, 1).name(7)) == cell && str2num(vars(findcell, 1).name(9)) == manipulation;
        holdstepper = findcell;
        for savetrace = 1:11;
            holder = eval(vars(holdstepper, 1).name);
            data(:, savetrace) = {holder}; %was holder(:, 2);
            holdstepper = holdstepper + 1;
        end
        break
    else
    end
end

sorted_data = data(:, 3:11);
sorted_data = [sorted_data data(:, 1:2)];

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        sorted_data{1, NaNtrace(1, correctval)}(:, 2) = NaN;
    end
else
end

figure

for plot_step = 1:size(sorted_data, 2)
    plot(sorted_data{1,plot_step}(:,1) , sorted_data{1,plot_step}(:,2));
    hold on
end

axis([0 1 -0.15 0.075]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 280 210]);
set(gca,'FontSize',9);
set(gcf, 'renderer' , 'Painters');

%to save figure in high resolution format
% print -painters -depsc output.eps 