#!/bin/zsh

palm -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1552_sulc_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1552_pial_corr_va_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1552_corr_thickness_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -s /data/Data/asymmetry/Nature_Human_Behaviour/average_1552_midthickness_FINAL.surf.gii \
     /data/Data/asymmetry/Nature_Human_Behaviour/average_1552_corr_midthickness_va_asymmetry_smoothed_FINAL.shape.gii \
     -d /data/Data/asymmetry/Nature_Human_Behaviour/NHB_Neonate_Adult_11-05-22/Neonate_Adult.mat \
     -t /data/Data/asymmetry/Nature_Human_Behaviour/NHB_Neonate_Adult_11-05-22/Neonate_Adult.con \
     -o /data/Data/asymmetry/Nature_Human_Behaviour/Neonate_Adult_11-05-22/neonate_adult \
     -T \
     -tfce2d \
     -precision double \
     -logp \
     -corrcon \
     -corrmod \
     -nouncorrected \
     -approx gamma
