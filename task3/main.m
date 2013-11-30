function main()
%MAIN entrypoint for the program

load('cleandata_students.mat');
cbr = CBRinit(x, y);
save('cbr_clean_data.mat', 'cbr');

% cross validation on clean data
load('cleandata_students.mat');
load('cleandata_10_fold_indices.mat');
cross_validation('clean', x, y, indices, 10);

% cross validation on noisy data
load('noisydata_students.mat');
load('noisydata_10_fold_indices.mat');
cross_validation('noisy', x, y, indices, 10);

end

