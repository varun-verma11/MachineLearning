function main () 

load('cleandata_students.mat');
load('cleandata_students_10_fold_indices.mat');
% a six-output neural network
six_output_network = cross_validation(x, y, indices, 10, 0);

save('six_output_network_clean.mat', 'six_output_network');
%save(pred, 'predictions');

load('noisydata_students.mat');
load('noisydata_students_10_fold_indices.mat');
% a six-output neural network
%cross_validation(x, y, indices, 10, 0);

end
