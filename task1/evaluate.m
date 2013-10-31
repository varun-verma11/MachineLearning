function evaluate (datafile)
% Performs 10-fold cross validation
% INPUT
% filename of the input data file. e.g. 'cleandata_students.mat'
    K = 10;
    load(datafile);
    N = size(x,1);

    indices = crossvalind('Kfold', N, K);

    % Start 10-fold cross validation
    for i = 1:K   
        test = indices == i;
        train = ~test;
        testX = x(test, :);
        testY = y(test, :);
        trainX = x(train, :);
        trainY = y(train, :);

        trainedTree = tree_training (trainX, trainY);
        % predictions = testTrees(trainedTree, testX);
        % scoring_function(actual, predictions) = score (single float)
        % cv_score = scoring_function(predictions, testY)
    end

end

function [trainedTree] = tree_training (trainX, trainY)
% Train tree for each emotion  
% INPUT 
% training datasets x and y
% OUTPUT
% a cell array of six trained tress, each for an emotion
    for j = 1:6
        binary_targets = load_data(trainY, j);
        attributes = 1:45;
        trainedTree(j) = decision_tree_learning(trainX, attributes, binary_targets);
    end 
end