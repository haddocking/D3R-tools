# D3R_GC3

This is a collection of scripts that the HADDOCK team made use
of during D3R Grand Challenges 2 and 3. In addition to the scripts
we also provide the data that was used to train our ligand-based
binding affinity prediction method for GC3.

# Data

Under `data/GC3/CatS`
Under `data/GC3/Kinase/[JAK2-SC2/vEGFR2/p38a]`

All of these directories contain three files:

+ TRAIN.matrix This is symmetrix square matrix that contains all-vs-all Atom-Pair
based training set similarities. It is used to train the model.
+ TEST.matrix This is an assymetric matrix that contains the Atom-Pair based simi-
larities prediction set similarities. It is used for the ranking of the models that
was submitted for the competition.
+ IC50_train.csv This is the file that lists the training set binding afinities.

The matrix files have been compressed to cut down on the file size.

All three files are in CSV format. The IC50 file has a header as well.

# Code

Under `code`

`train.m` and `test.m`

These two scripts are used to train the SVM and carry out the predictions respectively.

`calc_atom-pair.R`

This is an R script that accepts two SDF formatted files as arguments and creates
an Atom Pair-based similarity matrix. It depends on the `ChemmineR` package.

Under `code/renaming`

This is a collection of scripts that can be used to rename PDB files of ligands.
The motivation for writing this was that different types of software had different
ways of naming the atoms that make up a ligand. Some name all atoms sequentially,
some sequentially by aotm type, some randomly. However, we needed the ligand atoms
to have consistent naming to allow for structural calculations to take place
succesfully.

The master script is the `rename.sh` bash script and as long as every other script
in the folder is in the same working directory or in the $PATH it should work as
advertised. The other scripts are:

`getListOfCommonAtoms.R`

This is an R script that calculates the Maximum Common Substructure (MCS) between
two molecules. If the two molecules are identical (they differ only in the way their
atoms are name) it should identify the entire molecule as being part of the MCS. It
prints an atom index mapping that is used by the python script below to do the actual
renaming.

`rename_atoms.py`

Python code that reads the output file of the R script above and renames the file
that is provided as an argument according to the other file that is provided as an
argument.

`oe-convert.py`

This is a Python OpenEye script that converts files between various formats often
encountered during chemoinformatics workflows. It is distributed with all OpenEye
installations and can also be obtained
[online](https://docs.eyesopen.com/toolkits/python/oechemtk/molreadwrite.html#readwritecompressedfiles.py)
