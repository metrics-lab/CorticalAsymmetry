#!/bin/zsh

for Subject in $( cat </data/CorticalAsymmetry/HCPAsymmetryList.txt) ; do 

for Hemispheres in L R ; do 

echo ${Subject} ${Hemisphere}


### Calculate surface vertex area on T1w space, native resolution mesh
PialSurface=/data/HCP/${subject}/T1w/Native/${subject}.${Hemisphere}.pial.native.surf.gii
PialVertexArea=/data/HCP/${subject}/T1w/Native/${subject}.${Hemisphere}.pial_va.native.shape.gii

wb_command -surface-vertex-areas ${PialSurface} ${PialVA}



### Resample midthickness and pial surfaces from their registered, native resolution mesh to standard 32k resolution mesh 

for anatomical in midthickness pial ; do 

SphereReg=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.MSMStrain.sphere.reg.surf.gii
TemplateSphere=/data/HCPpipelines/global/templates/standard_mesh_atlases/${Hemisphere}.sphere.32k_fs_LR.surf.gii
NativeSurface=/data/HCP/${subject}/MNINonLinear/Native/${subject}.${Hemisphere}.${anatomical}.native.surf.gii
OutSurface=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.${anatomical}.MSMStrain.surf.gii

wb_command -surface-resample ${NativeSurface} ${SphereReg} ${TemplateSphere} BARYCENTRIC ${OutSurface} 

done



### Resample corrected cortical thickness, sulc and curvature from their registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

for metric in corrThickness sulc curvature ; do 

SphereReg=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.MSMStrain.sphere.reg.surf.gii
NativeMidthickness=/data/HCP/${subject}/MNINonLinear/Native/${subject}.${Hemisphere}.midthickness.native.surf.gii
TemplateMidthickness=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.${anatomical}.MSMStrain.surf.gii
NativeMetric=/data/HCP/${subject}/MNINonLinear/Native/${subject}.${Hemisphere}.${metric}.native.shape.gii
OutMetric=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.${metric}.MSMStrain.shape.gii

wb_command -metric-resample ${NativeMetric} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 

done



### Resample pial surface vertex area metric file from registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

OutMetric=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.pial_va.MSMStrain.shape.gii

wb_command -metric-resample ${PialVA} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 


### Regress out the effect of cortical curvature on pial surface vertex areaa
UncorrectedPialVertexAreas=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.pial_va.MSMStrain.shape.gii
CorrectedPialVertexAreas=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.pial_corr_va.MSMStrain.shape.gii
Curvature=/data/CorticalAsymmetry/HCPAsymmetry/${subject}/${subject}.${Hemisphere}.curvature.MSMStrain.shape.gii

wb_command -metric-regression ${UncorrectedPialVertexAreas} ${CorrectedPialVertexAreas} -remove ${Curvature}

done

done



