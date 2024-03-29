#!/bin/zsh

palm -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1110_sulc_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1110_pial_corr_va_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -i /data/Data/asymmetry/Nature_Human_Behaviour/merged_1110_corrThickness_asymmetry_smoothed_FINAL.shape.gii \
     -m /data/Data/dHCP_1/dhcp_3rd_release_atlas/week-40_hemi-left_space-dhcpSym_dens-32k_desc-medialwallsymm_mask_ero.HCP.shape.gii \
     -s /data/Data/asymmetry/Nature_Human_Behaviour/average_1110_LR.midthickness.surf.gii \
     /data/Data/asymmetry/Nature_Human_Behaviour/average_1110_LR.corr_midthickness_va.shape.gii \
     -d /home/lw19/Desktop/adult_asym/HCP_no_residual.mat -t /home/lw19/Desktop/adult_asym/HCP_no_residual.con \
     -o /data/Data/asymmetry/Nature_Human_Behaviour/Adult_24-05-22/adult \
     -T \
     -tfce2d \
     -precision double \
     -logp \
     -corrcon \
     -corrmod \
     -nouncorrected \
     -approx gamma \
     -ise
