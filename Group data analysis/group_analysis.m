clear
close all

data = load_mat_files;

for step = 1:size(data, 2);
    Rin_holder(1, step) = data{1, step}.Rin;
    V_mem_holder(1, step) = data{1, step}.V_mem;
    threshold_holder(1, step) = mean(data{1, step}.threshold);
    amp_holder(1, step) = mean(data{1, step}.amp);
    width_holder(1, step) = mean(data{1, step}.width);
    ahp_holder(1, step) = mean(data{1, step}.ahp);
    threshold_interp_holder(1, step) = mean(data{1, step}.threshold_interp);
    amp_interp_holder(1, step) = mean(data{1, step}.amp_interp);
    width_interp(1, step) = mean(data{1, step}.width_interp);
    ahp_interp(1, step) = mean(data{1, step}.ahp_interp);
end

result.Rin = mean(Rin_holder, 2);
result.V_mem = mean(V_mem_holder, 2);
result.thresold = mean(threshold_holder, 2);
result.amp = mean(amp_holder, 2);
result.width = mean(width_holder, 2);

