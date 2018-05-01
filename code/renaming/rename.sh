#!/bin/bash

# This script will rename the atoms of the second PDB file provided
# as an argument to their match in the first PDB file provided as an
# argument. If the structures are of the same small molecule and atom
# naming is the only incoistency 
#
# You _NEED_ to remove all the lines but the ones listing the
# coordinates for the PDB that you are renaming. That includes
# anisotropies, records and anything else that you might have in
# the header. The reason for this is that the script operates on
# line numbers so if the line numbers do not correspond to the
# coordinates the renaming is going to be wrong.
# TODO: Fix this

if (( $# != 2 )); then
    echo "Wrong number of arguments."
    echo
    echo "Usage: bash $0 reference_pdb mobile_pdb"
    echo
    echo "reference_pdb: Use this PDB as the reference for the atom names."
    echo "mobile_pdb: Rename the atoms of this PDB file to their match in the reference_pdb."
    exit 1
fi

reference_pdb=$1
mobile_pdb=$2

reference_sdf="`basename $reference_pdb .pdb`.sdf"
mobile_sdf="`basename $mobile_pdb .pdb`.sdf"

python oe-convert.py $reference_pdb $reference_sdf
python oe-convert.py $mobile_pdb $mobile_sdf

Rscript --vanilla getListOfCommonAtoms.R $reference_sdf $mobile_sdf

python rename_atoms.py -ref $reference_pdb -mob $mobile_pdb -index atom_indices.dat

rm atom_indices.dat $reference_sdf $mobile_sdf
