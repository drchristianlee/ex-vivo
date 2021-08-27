% Make a variable named test_keeper and then copy/paste the results to be
% analyzed as column vectors. Save this variable as a mat file.  Then run
% this script choosing that file. 

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);

test_keeper(test_keeper == 0) = NaN;

test_keeper = test_keeper * 1000;

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


 %axis([0 4 0 50])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 200 410])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 [ranovatbl,A,C,D] = ranovatbl(test_keeper);
 
 
 [h,p,ci,stats] = ttest(test_keeper(:, 1), test_keeper(:, 2));
 