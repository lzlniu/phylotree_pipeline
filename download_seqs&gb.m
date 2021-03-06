%author:lizelin
%date:2020/03/15
%utility:automatically download multiple .gb file and sequences from genbank.
%need:list.txt (contain multiple accession number in one row)
%output:multi_seqs.fa (multiple sequences in fasta format), many acc.gb (.gb files, named as accession number) in gbfiles (dictionary).

clear
clc
options = weboptions;
options.Timeout = 55;
list = importdata('list.txt');
for i = 1:length(list)
    acc = char(list(i,1));
    gbname = [num2str(i),'_',acc,'.gb'];
    getgenbank(acc,'FILEFORMAT','Genbank','TOFILE',gbname);
    multi_seqs(i).Sequence = getgenbank(acc,'SEQUENCEONLY','true');
    multi_seqs(i).Header = acc;
end
mkdir gbfiles
movefile *.gb gbfiles/
fastawrite('multi_seqs.fa',multi_seqs);
clear
