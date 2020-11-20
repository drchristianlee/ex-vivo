clear;

data = load_mat_files;

results_by_neuron = [];

for step = 1:size(data, 2);
    results_by_neuron.Rin{1, step} = data{1, step}.Rin;
    results_by_neuron.V_mem{1, step} = data{1, step}.V_mem;
    results_by_neuron.thresh{1, step} = mean(data{1,step}.threshold, 2);
    results_by_neuron.amp{1, step} = mean(data{1,step}.amp, 2);
    results_by_neuron.width{1, step} = mean(data{1,step}.width,2);
    results_by_neuron.ahp{1, step} = mean(data{1,step}.ahp, 2);
    results_by_neuron.threshold_interp{1, step} = mean(data{1,step}.threshold_interp, 2);
    results_by_neuron.amp_interp{1, step} = mean(data{1,step}.amp_interp, 2);
    results_by_neuron.width_interp{1, step} = mean(data{1,step}.width_interp, 2);
end