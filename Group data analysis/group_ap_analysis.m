clear;

data = load_mat_files;

results_by_neuron = [];

for validation_step = 1:size(data, 2);
    size_validation = size((data{1, validation_step}.peaks), 2);
     if (size((data{1,validation_step}.threshold), 2)~= size_validation) == 1;
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
    results_by_neuron.curr_amp{1, step} = data{1, step}.curr_amp;
    results_by_neuron.spikes_quant{1, step} = data{1, step}.spikes_quant;
end

for validation_step2 = 1:size(results_by_neuron.curr_amp, 2);
    if true == 1;
        true = isequal(results_by_neuron.curr_amp{1, 1:end});
        disp('Current pulse amplitudes validated');
    else
        disp('Current pulse mismatch');
    end
end

group_results.Rin(1,1) = mean(cell2mat(results_by_neuron.Rin), 2);
group_results.Rin(1,2) = (std(cell2mat(results_by_neuron.Rin), 0, 2))/(sqrt(size(data, 2)));
group_results.V_mem(1,1) = mean(cell2mat(results_by_neuron.V_mem), 2);
group_results.V_mem(1,2) = (std(cell2mat(results_by_neuron.V_mem), 0, 2))/(sqrt(size(data, 2)));
group_results.thresh(1,1) = mean(cell2mat(results_by_neuron.thresh), 2);
group_results.thresh(1,2) = (std(cell2mat(results_by_neuron.thresh), 0, 2))/(sqrt(size(data, 2)));
group_results.amp(1,1) = mean(cell2mat(results_by_neuron.amp), 2);
group_results.amp(1,2) = (std(cell2mat(results_by_neuron.amp), 0, 2))/(sqrt(size(data, 2)));
group_results.width(1,1) = mean(cell2mat(results_by_neuron.width), 2);
group_results.width(1,2) = (std(cell2mat(results_by_neuron.width), 0, 2))/(sqrt(size(data, 2)));
group_results.ahp(1,1) = mean(cell2mat(results_by_neuron.ahp), 2);
group_results.ahp(1,2) = (std(cell2mat(results_by_neuron.ahp), 0, 2))/(sqrt(size(data, 2)));
group_results.threshold_interp(1,1) = mean(cell2mat(results_by_neuron.threshold_interp), 2);
group_results.threshold_interp(1,2) = (std(cell2mat(results_by_neuron.threshold_interp), 0, 2))/(sqrt(size(data, 2)));
group_results.amp_interp(1,1) = mean(cell2mat(results_by_neuron.amp_interp), 2);
group_results.amp_interp(1,2) = (std(cell2mat(results_by_neuron.amp_interp), 0, 2))/(sqrt(size(data, 2)));
group_results.width_interp(1,1) = mean(cell2mat(results_by_neuron.width_interp), 2);
group_results.width_interp(1,2) = (std(cell2mat(results_by_neuron.width_interp), 0, 2))/(sqrt(size(data, 2)));
group_results.ahp_interp(1,1) = mean(cell2mat(results_by_neuron.ahp_interp), 2);
group_results.ahp_interp(1,2) = (std(cell2mat(results_by_neuron.ahp_interp), 0, 2))/(sqrt(size(data, 2)));
for accum = 1:size(data, 2);
    curr_accum(accum, :) = results_by_neuron.curr_amp{1, accum};
    spikes_accum(accum, :) = results_by_neuron.spikes_quant{1, accum};
end
group_results.curr = curr_accum(1, :);
group_results.spikes(1, :) = mean(spikes_accum, 1);
group_results.spikes(2, :) = (std(spikes_accum, 0, 1))/(sqrt(size(spikes_accum, 1)));

figure
shadedErrorBar(group_results.curr,group_results.spikes(1, :),group_results.spikes(2, :))

