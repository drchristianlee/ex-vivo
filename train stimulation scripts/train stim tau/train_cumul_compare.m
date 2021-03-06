% use this script to compare the final cumulative psp value 

clear;
close all
clc

folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    result_holder(1, f) = {currkeeper.cumul};
end

for grouper = 1:size(result_holder, 2);
    extractor = result_holder{1, grouper}(:, end);
    for stepper = 1:size(extractor, 1);
    test_keeper(stepper, grouper) = extractor(stepper, 1);
    end
end

test_keeper(test_keeper == 0) = NaN;


barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
barkeeper(1,3) = nanmean(test_keeper(:, 3));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
denominator3 = sqrt((size(test_keeper(:, 3), 1)) - nanvals(1, 3));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;
barkeeper(2,3) = nanstd(test_keeper(:,3))/denominator3;

figure
bar(barkeeper(1,:), 'b');
hold on;


for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:3) , 'o', 'color' , 'green' , 'MarkerFaceColor', 'green')
    hold on
end

errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');


 axis([0 4 0 7000])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 200 410])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 [p tbl stats] = anova1(test_keeper);
 
 %now complete multiple comparison tests
 [c,m] = multcompare(stats,'CType','bonferroni')