function evaluate (datafile)
% Performs 10-fold cross validation
% INPUT
% filename of the input data file. e.g. 'cleandata_students.mat'
    K = 10;
    load (datafile);
    
    % Load the indices for 10 fold cross validation
    load (strcat(datafile, '_', num2str(K), '_fold_indices.mat'));
    
    % Initialise average confusion matrix
    avg_c_matrix = zeros (6, 6);
    
    % Initialise classification rate
    avg_classification_rate = 0;
    
    % Start 10-fold cross validation
    for i = 1:K   
        [trainX, trainY, testX, testY] = ...
            get_data_from_fold (x, y, indices, i);
        trainedTree = tree_training (trainX, trainY);
        
        %trainedTree_title = ...
        %     strcat(datafile, '_fold_', num2str(i),'_trainedTree.mat');
        %save(trainedTree_title, 'trainedTree');
         
        % Get predictions from trainedTree using method with version
        predictions = testTrees(trainedTree, testX); 
        %predictions_title = ...
        %    strcat(datafile, '_fold_', num2str(i), ...
        %    '_version_', num2str(version),'_predictions.mat');
        %save(predictions_title, 'predictions');
        
        c_matrix = confusion_matrix(testY, predictions);
        %c_matrix_title = ...
        %    strcat(datafile, '_fold_', num2str(i),...
        %    '_version_', num2str(version), '_confusion_matrix.mat');
        %save(c_matrix_title, 'c_matrix');
        avg_c_matrix = avg_c_matrix + c_matrix;
        
        avg_classification_rate = ...
            avg_classification_rate + ...
            sum(predictions == testY)/length(testY);
    end
   
    display(datafile);
    display(version);
    
    % calculate the average confusion matrix
    avg_c_matrix = avg_c_matrix/10;
    display(avg_c_matrix); 
    %save(strcat(datafile, '_version_', num2str(version),...
    %    '_average_confusion_matrix.mat'), 'avg_c_matrix');
    
    % calculate the average recall and precision rate per class
    % from the average confusion matrix
    % calculate fa measure with recall and precision rates evenly weighted
    class_r_p_rate_fa = calculate_r_p_rate_fa(avg_c_matrix);
    %save(strcat(datafile, '_version_', num2str(version),...
    %    '_r_p_rate_fa_per_class.mat'), 'class_r_p_rate_fa');
    
    % calculate the average classification rate
    avg_classification_rate = avg_classification_rate/10;
    display(avg_classification_rate);
    %save(strcat(datafile, '_version_', num2str(version),...
    %    '_avg_classification_rate.mat'), 'avg_classification_rate');
end

function result = calculate_r_p_rate_fa(confusion_matrix)
% calculate the recall and precision rates
% from a confusion matrix
% calculate fa measure with recall and precision rates evenly weighted
    num_class = size(confusion_matrix,1);
    for class=1:num_class
        true_positives = confusion_matrix(class,class);
        false_positives = sum(confusion_matrix(:, class)) - true_positives;
        false_negatives = sum(confusion_matrix(class, :)) - true_positives;  
        [recall_rate, precision_rate] = recall_and_precision_rates...
            (true_positives, false_positives, false_negatives);     
        
        fa = f_alpha_measure(1, precision_rate, recall_rate);
        
        result(class).class = class;
        result(class).recall_rate = recall_rate;
        result(class).precision_rate = precision_rate;
        result(class).fa_measurea = fa;
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