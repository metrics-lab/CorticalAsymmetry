# Structural and functional asymmetry in the neonatal cerebral cortex

![Development of symmetric surface-based atlas](Images/Figure5.png)

This is a repo containing files and scripts used in Williams, LZJ et al. (2022). Structural and functional cortical asymmetry of the neonatal cerebral cortex.

## Steps for performing analysis

### 1. Calculating surface area 
Cortical surface area not publicly released by dHCP or HCP-YA studies.

### 2. Folding-based Cortical Surface Registration
Registration rerun for HCP-YA cohort

msm_centos_v3 --inmesh=100206.L.sphere.rot.native.surf.gii --refmesh=L.sphere.32k_fs_LR.surf.gii --indata=100206.L.sulc.native.shape.gii --refdata=/MSMSulc.refsulc.L.32k_fs_LR.shape.gii --conf=config_standard_MSMstrain_0.03 -o 100206.L.MSMstrain. 

Registration also re-run for dHCP (compared to 3rd release data), due to further symmetrisation step described in manuscript. 

### 3. Difference maps + smoothing
Calculating asymmetry indices per subject, and smoothing for structural measures. 

### 4. PALM
Can download PALM from x. Requires files merged across subjects, for each modality. Order of merging should be same as the design matrix.
