function [ann_trained] = GenerateSingleOutputANN(examples, targets)
    for i = 1:6
        % configure parameters

        % matrix of min and max values for R input elements.min-max values(0-1)
        PR  = [zeros(45,1) ones(45,1)]; 
        % size of layers
        S   = [15, 1];
        % Transfer function of ith layer: tan sigmoid; pure linear
        TF  = {'tansig', 'purelin'}; 
        % Backprop network training function: scaled conjugate gradient
        BTF = 'trainscg';
        % Backprop weight/bias learning function
        BLF = 'learngdm';
        % Performance function: mean squared error
        PF  = 'mse';       
        % indexed division
        DDF = 'divideind';              


        ann = newff(PR, S, TF, BTF, BLF, PF);

        % split input data for training and validation
        [train_x, train_y, valid_x, valid_y, ~, ~] = ...
            split_data_for_training_validation_test(examples, targets);
        size_train_data = size(train_x);
        x_train_validation = [train_x; valid_x]';
        y_train_validation = [train_y; valid_y];
        size_total_data = size(x_train_validation);

        % configure parameters for the nueral network
        ann.divideFcn = DDF;
        ann.trainParam.epochs = 100;
        ann.trainParam.show = 5;
        ann.trainParam.lr = 0.001;
        ann.divideParam.trainInd = 1:size_train_data;
        ann.divideParam.valInd   = size_train_data+1:size_total_data;

        % initialise artificial neural network
        ann = init(ann);

        % transform input data using provided data for ANN
        binarytargets = ...
            change_output_labels_to_binary(y_train_validation, i);

        % train the generated ANN
        [ann_trained, ~] = train(ann, x_train_validation, binarytargets);
    end
end

% This function is used to to transform a the results for given data from y 
% to binary. i.e. for label 4, for all  the values of 4 in matrix being 
% 4 will be changed to 1 and rest to 0.
function [ output ] = change_output_labels_to_binary( label_matrix, label)
    output = zeros(size(label_matrix));
    for i = 1:size(label_matrix)
        output(i) = (label_matrix(i) == label)
    end
    output = output'; % transpose outputs for nntool
end