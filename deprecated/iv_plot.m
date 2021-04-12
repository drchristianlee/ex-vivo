clear;
[file, path] = uigetfile('*.mat');
cd(path);
load(file);

clearvars file path

vars = whos;
time = eval(vars(1, 1).name);

for num = 2:length(vars);
    if num == 2;
        data = eval((vars(2, 1).name));
    else
        data = vertcat(data, eval(vars(num, 1).name));
    end
end

figure

for plot_line = 1:size(data, 1);
    plot(data(plot_line, :));
    hold on
end

axis([0 30000 -0.12 0.06])
box off

%IV plot and calculation
if size(data, 1) == 11;
    current = [-500 -400 -300 -200 -100 0 100 200 300 400 500];
elseif size(data, 1) == 16;
    current = [-500 -400 -300 -200 -100 0 100 200 300 400 500 600 700 800 900 1000]
end

for trace = 1:size(data, 1);
    dv(1, trace) = data(trace, 10000) - data(trace, 2500);
end

% figure
% scatter(current, dv);
% line(current, dv);

input_resist = dv(1, 7) / (current(1, 7) * 10^-12)