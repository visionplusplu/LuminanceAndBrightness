# Luminance And Brightness
This repository contains scripts for processing behavioral, EEG, and DNN data, as well as for generating the main and supplementary figures for the manuscript Behavioral and Neural Evidence for Revising Luminous Intensity Standards.
A small batch of sample data is also included for testing purposes. As a result, the figures generated from this repository may not exactly match those in the manuscript. The full dataset will be made publicly available upon publication of the manuscript.

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
  
- Open MATLAB and set the ```LuminanceAndBrightness``` directory as your working directory.



## 3. Demo: Generate All Figures
To reproduce all figures and process the data as presented in the manuscript, you can use one of the following options:

**1. Run all experiment figures at once** 
- Run the following command in the MATLAB Command Window:
  ```
  main
  ```
- All figures will be displayed, and the output data will be saved to the designated directory.



**2. Run figures for each experiment separately** 
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
- All figures of this experiment will be displayed, and the output data will be saved to the designated directory.  


**Expected Output:**  
All main and supplementary figures
MATLAB data files containing key results.



**Typical install & run times:**  
- **Setup time:** Under 1 minute (copy/unzip files and configure the MATLAB path).
- **Data download:** The dataset repository is around 10 MB. Actual download time depends on internet speed.
- **Estimated run time:** Approximately 1 hour on a typical machine using the demo dataset, with most of the time spent on the weight-fitting stage.
- **After fitting:** Once fitting is completed, the fitted weights are saved, and subsequent runs (e.g., when regenerating figures) will no longer repeat this step.

## 4. Instruction of Use
- To run individual experiment scripts or customize the analyses:
  - Navigate to the corresponding subfolder directory
  - Execute the scripts for each experiment (see Section 3 for details).
   
- Running ```main.m``` will reproduce all results and figures reported in the paper.
- The scripts are modular, allowing you to adapt or extend the analyses as needed.

## 5. License
This code is distributed under the MIT License.

## 6. Open Source Repository
- **Scripts:** https://github.com/visionplusplu/LuminanceAndBrightness
- **Data:** https://osf.io/65bwf/ （Data will be uploaded to OSF upon publication)


## 7. Software Description and Documentation
- **Key operations:** The software processes behavioral and model prediction data, applies exclusion criteria, computes summary statistics, and generates all figures in the manuscript.
- **Fundamental tasks:** Raw data processing, model evaluation, analysis, and figure generation for the manuscript.
- **Algorithms and approach:** Standard psychophysical data processing, correlation analysis, and comparison of model predictions with human perception.
- **Dependencies:** Only standard MATLAB toolboxes required. Other dependencies are included in the function directory.






