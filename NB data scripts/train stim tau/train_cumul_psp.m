% use this script to analyze cumulative normalized psp data

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    result_holder(f, :) = currkeeper.cumul;
end


for plot_step = 1:size(result_holder, 1);
    plot(result_holder(plot_step, :));
    hold on;
end

