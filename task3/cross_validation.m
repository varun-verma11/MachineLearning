function cross_validation (datafile, instances, labels,...
                                                index, K)
    version = 1;
                                            
    % Initialise average confusion matrix
    avg_c_matrix = zeros (6, 6);
    
    % Initialise classification rate
    avg_classification_rate = 0;
    
    % K-fold
    for i = 1:K   
        [trainX, trainY, testX, testY] ...
            = get_data_from_fold (instances, labels, index, i);
        
        % initialises a cbr with the training data
        cbr = CBRinit(trainX, trainY);
        
        % get predictions to the test data from the cbr
        predictions = testCBR(cbr, testX);
        
        % generate confusion matrix and classification rate for the fold
        c_matrix = confusion_matrix(testY, predictions);
        avg_c_matrix = avg_c_matrix + c_matrix;        
        avg_classification_rate = ...
            avg_classification_rate + ...
            sum(predictions == testY)/length(testY);
        
    end
    
    display(datafile);
    display(version);
    
    save(strcat(datafile, '_sim_', num2str(version),...
    '_avg_f_measure.mat'), 'avg_f_measure');
    
    % calculate the average confusion matrix
    avg_c_matrix = avg_c_matrix/10;
    display(avg_c_matrix); 
    save(strcat(datafile, '_sim_', num2str(version),...
        '_avg_confusion_matrix.mat'), 'avg_c_matrix');
    
    % calculate the average recall and precision rate per class
    % from the average confusion matrix
    % calculate fa measure with recall and precision rates evenly weighted
    recall_precision_f = calculate_r_p_rate_fa(avg_c_matrix);
    save(strcat(datafile, '_sim_', num2str(version),...
        '_avg_recall_precision_f.mat'), 'recall_precision_f');
    
    % calculate the average classification rate
    avg_classification_rate = avg_classification_rate/10;
    display(avg_classification_rate);
    save(strcat(datafile, '_sim_', num2str(version),...
        '_avg_classification_rate.mat'), 'avg_classification_rate');

end

