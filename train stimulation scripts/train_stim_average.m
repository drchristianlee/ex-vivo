% Use this script to prepare averages of train stim percentage data. Put per_keeper .mat
% files into a separate folder. These will have to be renamed manually when
% copy pasted to avoid overwriting. Then run this script on the folder
% containing the .mat files. 

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);
keepercol = 1;
for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    name = char(fieldnames(currkeeper));
    holder(f, :) = currkeeper.(name);
end

% figure
% 
% for plot_step = 1:size(holder, 1);
%     plot(holder(plot_step, :));
%     hold on
% end

%calculate grand mean and standard error

result(1, :) = colon(1, size(holder, 2)); %this defines the stimulation number
result(2, :) = mean(holder, 1);
result(3, :) = (std(holder, 1)) / sqrt(size(holder, 1));

%plot data using shadederrorbar function

% figure
% 
% shadedErrorBar(result(1, :), result(2, :), result(3, :), 'b', 0);


% axis([0 50 -50 150]) %this can be modified to make plot more attractive
% set(gca,'TickDir','out')
% set(gca, 'TickLength', [0.025 0.025]);
% set(gca, 'box', 'off')
% set(gcf,'position',[680 558 280 210]);
% set(gca,'FontSize',9);

file_name = folder(end-7 : end);
save([file_name '_holder'] , 'holder');
save([file_name] , 'result');