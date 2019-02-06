clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);

vars = whos;

cell = 1;
manipulation = 1;

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

NaNtrace = [1 2 4 5 6 7 8 10 11]; %enter any sweeps that should be changed to NaN values

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

axis([2000 20000 -0.15 0.060]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 280 210]);
set(gca,'FontSize',9);
set(gcf, 'renderer' , 'Painters');

%to save figure in high resolution format
% print -painters -depsc output.eps 