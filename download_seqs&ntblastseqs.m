%author:Zelin Li
%date:2020/03/21
%utility:download sequences from a list then make blast to find their similar sequences and download them alltogether.
%need:list1.txt
%main output:multi_seqs1.fa(contain list1 seqs), multi_seqs.fa(contain list1 seqs and its blast similar seqs).

clear
clc
options = weboptions;
options.Timeout = 55;
%clear and make web configuration

!sed -i 's/ //g' list1.txt
%must make sure the input list1.txt do not contain any space or tab or other characters!

list1 = importdata('list1.txt');
len1 = length(list1);
%import accession numbers list.

for i = 1:len1,
	acc = char(list1(i,1));
	multi_seqs(i).Sequence = getgenbank(acc,'SEQUENCEONLY','true');
	multi_seqs(i).Header = acc;
end
fastawrite('multi_seqs1.fa',multi_seqs);
clear list1;
%loop for download the fasta sequence from accession numbers list1.txt and output a multi_seqs1.fa.

!blastn -query multi_seqs1.fa -db /public/sharefolder/chennansheng/lzl_data/blast/nt -outfmt 6 | awk -F '\t' '$3>=97' | awk -F '\t' '$4>=1200' | sort -k 2i,2 -u | awk '{print $2}' | awk -F '.' '{print $1}' > list2.txt
%use sequences in multi_seqs1.fa as query to blast from loacl nt database and select the sequences that have pid>=97 and alignment length>=1200.

!cat list1.txt list2.txt | sed -e 's/ //g' -e 's/\t//g' | sort -u | uniq > list.txt
!grep -wvf list1.txt list.txt > list_rest.txt
%select the sequences that list1 donot have while list(list1 plus list2) have and generate list_rest.

list_rest = importdata('list_rest.txt');
%multi_seqs = fastaread('multi_seqs1.fa');
for i = 1:length(list_rest),
	acc = char(list_rest(i,1));
	multi_seqs(len1+i).Sequence = getgenbank(acc,'SEQUENCEONLY','true');
	multi_seqs(len1+i).Header = acc;
end
fastawrite('multi_seqs.fa',multi_seqs);
clear
%loop for download the rest of blast results sequences and add them into variable multi_seqs and output the fasta file - multi_seqs.fa from variable multi_seqs which contain all of the sequences.
