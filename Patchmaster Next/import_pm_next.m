clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);

vars = whos;

cell = str2num(cell2mat(inputdlg('Please enter the cell you would like to plot data from')));
manipulation = str2num(cell2mat(inputdlg('Please enter the manipulation you would like to plot')));
NaNtrace = str2num(cell2mat(inputdlg('Please enter any sweeps to change to NaN or else leave empty')));

for findcell = 1:size(vars, 1);
    if str2num(vars(findcell, 1).name(7)) == cell && str2num(vars(findcell, 1).name(9)) == manipulation;
        holdstepper = findcell;
        for savetrace = 1:11;
            holder = eval(vars(holdstepper, 1).name);
            data(:, savetrace) = holder(:, 2);
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
        sorted_data(:, NaNtrace(1, correctval)) = NaN;
    end
else
end

figure

for plot_step = 1:size(sorted_data, 2)
    plot(sorted_data(:, plot_step));
    hold on
end

axis([0 8995 -0.15 0.060]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 280 210]);
set(gca,'FontSize',9);
set(gcf, 'renderer' , 'Painters');

%to save figure in high resolution format
% print -painters -depsc output.eps 