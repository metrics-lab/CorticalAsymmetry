# Structural and functional asymmetry in the neonatal cerebral cortex

![Development of symmetric surface-based atlas](Images/Figure5.png)

This is a repo containing files and scripts used in Williams, LZJ et al. (2022). Structural and functional cortical asymmetry of the neonatal cerebral cortex.

## Steps for performing analysis

### 1. Calculating surface area 
Cortical surface area not publicly released by dHCP or HCP-YA studies.

```bash
wb_command -surface-vertex-areas
```

### 2. Folding-based Cortical Surface Registration
Registration rerun for HCP-YA cohort

```bash
msm --inmesh=100206.L.sphere.rot.native.surf.gii \
    --refmesh=L.sphere.32k_fs_LR.surf.gii \
    --indata=100206.L.sulc.native.shape.gii \ 
    --refdata=/MSMSulc.refsulc.L.32k_fs_LR.shape.gii \
    --conf=config_standard_MSMstrain_0.03 \
    -o 100206.L.MSMstrain. 
```

Registration also re-run for dHCP (compared to 3rd release data), due to further symmetrisation step described in manuscript. 

```bash
dhcp_surface_processing.sh
```

### 3. Difference maps + smoothing
Calculating asymmetry indices per subject, and smoothing for structural measures. 

```bash
wb_command -metric-math '(x - y)/((x + y)/2)' <output> -var x <left hemi metric> -var y <right hemi metric> 

wb_command -surface-average <out surf> -surface <left midthickness> -surface <right midthickness>

wb_command -surface-smoothing <>

wb_command -metric-smoothing <> 
```

### 4. PALM
Can download PALM from [here](https://github.com/andersonwinkler/PALM). Need to specify to run with Octabe or MATLAB in [~/palm/palm](https://github.com/andersonwinkler/PALM/blob/master/palm). Requires files merged across subjects, for each modality. Order of merging should be same as the design matrix. Configuration used to run PALM for each experiment. 
