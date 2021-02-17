% To run this script have the folder containing this script as well as
% HEKA_Patchmaster_Importer in the path.

% This script uses HEKA_Patchmaster_Importer to import data. As of January
% 27, 2020, the solutions data do not match what was used, so ignore these
% data until fixed. 

clear;
close all

analyze = str2num(cell2mat(inputdlg('AP analysis (1) or PSP analysis (2)')));
cell = str2num(cell2mat(inputdlg('Please enter the cell you would like to plot data from')));
manipulation = str2num(cell2mat(inputdlg('Please enter the manipulation you would like to plot')));
if analyze == 1;
meas_sweep = str2num(cell2mat(inputdlg('Please enter the sweep for action potential analysis; start with 10 and work backward')));
else
end
NaNtrace = str2num(cell2mat(inputdlg('Please enter any sweeps to change to NaN or else leave empty')));
sav_result = str2num(cell2mat(inputdlg('Save data? 1 for yes')))

data = HEKA_Importer.GUI %runs importer


[filepath] = fileparts(data.opt.filepath)
cd(filepath)

if sav_result == 1;
    file_nm = [data.opt.filepath(end-17 : end-8) , '_cell_' , num2str(cell(1,1)) , '_manipulation_' , num2str(manipulation) , '_results.mat']
    result.filename = file_nm;
else
end

for protocols = 1:size(data.RecTable, 1);
    if data.RecTable{protocols, 1} == cell;
        break
    else
    end
end

manipulation = (manipulation - 1) + protocols;


if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        data.RecTable.dataRaw{manipulation, 1}{1,1}(1:end, NaNtrace(1,correctval)) = NaN;
    end
else
end

if analyze == 1;
    time_vector = 0:0.05:899.995; %hard coded at the present
    
    for sweep = 1:size(data.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
        ax1 = subplot(2,1,1);
        plot(time_vector , data.RecTable.dataRaw{manipulation, 1}{1,1}(:, sweep));
        hold on
        axis tight
        ax2 = subplot(2,1,2);
        plot(time_vector , data.RecTable.stimWave{manipulation, 1}.DA_3(:, sweep));
        hold on
        axis([0 900 -2 2])
    end
    
    %code to find resting membrane potential
    Vtrace = data.RecTable.dataRaw{manipulation, 1}{1,1}(1000:2999, :);
    V_avg = mean(Vtrace, 1);
    V_mem = mean(V_avg, 2) * 1000;
    
    %code to find and plot input resistance and plot IV curve
    for iv_step = 1:size(data.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
        I(iv_step, 1) = data.RecTable.stimWave{manipulation, 1}.DA_3(6000, iv_step);
        V(iv_step, 1) = data.RecTable.dataRaw{manipulation, 1}{1,1}(6000, iv_step);
    end
    
    figure
    plot(I, V)
    
    %now compute input resistance from the smallest hyperpolarizing step
    Vir = (data.RecTable.dataRaw{manipulation, 1}{1,1}(6000, 5) - data.RecTable.dataRaw{manipulation, 1}{1,1}(2000, 5)); %voltage change from 100 ms into sweep to 100 ms after pulse
    Iir = (data.RecTable.stimWave{manipulation, 1}.DA_3(6000, 5) - data.RecTable.stimWave{manipulation, 1}.DA_3(2000, 5)) / 1000000000; %corrects bug where current is scaled incorrectly
    Rin = (Vir/Iir) / 1000000; %gives output in megaohms
    
    %compute action potential parameters
    [pks, locs, w, p] = findpeaks(data.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep), 'MinPeakHeight' , 0, 'MinPeakDistance', 5);
    figure
    plot(data.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep))
    hold on
    plot(locs, pks, 'o');
    slope = diff(data.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep));
    result.peaks =((1/data.RecTable.SR(manipulation)) * locs)';
    
    for spike = 1:size(locs, 1);
        max_rise_slope = max(slope(locs(spike, 1) - 50: locs(spike, 1) + 50));
        perc_max = max_rise_slope * 0.15;
        for thresh_idx = locs(spike, 1) - 50: locs(spike, 1) + 50;
            if slope(thresh_idx, 1) > perc_max;
                break
            else
            end
        end
        threshold(1, spike) = data.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx,meas_sweep);
        peak = max(data.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx:thresh_idx + 50,meas_sweep));
        amp(1, spike) = peak - threshold(1, spike);
        half_amp = ((peak - threshold(1, spike))/2) + threshold(1, spike);
        idx_1 = find(data.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx:thresh_idx + 50, meas_sweep) > half_amp);
        half_width(1, spike) = (1/data.RecTable.SR(manipulation)) * size(idx_1, 1);
        ahp(1, spike) = threshold(1, spike) - (min(data.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx:thresh_idx + 100, meas_sweep))); %might need to modify for spikes near end of pulse
    end
    
    %now calculate action potential parameters using the interpolated trace
    trace_interp = interp(data.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep), 5); %increase sample rate by 5
    [pks, locs, w, p] = findpeaks(trace_interp, 'MinPeakHeight' , 0, 'MinPeakDistance', 25);
    figure
    plot(trace_interp)
    hold on
    plot(locs, pks, 'o');
    slope = diff(trace_interp);
    result.peaks_interp =((1/(data.RecTable.SR(manipulation)* 5)) * locs)';
    
    for spike = 1:size(locs, 1);
        max_rise_slope = max(slope(locs(spike, 1) - 250: locs(spike, 1) + 250));
        perc_max = max_rise_slope * 0.15;
        for thresh_idx = locs(spike, 1) - 250: locs(spike, 1) + 250
            if slope(thresh_idx, 1) > perc_max;
                break
            else
            end
        end
        threshold_interp(1, spike) = trace_interp(thresh_idx, 1);
        peak_interp = max(trace_interp(thresh_idx:thresh_idx + 250, 1));
        amp_interp(1, spike) = peak_interp - threshold_interp(1, spike);
        half_amp = ((peak_interp - threshold_interp(1, spike))/2) + threshold_interp(1,spike);
        idx_1 = find(trace_interp(thresh_idx:thresh_idx + 250, 1) > half_amp);
        half_width_interp(1, spike) = (1/(data.RecTable.SR(manipulation)*5)) * size(idx_1, 1);
        ahp_interp(1, spike) = threshold_interp(1, spike) - (min(trace_interp(thresh_idx:thresh_idx + 500, 1))); %might need to modify for spikes near end of pulse
        [ahp_hold, I] = min(trace_interp(thresh_idx:thresh_idx + 500, 1));
        ahp_ind = thresh_idx + I;
        dV{1, spike} = slope(thresh_idx:ahp_ind, 1);
        Vm{1, spike} = trace_interp(thresh_idx:ahp_ind, 1);
    end
    
    %quantify the number of spikes for each depolarizing current pulse
    
    counter = 1;
    for quant_sweep = 7:size(data.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
        finder = data.RecTable.dataRaw{manipulation,1}{1,1}(:, quant_sweep) > 0;
        decision = sum(finder);
        if decision > 0;
            [pks, locs, w, p] = findpeaks(data.RecTable.dataRaw{manipulation,1}{1,1}(:, quant_sweep), 'MinPeakHeight' , 0, 'MinPeakDistance', 5);
            spikes_quant(1, counter) = size(pks, 1);
            curr_amp(1, counter) = max(data.RecTable.stimWave{manipulation, 1}.DA_3(:, quant_sweep));
            counter = counter + 1;
        else
            spikes_quant(1, counter) = 0;
            curr_amp(1, counter) = max(data.RecTable.stimWave{manipulation, 1}.DA_3(:, quant_sweep));
            quant_sweep = quant_sweep + 1;
        end
    end
    
    figure
    plot(curr_amp, spikes_quant);
    
    
    result.Rin = Rin;
    result.V_mem = V_mem;
    result.threshold = threshold;
    result.amp = amp;
    result.width = half_width;
    result.ahp = ahp;
    result.curr = curr_amp
    result.sweep = meas_sweep;
    result.nan = NaNtrace;
    result.threshold_interp = threshold_interp;
    result.amp_interp = amp_interp;
    result.width_interp = half_width_interp;
    result.ahp_interp = ahp_interp;
    result.curr_amp = curr_amp;
    result.spikes_quant = spikes_quant;
    
    set(ax1,'TickDir','out')
    set(ax2,'TickDir','out')
    set(ax1, 'TickLength', [0.025 0.025]);
    set(ax2, 'TickLength', [0.025 0.025]);
    set(ax1, 'box', 'off')
    set(ax2, 'box', 'off')
    %set(gcf,'position',[1100 470 310 410]);
    set(ax1,'FontSize',9);
    set(ax2,'FontSize',9);
    % set(gcf, 'renderer' , 'Painters');
    
    %to save figure in high resolution format
    % print -painters -depsc output.eps
elseif analyze == 2;
    
    time_vector = 0:0.05:6002.45; %hard coded at the present
    
    avg_psp = nanmean(data.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
    
    figure
    for sweep = 1:size(data.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
        plot(time_vector(39200:41600) , data.RecTable.dataRaw{manipulation, 1}{1,1}(39200:41600, sweep), 'y');
        hold on
        plot(time_vector(39200:41600), avg_psp(39200:41600), 'k');
        %axis tight
        axis([1960 2080 -0.080 -0.072])
    end
    
    psp_base = nanmean(avg_psp(39400:39800));
    psp_max = max(avg_psp(40000:40800));
    psp_amplitude = psp_max - psp_base
    
    result.amplitude = psp_amplitude;
    result.nan = NaNtrace;
    
end

if sav_result == 1;
save(file_nm , 'result')
else
end