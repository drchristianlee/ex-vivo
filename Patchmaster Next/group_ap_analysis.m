clear;

data = load_mat_files;

results_by_neuron = [];

for validation_step = 1:size(data, 2);
    size_validation = size((data{1, validation_step}.peaks), 2);
     if (size((data{1,validation_step}.threshold), 2)~= size_validation) == 0;
        disp('There is a size mismatch in threshold. Validate data')
     elseif (size((data{1,validation_step}.amp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in amp. Validate data')
     elseif (size((data{1,validation_step}.width), 2)~= size_validation) == 1;
        disp('There is a size mismatch in width. Validate data')
     elseif (size((data{1,validation_step}.ahp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in ahp. Validate data')
     elseif (size((data{1,validation_step}.threshold_interp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in threshold_interp. Validate data')
     elseif (size((data{1,validation_step}.amp_interp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in amp_interp. Validate data')
     elseif (size((data{1,validation_step}.width_interp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in width_interp. Validate data')
     elseif (size((data{1,validation_step}.ahp_interp), 2)~= size_validation) == 1;
        disp('There is a size mismatch in ahp_interp. Validate data')
     else
        disp('Validation complete')
     end
    end

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
    results_by_neuron.ahp_interp{1, step} = mean(data{1,step}.ahp_interp, 2);
end

group_results.Rin = mean(cell2mat(results_by_neuron.Rin), 2);
group_results.V_mem = mean(cell2mat(results_by_neuron.V_mem), 2);
group_results.thresh = mean(cell2mat(results_by_neuron.thresh), 2);
group_results.amp = mean(cell2mat(results_by_neuron.amp), 2);
group_results.width = mean(cell2mat(results_by_neuron.width), 2);
group_results.ahp = mean(cell2mat(results_by_neuron.ahp), 2);
group_results.threshold_interp = mean(cell2mat(results_by_neuron.threshold_interp), 2);
group_results.amp_interp = mean(cell2mat(results_by_neuron.amp_interp), 2);
group_results.width_interp = mean(cell2mat(results_by_neuron.width_interp), 2);
group_results.ahp_interp = mean(cell2mat(results_by_neuron.ahp_interp), 2);