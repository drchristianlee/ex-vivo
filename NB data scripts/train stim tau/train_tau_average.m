% Use this script to create the average tau. Put the _tau files into a
% separate directory and run this file to calculate average and carry out
% statistics. 

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    result_holder(:, :, f) = {currkeeper.res};
end

for extract = 1:size(result_holder, 3);
    res_holder = cell2mat(result_holder(:, 1, extract));
    for step = 1:size(res_holder, 1);
        test_holder(step, extract) = res_holder(1, step);
    end
end

test_holder(test_holder == 0) = NaN

[p, tbl, stats] = anova1(test_holder)
figure
[c,m] = multcompare(stats,'CType','bonferroni')

barkeeper(1,1) = nanmean(test_holder(:,1));
barkeeper(1,2) = nanmean(test_holder(:, 2));
barkeeper(1,3) = nanmean(test_holder(:, 3));
nanfinder = isnan(test_holder);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_holder(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_holder(:, 2), 1)) - nanvals(1, 2));
denominator3 = sqrt((size(test_holder(:, 3), 1)) - nanvals(1, 3));
barkeeper(2,1) = nanstd(test_holder(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_holder(:,2))/denominator2;
barkeeper(2,3) = nanstd(test_holder(:,3))/denominator3;

figure
bar(barkeeper(1,:), 'b');
hold on;


for points = 1:size(test_holder, 1);
    plot(test_holder(points, 1:3) , 'o', 'color' , 'green' , 'MarkerFaceColor', 'green')
    hold on
end

errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');


 axis([0 4 0 60])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 200 410])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
