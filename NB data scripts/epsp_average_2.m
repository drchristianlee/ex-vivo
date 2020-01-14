%this script is used to analyze data exported from Patchmaster.
%this file version allows for choosing the specific cell and
%manipulation to analyze. 

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);
mkdir(file(1:end-4))
newdir = file(1:end-4);
cd(newdir);
clear file path newdir

vars = whos;

cell = 1;
manipulation = 3;
NaNtrace = [3 10 16]; %enter any sweeps that should be changed to NaN values


for findcell = 1:size(vars, 1);
    if str2num(vars(findcell, 1).name(7)) == cell && str2num(vars(findcell, 1).name(9)) == manipulation;
        holdstepper = findcell;
        for savetrace = 1:20;
            holder = eval(vars(holdstepper, 1).name);
            data(:, savetrace) = holder(:, 2);
            holdstepper = holdstepper + 1;
        end
        break
    else
    end
end


sorted_data(:, 1) = data(:, 11);
sorted_data = [sorted_data data(:, 13:20)];
sorted_data = [sorted_data data(:, 1:10)];
sorted_data = [sorted_data data(:, 12)];

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        sorted_data(:, NaNtrace(1, correctval)) = NaN;
    end
else
end

average_keeper = nanmean(sorted_data, 2);

figure

for plotstepper = 1:size(sorted_data, 2);
    plot(sorted_data(39500:42500, plotstepper), 'y');
    hold on
end
plot(average_keeper(39500:42500, 1), 'k');

axis([0 3000 -0.085 -0.020]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 280 210]);
set(gca,'FontSize',9);
set(gcf, 'renderer' , 'Painters');
saveas(gcf , ['results_plot_' num2str(cell) '.fig']);

% for tracestepper = 1:size(sorted_data, 2);
%     figure
%     plot(sorted_data(39500:42500, tracestepper), 'k');
%     title(['plot ' num2str(tracestepper)]);
% end

mkdir(num2str(cell))
savedir = num2str(cell);
cd(savedir);

save(['average_keeper_cell_' num2str(cell)] , 'average_keeper');
save(['traces_cell_' num2str(cell)] , 'sorted_data')
if isempty(NaNtrace) == 0;
    save('NaNtrace.mat' , 'NaNtrace');
end
save('manipulation.mat' , 'manipulation')