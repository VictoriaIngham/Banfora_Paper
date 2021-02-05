## Code used in Ingham et al. 20201

Custom R code used for investigating the evolution of resistance in an Anophles coluzzii colony from Banfora, Burkina Faso

**NCBI Taxid to higher Taxon: Assign_Kingdom.R**

This code was written to identify which Kingdom a TaxID code from command line BLAST was from. The code required the NCBI Tax dump to run, specifically the file ‘rankedlineages.dmp’. The input must be in the format of the example BLAST file to work ('blasted_contrigs.txt').

Requirements:
tidyverse
stringr
