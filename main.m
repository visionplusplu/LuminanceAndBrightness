clear;clc
close all

cd ./PatchBrightness/Code
Run_nonChromaVariationExperiment;
Run_ChromaVariationExperiment;

cd ../../SSVEP/Code
SSVEP_Figure;

cd ../../IlluminationBrightness/Code
RunIlluminationFig;

cd ../../WeightsTogether
PlotAllWeights;