#!/bin/zsh

### Author: Logan Z. J. Williams, Oct 2022
### Email: logan.williams@kcl.ac.uk 
### *Please* email me if you have any questions/concerns about the code 

### This is a bash script that will run all of the cortical surface processing required for permutation analysis.
### It assumes that cortical surface registration has already been performed. The HCP-YA data made available at ConnectomeDB 
### is either MSMSulc (highly regularised registration to folding-based template) or MSMAll (areal-based alignment using RSN 
### spatial maps, T1w/T2w ratio map and visuotopic maps), so is not appropriate for comparison against the dHCP cohort.

for Subject in $( cat </data/CorticalAsymmetry/HCP/HCPAsymmetryList.txt) ; do 

for Hemisphere in L R ; do 

echo ${Subject} ${Hemisphere}

### Calculate surface vertex area on T1w space, native resolution mesh

echo 'Calculating pial surface vertex area'

PialSurface=/data/HCP/${Subject}/T1w/Native/${Subject}.${Hemisphere}.pial.native.surf.gii
PialVertexArea=/data/HCP/${Subject}/T1w/Native/${Subject}.${Hemisphere}.pial_va.native.shape.gii

wb_command -surface-vertex-areas ${PialSurface} ${PialVA}

### Resample midthickness and pial surfaces from their registered, native resolution mesh to standard 32k resolution mesh 

echo 'Resampling anatomical surfaces' 

for anatomical in midthickness pial ; do 

SphereReg=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.MSMStrain.sphere.reg.surf.gii
TemplateSphere=/data/HCPpipelines/global/templates/standard_mesh_atlases/${Hemisphere}.sphere.32k_fs_LR.surf.gii
NativeSurface=/data/HCP/${Subject}/MNINonLinear/Native/${Subject}.${Hemisphere}.${anatomical}.native.surf.gii
OutSurface=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.${anatomical}.MSMStrain.surf.gii

wb_command -surface-resample ${NativeSurface} ${SphereReg} ${TemplateSphere} BARYCENTRIC ${OutSurface} 

done

### Resample corrected cortical thickness, sulc and curvature from their registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

echo 'Resampling cortical metrics' 

for Metric in corrThickness sulc curvature ; do 

SphereReg=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.MSMStrain.sphere.reg.surf.gii
NativeMidthickness=/data/HCP/${Subject}/MNINonLinear/Native/${Subject}.${Hemisphere}.midthickness.native.surf.gii
TemplateMidthickness=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.${anatomical}.MSMStrain.surf.gii
NativeMetric=/data/HCP/${Subject}/MNINonLinear/Native/${Subject}.${Hemisphere}.${Metric}.native.shape.gii
OutMetric=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.${Metric}.MSMStrain.shape.gii

wb_command -metric-resample ${NativeMetric} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 

done

### Resample pial surface vertex area metric file from registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

OutMetric=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.pial_va.MSMStrain.shape.gii

wb_command -metric-resample ${PialVA} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 

### Regress out the effect of cortical curvature on pial surface vertex areaa

UncorrectedPialVertexAreas=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.pial_va.MSMStrain.shape.gii
CorrectedPialVertexAreas=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.pial_corr_va.MSMStrain.shape.gii
Curvature=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.curvature.MSMStrain.shape.gii

wb_command -metric-regression ${UncorrectedPialVertexAreas} ${CorrectedPialVertexAreas} -remove ${Curvature}

done

### Calculate difference maps (asymmetry indices) for each cortical Metric file using: AI = (L - R)/((L + R)/2)

echo 'Calculating difference maps'

for Metric in pial_corr_va sulc corrThickness ; do 

MetricLeft=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.L.${Metric}.MSMStrain.shape.gii
MetricRight=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.R.${Metric}.MSMStrain.shape.gii
MetricAsymmetry=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.asymmetry.${Metric}.MSMStrain.shape.gii

wb_command -metric-math '(x-y)/((x+y)/2)' ${MetricAsymmetry} -var x ${MetricLeft} -var y ${MetricRight}

done

### Create an average midthickness surface to perform metric smoothing on
### To do this, first need to flip the right hemisphere midthickness along the L-R axis, then can average surface XYZ coordinate, and then smooth to minimise 'dimples and pimples' 

LeftMidthickness=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.L.midthickness.MSMStrain.surf.gii
RightMidthickness=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.R.midthickness.MSMStrain.surf.gii
RightMidthicknessFlipped=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.R.midthickness.flipped.MSMStrain.surf.gii
AverageMidthickness=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.LR.midthickness.MSMStrain.surf.gii
AverageMidthicknessSmoothed=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.LR.midthickness.smoothed.MSMStrain.surf.gii

echo 'Creating average midthickness surface for metric smoothing' 

wb_command -surface-flip-lr ${RightMidthickness} ${RightMidthicknessFlipped}

wb_command -surface-average ${AverageMidthickness} -surf ${LeftMidthickness} -surf ${RightMidthicknessFlipped}

wb_command -surface-smoothing ${AverageMidthickness} 0.75 10 ${AverageMidthicknessSmoothed}

### Now create an average midthickness vertex area map for smoothing, as calculating surface vertex areas from the average midthickness surface is inaccurate.
### First, calculate surface vertex areas, then regress out the effect of curvature, then average left and right 

echo 'Creating average midthickness surface vertex areas for metric smoothing' 

for Hemisphere in L R ; do 

Midthickness=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.midthickness.MSMStrain.surf.gii
MidthicknessVA=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.midthickness_va.MSMStrain.shape.gii
CorrMidthicknessVA=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.corr_midthickness_va.MSMStrain.shape.gii
Curvature=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.${Hemisphere}.curvature.MSMStrain.shape.gii

wb_command -surface-vertex-areas ${Midthickness} ${MidthicknessVA}

wb_command -metric-regression ${MidthicknessVA} ${CorrMidthicknessVA} -remove ${Curvature} 

done

AverageMidthicknessVA=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.LR.corr_midthickness_va.MSMStrain.shape.gii
LeftMidthicknessVA=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.L.corr_midthickness_va.MSMStrain.shape.gii
RightMidthicknessVA=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.R.corr_midthickness_va.MSMStrain.shape.gii

wb_command -metric-math '(x+y)/2' ${AverageMidthicknessVA} -var x ${LeftMidthicknessVA} -var y ${RightMidthicknessVA}

### Finally, perform metric smoothing 

echo 'Performing metric smoothing' 

for Metric in sulc corrThickness pial_corr_va ; do 

MetricIn=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.asymmetry.${Metric}.MSMStrain.shape.gii
SmoothingKernel=2
MetricOut=/data/CorticalAsymmetry/HCPAsymmetry/${Subject}/${Subject}.asymmetry.${Metric}.MSMStrain.s2.shape.gii

wb_command -metric-smoothing ${AverageMidthicknessSmoothed} ${MetricIn} ${SmoothingKernel} ${MetricOut} -corrected-areas ${AverageMidthicknessVA}

done



