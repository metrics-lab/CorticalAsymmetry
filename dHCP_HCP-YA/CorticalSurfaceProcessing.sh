#!/bin/zsh

for Subject Session in $( cat </data/CorticalAsymmetry/dHCP/TermAsymmetryList) ; do 

for Metric in pial_corr_va sulc corr_thickness ; do 

echo ${Subject} ${Session} ${Metric} 

MetricIn=/data/CorticalAsymmetry/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}.asymmetry.${Metric}.MSMStrain.shape.gii
CurrentSphere=/data/CorticalAsymmetry/dHCP_HCP-YA/dHCP_HCP-YA.MSMStrain.sphere.reg.surf.gii 
NewSphere=/data/CorticalAsymmetry/Templates/HCP-YA/L.sphere.32k_fs_LR.surf.gii
MetricOut=/data/CorticalAsymmetry/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}.asymmetry.${Metric}.MSMStrain.HCP.shape.gii

wb_command -metric-resample ${MetricIn} ${CurrentSphere} ${NewSphere} BARYCENTRIC ${MetricOut} 

done

done
