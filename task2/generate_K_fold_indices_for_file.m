function generate_K_fold_indices_for_file (datafile, K)
% This function generates indices for K fold split
% for the data in datafile. It saves the indices in a file
% named datafile + 'K_fold_indices'
% This function is only run once to generate the indices. 
% Future evaluation is done using the generated indices directly.
    load(datafile);
    N = size(x,1);
    indices = crossvalind('Kfold', N, K);
    datafilename = strcat(datafile, '_', num2str(K), '_fold_indices.mat');
    save(datafilename, 'indices');
end