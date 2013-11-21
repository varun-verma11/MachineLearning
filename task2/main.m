function main () 

load('cleandata_students.mat');
load('cleandata_students_10_fold_indices.mat');

% TODO
% refactor code in cross_validation that optimaises parameters using 
% the first fold 
% [layers, topology, trainingFunction] = ...
%    getOptimalParams(...);

layers = [3, 3, 3];
topology = 3; % Cascade feed forward network
trainingFunction = 'trainscg';
[trainingInstances, trainingLabels] = ANNdata (x, y);

sixOutputNetwork = createNetwork(layers, trainingInstances, ...
    trainingLabels, topology, trainingFunction);

save('six_output_network_clean.mat', 'sixOutputNetwork');


% a six-output neural network
%six_output_network = cross_validation(x, y, indices, 10, 0);


%save(pred, 'predictions');

%load('noisydata_students.mat');
%load('noisydata_students_10_fold_indices.mat');

% a six-output neural network
%cross_validation(x, y, indices, 10, 0);

end
