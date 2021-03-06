% Make a variable named test_keeper and then copy/paste the amplitude data
% for a single comparison (from master spreadsheet) as column vectors. Save this variable
% as *.mat as appropriate. Then run this script, choosing the
% correct file name in the line indicated below. Also set test to paired or
% unpaired. 

clear;
close all
clc

test = 2; %enter 1 for paired test and 2 for unpaired test


folder = uigetdir;
cd(folder);
load('test_keeper.mat')

test_keeper(test_keeper == 0) = NaN;

barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;

figure
bar(barkeeper(1,:), 'b');
hold on;
errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');
hold on;

for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:2) , 'o', 'color' , 'green', 'MarkerFaceColor', 'green')
    hold on
end

 axis([0 3 0 7000])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 160 220])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 if test == 1;
 [h p ci stats] = ttest(test_keeper(:, 1), test_keeper(:, 2))
 disp('a paired test was used');
 else
     [h p ci stats] = ttest2(test_keeper(:, 1), test_keeper(:, 2))
     disp('an unpaired test was used');
 end