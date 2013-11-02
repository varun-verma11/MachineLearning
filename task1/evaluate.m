function [trainedTree] = evaluate (datafile)
% Performs 10-fold cross validation
% INPUT
% filename of the input data file. e.g. 'cleandata_students.mat'
    K = 10;
    load (datafile);
    
    % Load the indices for 10 fold cross validation
    load (strcat(datafile, '_', num2str(K), '_fold_indices.mat'));

    % Start 10-fold cross validation
    for i = 1:K   
        [trainX, trainY, testX, testY] = ...
            get_data_from_fold (x, y, indices, i);
        trainedTree = tree_training (trainX, trainY);
        % predictions = testTrees(trainedTree, testX);
        % scoring_function(actual, predictions) = score (single float)
        % cv_score = scoring_function(predictions, testY)
    end
end

function [trainX, trainY, testX, testY] = ...
    get_data_from_fold (x, y, indices, index)
% Gets training and test data from x, and y using indices in fold i
        test = indices == index;
        train = ~test;
        testX = x(test, :);
        testY = y(test, :);
        trainX = x(train, :);
        trainY = y(train, :);
end

function [trainedTree] = tree_training (trainX, trainY)
% Trains tree for each emotion  
% INPUT 
% training datasets trainX and trainY
% OUTPUT
% an array of six trained tress, one for each emotion
    for j = 1:6
        binary_targets = load_data(trainY, j);
        attributes = 1:45;
        trainedTree(j) = ...
            decision_tree_learning(trainX, attributes, binary_targets);
    end 
end