function [plot_dat] = plot_function(variable, x_min, x_max, y_min, y_max)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
plot_dat = variable(1, 37000:44000);
figure
plot(plot_dat)
axis([x_min x_max y_min y_max])
end

