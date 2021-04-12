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
    if str2num(vars(step, 1).name(11:12)) == 10 && size(eval(vars(step, 1).name), 1) == 18000;
        for savestep = 1:11;
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

for plotnum = 1:size(data, 3)
    figure
    plot_holder = data(:, :, plotnum);
    for trace = 1:size(plot_holder, 2);
        plot(plot_holder{1, trace});
        hold on;
    end
    title([plotnum])
end

