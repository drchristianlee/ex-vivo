%this script is used to analyze data exported from Patchmaster

clear;
close all
[file, path] = uigetfile('*.mat');
cd(path);
load(file);
disp(path)
clearvars file path

vars = whos;

NaNtrace = []; %enter any sweeps that should be changed to NaN values

test = [];
sequence = 1;

for step = 1:size(vars, 1);
    test = str2num(vars(step, 1).name(11:12));
    if isempty(str2num(vars(step, 1).name(11:12))) == 0
    if str2num(vars(step, 1).name(11:12)) == 10 && size(eval(vars(step, 1).name), 1) == 120050;
        for savestep = 1:20;
            holder = eval(vars(step, 1).name);
            data(:, savestep, sequence) = {holder(:, 2)};
            step = step + 1;
        end
        sequence = sequence + 1;
    else
    end
    else
    end
end

data = cell2mat(data);

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

for calc = 1:size(data, 3);
    figure
    average_keeper(:, calc) = nanmean(data(:, :, calc), 2);
    plot(data(36000:52000, :, calc), 'y')
    hold on 
    plot(average_keeper(36000:52000, calc), 'k')
end


save('average_keeper' , 'average_keeper');
save('traces' , 'sorted_data')