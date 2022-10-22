## Setting up permutation analyses
### Explanation of PALM flags
The [user guide](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/UserGuide) for FSL PALM is very detailed, but can be a lot to take in. The flags used in the analyses performed here are in the table below. 

| flag        | Description |
|     :---:   |:----        |
| -i '<file>'   | Title       |
| -m '<file>'   | Text        |




- Description of surface averaging
- Masks
- Correction across modalities and contrasts
- ise flag
- permutation number defaults to 10,000
- Contrast and design matrices generated using FSL GLM setup. Great explanations for different scenarios. 

### Experiment
1. dHCP term-born neonates
2. dHCP term- vs. preterm-born neonates at term-equivalent age
3. HCP-YA
4. HCP-YA vs. dHCP term-born neonates 
