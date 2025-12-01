# Luminance And Brightness
This repository contains the data and scripts required to process behavioural, EEG & DNN data, and to generate main and supplementary figures for the manuscript: An evaluation of the candela as the S.I. unit of luminous intensity.

## 1. System Requirements
- **Operating System:** Windows, macOS, or Ubuntu (tested on Windows 10 or later, macOS Tahoe 26.1)
- **MATLAB Version:** R2020a or later
- **Required MATLAB Toolboxes:** Curve Fitting Toolbox (v3.6)
- **Hardware:** Standard desktop/laptop computer (no special hardware required)

## 2. Installation Guide

- Download the repository: 
  https://github.com/visionplusplu/LuminanceAndBrightness
  
- Or clone with git:
  ```bash
  git clone https://github.com/visionplusplu/LuminanceAndBrightness.git
  ```
  
- Open MATLAB and set the repository root directory as your working directory.



## 3. Demo: Generate All Figures
To generate all figures and process the data as in the manuscript:

- Start MATLAB and navigate to the main project directory, which contains the following four subfolders:
   - `IlluminationBrightness`
   - `PatchBrightness`
   - `SSVEP`
   - `WeightsTogether`

- Add one of these subfolders to the MATLAB path before running the code.

- Run the following scripts in the MATLAB Command Window:

   - IlluminationBrightness
     ```
     Code/RunIlluminationFig.m
     ```

   - PatchBrightness
     - FixedChroma experiment:
       ```
       Code/Run_nonChromaVariationExperiment.m
       ```
     - ChromaVariation experiment:
       ```
       PatchBrightness/Code/Run_ChromaVariationExperiment.m
       ```

   - SSVEP
     ```
     Code/SSVEP_Figure.m
     ```

   - WeightsTogether
     ```
     PlotAllWeights.m
     ```
All figures will be displayed, and the output data will be saved to the designated directory.

**Expected Output:**
All main and supplementary figures
MATLAB data files containing key results

**Typical install & run times:**
Setup time: Under 1 minute (copy/unzip files and configure the MATLAB path).
Data download: The dataset repository is at least 100 MB. Actual download time depends on internet speed.
Estimated run time: Approximately 2–3 hours on a typical machine. Most of this time is spent on the weight-fitting stage. 
Once fitting is completed, the fitted weights are saved, and subsequent runs (e.g., when regenerating figures) will no longer repeat this step. 

## 4. Instructions for Use
Prepare the data first by running process_onlinedata.m.
You can run any script individually after data preparation.
Reproducing results in the manuscript:

Running main.m will reproduce all results and figures as reported in the paper.
The scripts are modular; you can adapt or extend the analyses as needed.






