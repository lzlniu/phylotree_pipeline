%author:Zelin Li
%date:2020/03/21
%utility:useing multiple sequences to make phylotree and bootstrapping.
%need:multi_seqs.fa
%output:blast_tree.png, bootstraps_blast_tree.png.

clear
clc
multi_seqs = fastaread('multi_seqs.fa');
aligned_seqs = multialign(multi_seqs,'USEPARALLEL', 'true');
distence = seqpdist(aligned_seqs,'USEPARALLEL', 'true','ALPHABET','NT');
orig_tree = seqneighjoin(distence,'equivar',aligned_seqs);
plot(orig_tree);
grid;
saveas(gcf,['./','tree.png']);
num_seqs = length(aligned_seqs);
%make phylotree from multi_seqs.fa.

num_boots = 100;
seq_len = length(aligned_seqs(1).Sequence);
boots = cell(num_boots,1);
for n = 1:num_boots
    reorder_index = randsample(seq_len,seq_len,true);
    for i = num_seqs:-1:1 %reverse order to preallocate memory
        bootseq(i).Header = aligned_seqs(i).Header;
        bootseq(i).Sequence = strrep(aligned_seqs(i).Sequence(reorder_index),'-',''); 
    end
    boots{n} = bootseq; 
end
%making bootstrap replicates from the data.

fun = @(x) seqneighjoin(x,'equivar',{aligned_seqs.Header});
boot_trees = cell(num_boots,1);
parpool('local');
parfor (n = 1:num_boots)
    dist_tmp = seqpdist(boots{n});
    boot_trees{n} = fun(dist_tmp);
end
delete(gcp('nocreate'));
%computing the distances between bootstraps and phylogenetic reconstruction.

for i = num_seqs-1:-1:1  % for every branch, reverse order to preallocate
    branch_pointer = i + num_seqs;
    sub_tree = subtree(orig_primates_tree,branch_pointer);
    orig_pointers{i} = getcanonical(sub_tree);
    orig_species{i} = sort(get(sub_tree,'LeafNames'));
end
for j = num_boots:-1:1
    for i = num_seqs-1:-1:1  % for every branch
        branch_ptr = i + num_seqs;
        sub_tree = subtree(boot_trees{j},branch_ptr);
        clusters_pointers{i,j} = getcanonical(sub_tree);
        clusters_species{i,j} = sort(get(sub_tree,'LeafNames'));
    end
end
count = zeros(num_seqs-1,1);
for i = 1 : num_seqs -1  % for every branch
    for j = 1 : num_boots * (num_seqs-1)
        if isequal(orig_pointers{i},clusters_pointers{j})
            if isequal(orig_species{i},clusters_species{j})
                count(i) = count(i) + 1;
            end
        end
    end
end
Pc = count ./ num_boots;   % confidence probability (Pc)
%counting the branches with similar topology.

[ptrs,dist,names] = get(orig_tree,'POINTERS','DISTANCES','NODENAMES');
for i = 1:num_seqs -1  % for every branch
    branch_ptr = i + num_seqs;
    names{branch_ptr} = [names{branch_ptr} ', confidence: ' num2str(100*Pc(i)) ' %'];
end
tr = phytree(ptrs,dist,names);
%visualizing the confidence values in the original tree.
plot(tr);
grid;
saveas(gcf,['./','bootstraps_tree.png']);
clear
