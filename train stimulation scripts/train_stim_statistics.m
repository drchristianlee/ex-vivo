% Use this script to prepare averages of train stim percentage data. Put *_holder .mat
% files into a separate folder. These will have to be renamed manually when
% copy pasted to avoid overwriting. Then run this script on the folder
% containing the .mat files. 

clear;
folder = uigetdir;
cd(folder);
filePattern = fullfile(folder, '*.mat');
matfiles = dir(filePattern);
count = length(matfiles);

for f = 1:count;
    B = matfiles(f, 1).name;
    currkeeper = load(B);
    result_holder(:, :, f) = {currkeeper.holder};
end

test_pulse = [0] %enter the pulse to be tested or set to 0 to use average

for stim_resp = 1:size(result_holder, 3);
    extractor = cell2mat(result_holder(:, :, stim_resp));
    for stepper = 1:size(extractor, 1);
        if test_pulse > 0;
            test_holder(stepper, stim_resp) = extractor(stepper, test_pulse);
        else
            test_holder(stepper, stim_resp) = nanmean(extractor(stepper, 5:14));
        end
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


 axis([0 4 0 200])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 200 410])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
