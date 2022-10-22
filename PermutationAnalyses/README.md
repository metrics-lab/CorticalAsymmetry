## Setting up permutation analyses

### Experiments
1. dHCP term-born neonates
2. dHCP term- vs. preterm-born neonates at term-equivalent age
3. HCP-YA
4. HCP-YA vs. dHCP term-born neonates 

### Explanation of PALM flags
The [user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for FSL PALM is very detailed, but can be a lot to take in. The flags used in the analyses performed here are presented in the table below. 

| flag        | Description |
|     :---:   |:----        |
| -i    | **Cortical modalities to be investigated.** This flag expects a single file merged across subjects, per cortical modality you are interested in. It is important that the order in which subject files are merged is consistent across all modalities, and is identical to the order of subjects in the design matrix.        |
| -m    | **Mask for the modalities to be investigated.** In this particular study, a common mask excluding the medial wall cut was used for all structural modalities, and separate masks were used for each resting-state network (with each mask only including vertices where Z-statistic > 5.1 for each network at the group level). The mask is defined at a group level in this case. If the mask file are single subject masks merged together, PALM will only include where the masks are consistent across *all* subjects.    |
| -s    | **Surface file to perform analysis on.** Here,  a single group average **midthickness** surface was used (created by averaging the left-right averaged midthickness surface for each subject within a given experiment). An additional file, representing the group average midthickness surface area (created by averaging the left-right averaged, corrected midthickness surface vertex areas for each subject within a given experiment) |
| -d    | Design matrix |
| -t    | *t*-contrasts |
| -ise    | Assume independent and symmetric errors (ISE), to allow sign-flipping. This was necessary for investigaitng asymmetry within a single cohort i.e. the dHCP-Term asymmetry experiment, and HCP-YA asymmetry experiment |
| -T    | Enable TFCE |
| -tfce2D    | Set TFCE parameters for 2D data (i.e. cortical surfaces) |
| -corrmod    | Apply FWER-correction of _p_-values over multiple modalities. |
| -corrcon    |  Apply FWER-correction of _p_-values over multiple contrasts. |
| -o    | Output prefix i.e. the names of the files generated as outputs of PALM |
| -logp    | Save the output p-values as -log10(p). This option is strongly recommended by Anderson Winkler, author of FSL PALM, and makes interpretation of significance maps a lot easier. |
| -accel    | Necessary for running the acceleration methods described [here](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/FasterInference). This was important, as PALM was run using default of 10,000 permutations across a large number of modalities (19 for the dHCP) and contrasts (6 for dHCP, and HCP-YA). |
| -precision   | Precision ("single" or "double") for input files. Double was used in this instance, as recommended by Anderson. |
| -nouncorrected    | Don't save uncorrected results |

### Design matrix and contrasts for PALM
These were generated using [FSL GLM setup](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/GLM). The page contains great explanations for different experimental scenarios. 


