#!/usr/bin/env python

"""
Rename the common atoms in two PDB files so that they match.

All of the chemoinformatics software that we have come across
seems to have its own way of naming atoms. This script will
use the list of identified common atoms and rename the ones in
the second one to their counterpart in the first.
"""

import argparse
from os.path import basename


def _check_command_line_args():
    """Check the command line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        '-ref',
        '--reference_pdb_file',
        type=str,
        required=True,
        help='Path to the PDB file you want to compare against.'
    )
    parser.add_argument(
        '-mob',
        '--mobile_pdb_file',
        type=str,
        required=True,
        help='Path to the PDB file you want to compare.'
    )
    parser.add_argument(
        '-index',
        '--atom_indeces_file',
        type=str,
        required=True,
        help='Path to the file containing the common atom indeces.'
    )

    args = parser.parse_args()
    return args


def _read_pdb_file(path_to_file):
    """Read a PDB file and return all of its lines as a list."""
    file_contents = []
    with open(path_to_file) as in_file:
        for line in in_file:
            file_contents.append(line)
    return file_contents


def _extract_atom_id(atom_record):
    """Extracts the atom name."""
    return atom_record[12:16]


def main():
    """Run it."""
    args = _check_command_line_args()

    reference_pdb_file = args.reference_pdb_file
    mobile_pdb_file = args.mobile_pdb_file
    atom_indeces = args.atom_indeces_file

    pdb_file_contents = []

    for _ in [reference_pdb_file, mobile_pdb_file]:
        try:
            pdb_file_contents.append(_read_pdb_file(_))
        except (IOError, OSError):
            raise

    try:
        with open(atom_indeces) as in_file:
            for line in in_file:
                line = line.rstrip()
                reference_atom_index, mobile_atom_index = [
                    int(_) - 1 for _ in line.split()
                ]
                reference_atom_id = _extract_atom_id(
                    pdb_file_contents[0][reference_atom_index]
                )
                mobile_atom_id = _extract_atom_id(
                    pdb_file_contents[1][mobile_atom_index]
                )
                pdb_file_contents[1][mobile_atom_index] = (
                    pdb_file_contents[1][mobile_atom_index].replace(
                        mobile_atom_id, reference_atom_id
                    )
                )
    except (IOError, OSError):
        raise

    renamed_f = basename(mobile_pdb_file).replace('.pdb', '') + '-renamed.pdb'
    with open(renamed_f, 'w') as out_file:
        for line in pdb_file_contents[1]:
            out_file.write(line)

if __name__ == '__main__':
    main()
