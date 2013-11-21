function main () 

load('cleandata_students.mat');
load('cleandata_students_10_fold_indices.mat');

layers = [3, 3, 3];
topology = 3; % Cascade feed forward network
trainingEpochs = 100;
trainingFunction = 'trainscg';
[trainingInstances, trainingLabels] = ANNdata (x, y);

sixOutputNetwork = createNetwork(layers, trainingInstances, ...
    trainingLabels, topology, trainingEpochs, trainingFunction);

save('six_output_network_clean.mat', 'sixOutputNetwork');


% a six-output neural network
%six_output_network = cross_validation(x, y, indices, 10, 0);


%save(pred, 'predictions');

%load('noisydata_students.mat');
%load('noisydata_students_10_fold_indices.mat');

% a six-output neural network
%cross_validation(x, y, indices, 10, 0);

end
