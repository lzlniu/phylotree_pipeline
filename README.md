# m_related
## 1 gbtree.m

gbtree.m is a MATLAB script which can get multiple .gb files from a list.txt, list.txt should be placed in the same dictionary with gbfileget.m, The list.txt should be printed only one row, each line is a NCBI accession number. It can be used in Windows or Linux, just using MATLAB desktop software. Or you can use it in Linux Shell by -- "matlab -nodisplay -r gbtree". Then you may type "exit()" to exit MATLAB command line.

## 2 ntblasttree.m

ntblasttree.m use multiple acc. num. inlist1.txt to get sequences, use these seqs to blast the local nt database, then get the acc. num. from the blast results to generate list2.txt, combine list1 and list2 then sort and uniq to get list.txt, then select the sequences that list1 donot have while list have to generate list_rest.txt, use it to get the rest of the seqs, combine all seqs together in multi_seqs.fa, at last make the phylotree using multi_seqs.fa.

## 3 gbaa.sh

gbaa.sh is the bash shell script to extract the amino acids sequence from the .gb file.
