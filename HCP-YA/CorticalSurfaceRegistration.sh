#!/bin/zsh


for Subject in $( cat </data/CorticalAsymmetry/HCPAsymmetryList.txt) ; do 

for Hemisphere in L R ; do 

echo ${Subject} ${Hemisphere}

msm --inmesh=/data/HCP/${Subject}/MNINonLinear/Native/${Subject}.${Hemisphere}.sphere.rot.native.surf.gii \
    --refmesh=/data/CorticalAsymmetry/Templates/HCP-YA/${Hemisphere}.sphere.32k_fs_LR.surf.gii \
    --indata=/data/HCP/${Subject}/MNINonLinear/Native/${Subject}.${Hemisphere}.sulc.native.shape.gii \ 
    --refdata=/data/CorticalAsymmetry/Templates/HCP-YA/MSMSulc.refsulc.${Hemisphere}.LR.32k_fs_LR.shape.gii \
    --conf=/data/CorticalAsymmetry/Configs/MSMStrain_HCPCorticalAsymmetry \
    -o /data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.L.MSMstrain. 

done

