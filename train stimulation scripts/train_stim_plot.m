% Use this script to plot train stim percentage data. Put .mat
% files containing average of folder contents into a separate folder. These will have to be renamed manually when
% copy pasted to avoid overwriting. Then run this script on the folder
% containing the .mat files. 

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);
keepercol = 1;

figure
for f = 1:count;
    B = matfiles(f, 1).name;
    load(B);
    if f == 1;
        shadedErrorBar(result(1, :), result(2, :), result(3, :), 'b', 0);
    elseif f == 2;
        shadedErrorBar(result(1, :), result(2, :), result(3, :), 'm', 0);
    elseif f == 3;
        shadedErrorBar(result(1, :), result(2, :), result(3, :), 'k', 0);
    end
    hold on
end
axis([0 50 -50 200]) %this can be modified to make plot more attractive
set(gca,'TickDir','out')
set(gca, 'TickLength', [0.025 0.025]);
set(gca, 'box', 'off')
set(gcf,'position',[680 558 560 210]);
set(gca,'FontSize',9);
set(gcf, 'renderer' , 'Painters');

% figure
% for f = 1:count;
%     B = matfiles(f, 1).name;
%     load(B);
%     if f==1;
%         plot(result(2, :), 'b');
%     elseif f==2;
%         plot(result(2, :), 'm');
%     elseif f==3;
%         plot(result(2, :), 'k');
%     end
%     hold on
% end
% axis([0 50 -50 150]) %this can be modified to make plot more attractive
% set(gca,'TickDir','out')
% set(gca, 'TickLength', [0.025 0.025]);
% set(gca, 'box', 'off')
% set(gcf,'position',[680 558 280 210]);
% set(gca,'FontSize',9);
% set(gcf, 'renderer' , 'Painters');