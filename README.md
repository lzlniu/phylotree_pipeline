# phylotree_pipeline
## 1 download_seqs&gb.m

gbtree.m is a MATLAB script which can download multiple .gb files from a list.txt, list.txt should be placed in the same dictionary with download_seqs&gb.m, The list.txt should be printed only one row, each line is a NCBI accession number. It can be used in Windows or Linux, just using MATLAB desktop software. Or you can use it in Linux Shell by -- matlab -nodisplay -r "download_seqs&gb". Then you may type "exit()" to exit MATLAB command line.

#### Linux shell usage:matlab -nodisplay -r "download_seqs&gb"

#### input example:list.txt

## 2 download_seqs&ntblastseqs.m

download_seqs&ntblastseqs.m use multiple acc. num. in list1.txt to download sequences and save them in multi_seqs1.fa, then use these seqs to blast the local nt database to get the acc. num. from the blast results and generate list2.txt; combine list1 and list2 then sort and uniq to get list.txt, then select the sequences that list1 donot have while list have to generate list_rest.txt, use it to download the rest of the seqs. Combine all seqs together are save in multi_seqs.fa.

#### Linux shell usage:matlab -nodisplay -r "download_seqs&ntblastseqs"

#### input example:list1.txt

## 3 bootstraps_tree.m (use with bootstraps_tree.sh)

construct phylogenetics tree using NJ equivar method from multi_seqs.fa, generating tree.png. Then do bootstrapping(100) analysis and generating bootstraps_tree.png. 

#### Linux shell usage:bsub < bootstraps_tree.sh

#### input example:multi_seqs.fa

## 4 gbaa.sh

gbaa.sh is the bash shell script to extract the amino acids sequence from the .gb file.
