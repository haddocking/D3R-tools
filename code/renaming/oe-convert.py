#!/usr/bin/env python

from openeye.oechem import *
import sys

if len(sys.argv) != 3:
    OEThrow.Usage("%s <input> <output>" % sys.argv[0])

ifs = oemolistream()
ofs = oemolostream()

if not ifs.open(sys.argv[1]):
    OEThrow.Fatal("Unable to open %s" % sys.argv[1])

if not ofs.open(sys.argv[2]):
    OEThrow.Fatal("Unable to create %s" % sys.argv[2])

for mol in ifs.GetOEGraphMols():
    OEWriteMolecule(ofs, mol)
