#!/bin/zsh

InMesh=/data/CorticalAsymmetry/Templates/dHCP/week-40_hemi-left_space-dhcpSym_dens-32k_sphere.surf.gii 
RefMesh=/data/CorticalAsymmetry/Templates/HCP-YA/L.sphere.32k_fs_LR.surf.gii 
InData=/data/CorticalAsymmetry/Templates/dHCP/week-40_hemi-LR_space-dhcpSym_dens-32k_sulc.shape.gii
RefData=/data/CorticalAsymmetry/Templates/HCP-YA/MSMSulc.refsulc.L.LR.32k_fs_LR.shape.gii
Out=/data/CorticalAsymmetry/dHCP_HCP-YA/dHCP_HCP-YA.MSMStrain
Config=/data/CorticalAsymmetry/Configs/MSMStrain_dHCPCorticalAsymmetry

msm --inmesh=${InMesh}
    --refmesh=${RefMesh}
    --indata=${InData}
    --refdata=${RefData}
    --out=${Out}
    --conf=${Config}
