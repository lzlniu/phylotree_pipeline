#!/bin/bash
#BSUB -q fat
#BSUB -o tree.out
#BSUB -e tree.err
#BSUB -n 6
matlab -nodisplay -r "bootstraps_tree;exit;"
