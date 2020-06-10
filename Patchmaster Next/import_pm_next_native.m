% To run this script have the folder containing this script as well as
% HEKA_Patchmaster_Importer in the path.

% This script uses HEKA_Patchmaster_Importer to import data. As of January
% 27, 2020, the solutions data do not match what was used, so ignore these
% data until fixed. 

clear;
close all

cell = str2num(cell2mat(inputdlg('Please enter the cell you would like to plot data from')));
manipulation = str2num(cell2mat(inputdlg('Please enter the manipulation you would like to plot')));
NaNtrace = str2num(cell2mat(inputdlg('Please enter any sweeps to change to NaN or else leave empty')));
meas_sweep = str2num(cell2mat(inputdlg('Please enter the sweep for action potential analysis; start with 10 and work backward')));

HEKA_Importer.GUI %runs importer

for protocols = 1:size(ans.RecTable, 1);
    if ans.RecTable{protocols, 1} == cell;
        break
    else
    end
end

manipulation = (manipulation - 1) + protocols;

time_vector = 0:0.05:899.995; %hard coded at the present

if isempty(NaNtrace) == 0;
    for correctval = 1:size(NaNtrace, 2);
        ans.RecTable.dataRaw{manipulation, 1}{1,1}(1:end, NaNtrace(1,correctval)) = NaN;
    end
else
end

for sweep = 1:size(ans.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
    ax1 = subplot(2,1,1);
    plot(time_vector , ans.RecTable.dataRaw{manipulation, 1}{1,1}(:, sweep));
    hold on
    axis tight
    ax2 = subplot(2,1,2);
    plot(time_vector , ans.RecTable.stimWave{manipulation, 1}.DA_3(:, sweep));
    hold on
    axis([0 900 -2 2])
end

%code to find resting membrane potential
Vtrace = ans.RecTable.dataRaw{manipulation, 1}{1,1}(1000:2999, :);
V_avg = mean(Vtrace, 1);
V_mem = mean(V_avg, 2) * 1000;

%code to find and plot input resistance and plot IV curve
for iv_step = 1:size(ans.RecTable.dataRaw{manipulation, 1}{1,1}, 2);
    I(iv_step, 1) = ans.RecTable.stimWave{manipulation, 1}.DA_3(6000, iv_step);
    V(iv_step, 1) = ans.RecTable.dataRaw{manipulation, 1}{1,1}(6000, iv_step);
end

figure
plot(I, V)

%now compute input resistance from the smallest hyperpolarizing step
Vir = (ans.RecTable.dataRaw{manipulation, 1}{1,1}(6000, 5) - ans.RecTable.dataRaw{manipulation, 1}{1,1}(2000, 5)); %voltage change from 100 ms into sweep to 100 ms after pulse
Iir = (ans.RecTable.stimWave{manipulation, 1}.DA_3(6000, 5) - ans.RecTable.stimWave{manipulation, 1}.DA_3(2000, 5)) / 1000000000; %corrects bug where current is scaled incorrectly
Rin = (Vir/Iir) / 1000000; %gives output in megaohms 

%compute action potential parameters
[pks, locs, w, p] = findpeaks(ans.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep), 'MinPeakHeight' , 0, 'MinPeakDistance', 5);
figure
plot(ans.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep))
hold on
plot(locs, pks, 'o');
slope = diff(ans.RecTable.dataRaw{manipulation,1}{1,1}(:,meas_sweep));

for spike = 1:1%size(locs, 1);
    max_rise_slope = max(slope(locs(spike, 1) - 50: locs(spike, 1) + 50));
    perc_max = max_rise_slope * 0.15;
    for thresh_idx = locs(spike, 1) - 50: locs(spike, 1) + 50;
        if slope(thresh_idx, 1) > perc_max;
            break
        else
        end
    end
    threshold(1, spike) = ans.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx,meas_sweep)
    peak = max(ans.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx:thresh_idx + 50,meas_sweep))
    half_amp = (peak - threshold(1, spike))/2;
    [row,col,idx_1] = find(ans.RecTable.dataRaw{manipulation,1}{1,1}(thresh_idx:thresh_idx + 50, meas_sweep) > (threshold(1, spike) + half_amp)); %this is not working
    half_width(1, spike) = (1/ans.RecTable.SR(manipulation)) * size(idx_1, 1);
    %ahp(1, spike) = 
end

result.Rin = Rin;
result.V_mem = V_mem;
result.threshold = threshold; %continue with result and then save?


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