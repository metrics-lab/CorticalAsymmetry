# Structural and functional asymmetry of the neonatal cerebral cortex

![Development of symmetric surface-based atlas](Images/Figure5.png)

This is a repo containing files and scripts used to investigate cortical asymmetry in the Developing Human Conenctome Project and Human Connectome Project (Young Adult).

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
**dHCP-to-HCP:** Registration between dHCP and HCP-YA was run using [CorticalSurfaceRegistration.sh]. Deformations available in ~/Templates/Deformations

### 2. Cortical surface processing
These scripts perform the following steps: 
1. Calculating surface area 
2. Resampling surfaces and structural cortical metrics from native to symmetric template space
3. Calculating difference maps (asymmetry index maps for each cortical metric) and smoothing

**dHCP:** Use [CorticalSurfaceProcessing.sh]()

**HCP-YA:** Use [CorticalSurfaceProcessing.sh](https://github.com/metrics-lab/CorticalAsymmetry/blob/main/HCP-YA/CorticalSurfaceProcessing.sh)

**dHCP-to-HCP:** Use [CorticalSurfaceProcessing.sh](https://github.com/metrics-lab/CorticalAsymmetry/blob/main/dHCP_HCP-YA/CorticalSurfaceProcessing.sh)

Code for processing resting-state fMRI for functional asymmetry analyses in the dHCP is located [here](https://git.fmrib.ox.ac.uk/seanf/asymmetry-analysis). 

### 3. Permutation analyses 
The command-line calls to PALM used in these analyses are located in [~/metrics-lab/CorticalAsymmetry/PermutationAnalyses](https://github.com/metrics-lab/CorticalAsymmetry/tree/main/PermutationAnalyses). This also contains a README.md describing the flags and the inputs used. 

## Citation
If you found this code useful, or have used the [dHCP symmetric template](https://brain-development.org/brain-atlases/atlases-from-the-dhcp-project/cortical-surface-template/) for your own work, please cite: 

[Structural and functional asymmetry of the neonatal cerebral cortex](https://www.biorxiv.org/content/10.1101/2021.10.13.464206v2.abstract)

```
@article{williams2022structural,
  title={Structural and functional asymmetry of the neonatal cerebral cortex},
  author={Williams, Logan ZJ and Fitzgibbon, Sean P and Bozek, Jelena and Winkler, Anderson M and Dimitrova, Ralica and Poppe, Tanya and Schuh, Andreas and Makropoulos, Antonios and Cupitt, John and O’Muircheartaigh, Jonathan and others},
  journal={bioRxiv},
  year={2022}
}
```
