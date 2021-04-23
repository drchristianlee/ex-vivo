# ex-vivo analysis scripts
A repository of various scripts to read and analyze ex vivo whole cell recording data. 

## Dependencies 

*Repositories from Github user drchristianlee*

Functions

*Repositories from Github user christiankeine*

HEKA_Patchmaster_Importer

*Repositories from Github user raacampbell*

shadedErrorBar

## Measurements

These scripts can be used to measure action potential parameters as well as postsynaptic potential parameters. An easy to use gui collects user input to run the analysis desired. The most recent scripts run on data stored by Patchmaster Next (https://www.heka.com/downloads/downloads_main.html#down_patchmaster_next). To analyze this type of data, begin by running *analysis.mat* in the folder named Patchmaster Next. 

## Results

Results are stored in the variable named *result*
- HoldingCurr (holding current applied during experiment)
- peaks (peak indices)
- Rin (input resistance)
- V_mem (resting membrane potential)
- threshold (action potential thresholds)
- amp (action potential amplitude)
- width (width of action potential at half amplitude)
- ahp (afterhyperpolarization amplitude)

Results are measured from both the raw data and interpolated data. 
