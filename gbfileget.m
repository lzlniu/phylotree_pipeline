clear
clc
list = importdata('list.txt');
len = length(list);
for i = 1:len
    gbacc = char(list(i,1));
    gbname = [num2str(i),'_',gbacc,'.gb'];
    gb = getgenbank(gbacc,'FILEFORMAT','Genbank','TOFILE',gbname);
end
clear
