function main () 

load('cleandata_students.mat');
load('cleandata_students_10_fold_indices.mat');

% refactor code in cross_validation that optimaises parameters using 
% the first fold 
[trainX, trainY, testX, testY] = get_data_from_fold (x, y, indices, 1);
[layers, topology, trainingFunction] = ...
    getOptimalParams(trainX, trainY, testX, testY);

%layers = [3, 3, 3];
%topology = 3; % Cascade feed forward network
%trainingFunction = 'trainscg';
%[trainingInstances, trainingLabels] = ANNdata (x, y);

%sixOutputNetwork = createNetwork(layers, trainingInstances, ...
%    trainingLabels, topology, trainingFunction);
%sixOutputNetwork = ...
%    train(sixOutputNetwork, trainingInstances, trainingLabels);

%save('six_output_network_clean.mat', 'sixOutputNetwork');

% a six-output neural network
%cross_validation(x, y, indices, 10, 0);

%save(pred, 'predictions');

%load('noisydata_students.mat');
%load('noisydata_students_10_fold_indices.mat');

% a six-output neural network
%cross_validation(x, y, indices, 10, 0);

end
