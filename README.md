# Structural and functional asymmetry of the neonatal cerebral cortex

![Development of symmetric surface-based atlas](Images/Figure5.png)

This is a repo containing files and scripts used in Williams, LZJ et al. (2022). Structural and functional cortical asymmetry of the neonatal cerebral cortex. _bioRxiv_. DOI: [https://doi.org/10.1101/2021.10.13.464206](https://doi.org/10.1101/2021.10.13.464206)

## Software used for cortical surface processing and analysis
1. [Multimodal surface matching (MSM)](https://github.com/ecr05/MSM_HOCR/releases)
2. [Connectome Workbench](https://www.humanconnectome.org/software/get-connectome-workbench)
3. [FSL GLM Setup](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/)
4. [FSL PALM](https://github.com/andersonwinkler/PALM)

## Steps for performing analysis

### 1. Cortical surface registration
First, cortical surfaces need to be registered from their native space to the fully-symmetrised templates contained in [~/metrics-lab/CorticalAsymmetry/Templates](https://github.com/metrics-lab/CorticalAsymmetry/tree/main/Templates). Registration is run using MSM, and is driven by cortical folding.

**dHCP:** Registration was run using [align_to_template_3rd_release.sh](https://github.com/ecr05/dHCP_template_alignment/blob/master/surface_to_template_alignment/align_to_template_3rd_release.sh). The cortical surface deformations released as part of the 3rd dHCP release are **NOT** the same as the ones used in this manuscript (a further symmetrisation step was performed after release of the data). 

**HCP-YA:** Registration was run using [CorticalSurfaceRegistration.sh](https://github.com/metrics-lab/CorticalAsymmetry/tree/main/HCP-YA/)

### 2. Cortical surface processing
These scripts perform the following steps: 
1. Calculating surface area 
2. Resampling surfaces and structural cortical metrics from native to symmetric template space
3. Calculating difference maps (asymmetry index maps for each cortical metric) and smoothing

For the dHCP, use [CorticalSurfaceProcessing.sh]()

For the HCP-YA, use [CorticalSurfaceProcessing.sh](https://github.com/metrics-lab/CorticalAsymmetry/blob/main/HCP-YA/CorticalSurfaceProcessing.sh)

For dHCP-to-HCP, use NEED TO ADD 

Code for processing resting-state fMRI for functional asymmetry analyses in the dHCP is located [here](https://git.fmrib.ox.ac.uk/seanf/asymmetry-analysis). 

### 3. Permutation analyses 
The command-line calls to PALM used in these analyses are located in [~/metrics-lab/CorticalAsymmetry/PermutationAnalyses](https://github.com/metrics-lab/CorticalAsymmetry/tree/main/PermutationAnalyses). This also contains a README.md describing the flags and the inputs used. 
