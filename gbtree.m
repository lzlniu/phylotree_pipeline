%author:lizelin
%date:2020/03/15
%utility:automatically download multiple .gb file and sequence from genbank and draw a phylotree.
%need:list.txt (contain multiple accession number in one row)
%output:tree.png (phylotree), multi_seqs.fa (multiple sequences in fasta format), many acc.gb (.gb files, named as accession number) in gbfiles (dictionary).
clear
clc
options = weboptions;
options.Timeout = 60;
list = importdata('list.txt');
parfor i = 1:length(list)
    acc = char(list(i,1));
    gbname = [num2str(i),'_',acc,'.gb'];
    getgenbank(acc,'FILEFORMAT','Genbank','TOFILE',gbname);
    multi_seqs(i).Sequence = getgenbank(acc,'SEQUENCEONLY','true');
    multi_seqs(i).Header = acc;
end
mkdir gbfiles
movefile *.gb gbfiles\
fastawrite('multi_seqs.fa',multi_seqs);
multi_seqs = fastaread('multi_seqs.fa');
aligned_seqs = multialign(multi_seqs);
distence = seqpdist(aligned_seqs);
tree = seqneighjoin(distence,'equivar',aligned_seqs);
plot(tree);
grid;
saveas(gcf,['./','tree.png']);
clear
