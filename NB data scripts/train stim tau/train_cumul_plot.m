% use this script to plot cumulative normalized psp data

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    result_holder(1, f) = {currkeeper.cumul_plot};
end


for plotting = 1:size(result_holder, 2);
    plot_holder = cell2mat(result_holder(1, plotting));
    if plotting == 1;
        figure
        shadedErrorBar(plot_holder(1, :), plot_holder(2, :), plot_holder(3, :), 'b', 0);
    elseif plotting == 2;
        figure
        shadedErrorBar(plot_holder(1, :), plot_holder(2, :), plot_holder(3, :), 'm', 0);
    elseif plotting == 3;
        figure
        shadedErrorBar(plot_holder(1, :), plot_holder(2, :), plot_holder(3, :), 'k', 0);
    end
    axis([0 50 0 5000])
    set(gca,'TickDir','out')
    set(gca, 'TickLength', [0.025 0.025]);
    set(gca, 'box', 'off')
    %set(gcf,'position',[680 558 560 210]);
    set(gca,'FontSize',12);
    set(gcf, 'renderer' , 'Painters');
    
end

% for err_plotting = 1:size(result_holder, 2);
%     plot_holder = cell2mat(result_holder(1, err_plotting));
%     errorbar(plot_holder(2, :), plot_holder(3, :));
%     hold on
% end
% %this can be modified to make plot more attractive

