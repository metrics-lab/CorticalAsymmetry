#!/bin/zsh

### Author: Logan Z. J. Williams, Oct 2022
### Email: logan.williams@kcl.ac.uk 
### *Please* email me if you have any questions/concerns about the code 

### This is a bash script that will run all of the cortical surface processing required for permutation analysis.
### It assumes that cortical surface registration has already been performed. The dHCP data made available as part 
### of the 3rd release is NOT suitable for this asymmetry analysis, as a further template symmetrisation step was 
### performed after the data release. 


### Set global variables 
DataDirectory=/data/dHCP
AnalysisDirectory=/data/CorticalAsymmetry
WorkbenchBinary=/data/Software/workbench/bin_linux64/wb_command
RegName=MSMStrain


### Loop over all subjects pre-specified cohort 

for Subject Session in $( cat <${AnalysisDirectory}/dHCP/TermAsymmetryList.txt) ; do ### dHCP naming system has subject and session ID, as some neonates have >1 scan

for Hemisphere in left right ; do ### dHCP naming system uses left/right instead of L/R

echo ${Subject} ${Session} ${Hemisphere}

### Calculate surface vertex area on native resolution mesh

echo 'Calculating pial surface vertex area'

PialSurface=${DataDirectory}/sub-${Subject}/ses-${Session}/anat/Native/sub-${Subject}_ses-${Session}_${Hemisphere}_pial.surf.gii
PialVertexArea=${DataDirectory}/sub-${Subject}/ses-${Session}/anat/Native/sub-${Subject}_ses-${Session}_${Hemisphere}_pial.surf.gii

${WorkbenchBinary} -surface-vertex-areas ${PialSurface} ${PialVA}

### Resample midthickness and pial surfaces from their registered, native resolution mesh to standard 32k resolution mesh 

echo 'Resampling anatomical surfaces' 

for anatomical in midthickness pial ; do 

SphereReg=${AnalysisDirectory}/dHCPAsymmetry/SurfaceTransforms/sub-${Subject}_ses-${Session}_hemi-${Hemisphere}_from-native_to-dhcpSym40_dens-32k_mode-sphere.reg40.surf.gii
TemplateSphere=${AnalysisDirectory}/Templates/dHCP/week-40_hemi-${Hemisphere}_space-dhcpSym_dens-32k_sphere.surf.gii
NativeSurface=${DataDirectory}/sub-${Subject}/ses-${Session}/anat/Native/sub-${Subject}_ses-${Session}_${Hemisphere}_${anatomical}.surf.gii
OutSurface=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_${anatomical}.${RegName}.surf.gii

${WorkbenchBinary} -surface-resample ${NativeSurface} ${SphereReg} ${TemplateSphere} BARYCENTRIC ${OutSurface} 

done

### Resample corrected cortical thickness, sulc and curvature from their registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

echo 'Resampling cortical metrics' 

for Metric in corr_thickness sulc curvature ; do 

SphereReg=${AnalysisDirectory}/dHCPAsymmetry/SurfaceTransforms/sub-${Subject}_ses-${Session}_hemi-${Hemisphere}_from-native_to-dhcpSym40_dens-32k_mode-sphere.reg40.surf.gii
NativeMidthickness=${DataDirectory}/sub-${Subject}/ses-${Session}/anat/Native/sub-${Subject}_ses-${Session}_${Hemisphere}_midthickness.surf.gii
TemplateMidthickness=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_midthickness.${RegName}.surf.gii
NativeMetric=${DataDirectory}/sub-${Subject}/ses-${Session}/anat/Native/sub-${Subject}_ses-${Session}_${Hemisphere}_${Metric}.shape.gii
OutMetric=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_${Metric}.${RegName}.shape.gii

${WorkbenchBinary} -metric-resample ${NativeMetric} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 

done

### Resample pial surface vertex area metric file from registered, native resolution mesh to standard 32k resolution mesh (using adaptive barycentric interpolation)

OutMetric=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_pial_va.${RegName}.shape.gii

${WorkbenchBinary} -metric-resample ${PialVA} ${SphereReg} ${TemplateSphere} ADAP_BARY_AREA ${OutMetric} -area-surfs ${NativeMidthickness} ${TemplateMidthickness} 

### Regress out the effect of cortical curvature on pial surface vertex areaa

UncorrectedPialVertexAreas=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_pial_va.${RegName}.shape.gii
CorrectedPialVertexAreas=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_pial_corr_va.${RegName}.shape.gii
Curvature=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_curvature.${RegName}.shape.gii

${WorkbenchBinary} -metric-regression ${UncorrectedPialVertexAreas} ${CorrectedPialVertexAreas} -remove ${Curvature}

done

### Calculate difference maps (asymmetry indices) for each cortical Metric file using: AI = (L - R)/((L + R)/2)

echo 'Calculating difference maps'

for Metric in pial_corr_va sulc corr_thickness ; do 

MetricLeft=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_left_${Metric}.${RegName}.shape.gii
MetricRight=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_${Metric}.${RegName}.shape.gii
MetricAsymmetry=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_asymmetry_${Metric}.${RegName}.shape.gii

${WorkbenchBinary} -metric-math '(x-y)/((x+y)/2)' ${MetricAsymmetry} -var x ${MetricLeft} -var y ${MetricRight}

done

### Create an average midthickness surface to perform metric smoothing on
### To do this, first need to flip the right hemisphere midthickness along the L-R axis, then can average surface XYZ coordinate, and then smooth to minimise 'dimples and pimples' 

LeftMidthickness=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_left_midthickness.${RegName}.surf.gii
RightMidthickness=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_right_midthickness.${RegName}.surf.gii
RightMidthicknessFlipped=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_right_flipped_midthickness.${RegName}.surf.gii
AverageMidthickness=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_LR_midthickness.${RegName}.surf.gii
AverageMidthicknessSmoothed=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_LR_midthickness.smoothed.${RegName}.surf.gii

echo 'Creating average midthickness surface for metric smoothing' 

${WorkbenchBinary} -surface-flip-lr ${RightMidthickness} ${RightMidthicknessFlipped}

${WorkbenchBinary} -surface-average ${AverageMidthickness} -surf ${LeftMidthickness} -surf ${RightMidthicknessFlipped}

${WorkbenchBinary} -surface-smoothing ${AverageMidthickness} 0.75 10 ${AverageMidthicknessSmoothed}

### Now create an average midthickness vertex area map for smoothing, as calculating surface vertex areas from the average midthickness surface is inaccurate.
### First, calculate surface vertex areas, then regress out the effect of curvature, then average left and right 

echo 'Creating average midthickness surface vertex areas for metric smoothing' 

for Hemisphere in left right ; do 

Midthickness=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_midthickness.${RegName}.surf.gii
MidthicknessVA=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_midthickness_va.${RegName}.surf.gii
CorrMidthicknessVA=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_corr_midthickness_va.${RegName}.surf.gii
Curvature=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_curvature.${RegName}.surf.gii

${WorkbenchBinary} -surface-vertex-areas ${Midthickness} ${MidthicknessVA}

${WorkbenchBinary} -metric-regression ${MidthicknessVA} ${CorrMidthicknessVA} -remove ${Curvature} 

done

AverageCorrMidthicknessVA=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_LR_corr_midthickness_va.${RegName}.surf.gii
LeftCorrMidthicknessVA=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_left_corr_midthickness_va.${RegName}.surf.gii
RightCorrMidthicknessVA=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_right_corr_midthickness_va.${RegName}.surf.gii

${WorkbenchBinary} -metric-math '(x+y)/2' ${AverageCorrMidthicknessVA} -var x ${LeftCorrMidthicknessVA} -var y ${RightCorrMidthicknessVA}

### Finally, perform metric smoothing 

echo 'Performing metric smoothing' 

for Metric in sulc corr_thickness pial_corr_va ; do 

MetricIn=${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_asymmetry_${Metric}.${RegName}.shape.gii
SmoothingKernel=2
MetricOut=$${AnalysisDirectory}/dHCPAsymmetry/sub-${Subject}/ses-${Session}/sub-${Subject}_ses-${Session}_${Hemisphere}_asymmetry_${Metric}.${RegName}.s2.shape.gii

${WorkbenchBinary} -metric-smoothing ${AverageMidthicknessSmoothed} ${MetricIn} ${SmoothingKernel} ${MetricOut} -corrected-areas ${AverageCorrMidthicknessVA}

done



