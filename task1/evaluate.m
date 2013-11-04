function evaluate (datafile, version)
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
    
    avgSims = zeros(6,1);
    if (version == 2)  
       data = load('cleandata_students.mat');
       for j = 1:6
            avgSims(j) = averageSim(j,data.x,data.y);
       end
    end
    
    % Start 10-fold cross validation
    for i = 1:K   
        [trainX, trainY, testX, testY] = ...
            get_data_from_fold (x, y, indices, i);
        trainedTree = tree_training (trainX, trainY);
        
        trainedTree_title = ...
             strcat(datafile, '_fold_', num2str(i),'_trainedTree.mat');
        save(trainedTree_title, 'trainedTree');
         
        % Get predictions from trainedTree using method with version
        predictions = testTrees(trainedTree, testX, version, avgSims); 
        predictions_title = ...
            strcat(datafile, '_fold_', num2str(i), ...
            '_version_', num2str(version),'_predictions.mat');
        save(predictions_title, 'predictions');
        
        c_matrix = confusion_matrix(testY, predictions);
        c_matrix_title = ...
            strcat(datafile, '_fold_', num2str(i),...
            '_version_', num2str(version), '_confusion_matrix.mat');
        save(c_matrix_title, 'c_matrix');
        avg_c_matrix = avg_c_matrix + c_matrix;
        
        avg_classification_rate = ...
            avg_classification_rate + ...
            sum(predictions == testY)/length(testY);
    end
     
    save(strcat(datafile, '_version_', num2str(version),...
        '_average_confusion_matrix.mat'), 'avg_c_matrix');
    
    display(datafile);
    display(version);
    
    % calculate the average confusion matrix
    avg_c_matrix = avg_c_matrix/10;
    display(avg_c_matrix); 
    
    % calculate the average recall and precision rate per class
    % from the average confusion matrix
    % calculate fa measure with recall and precision rates evenly weighted
    class_r_p_rate_fa = calculate_r_p_rate_fa(avg_c_matrix);
    %display(class_r_p_rate_fa);
    save(strcat(datafile, '_version_', num2str(version),...
        '_r_p_rate_fa_per_class.mat'), 'class_r_p_rate_fa');
    
    % calculate the average classification rate
    avg_classification_rate = avg_classification_rate/10;
    display(avg_classification_rate);
end

function result = calculate_r_p_rate_fa(confusion_matrix)
% calculate the recall and precision rates
% from a confusion matrix
% calculate fa measure with recall and precision rates evenly weighted
    num_class = size(confusion_matrix,1);
    %result = zeros (num_class, 4);
    for class=1:num_class
        true_positives = confusion_matrix(class,class);
        false_positives = sum(confusion_matrix(:, class)) - true_positives;
        false_negatives = sum(confusion_matrix(class, :)) - true_positives;  
        [recall_rate, precision_rate] = recall_and_precision_rates...
            (true_positives, false_positives, false_negatives);
        %display(class)
        %display(recall_rate);
        %display(precision_rate);       
        
        fa = f_alpha_measure(1, precision_rate, recall_rate);
        %display (fa);
        
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

function[result] = testTrees(trainedTrees, testX, version, avgSims)
% version specifies the way we use for tree combination
% version 1 is the random method
% version 2 is the likelihood method
    result = zeros(length(testX),1);
  
    for i = 1:length(testX)
        if (version == 1)
            result(i) = getResultFromTreesVer1(trainedTrees, testX(i,:));
        else if (version == 2)
            result(i) = getResultFromTreesVer2 ...
               ('cleandata_students.mat',trainedTrees, testX(i,:),avgSims);
            end
        end
    end
end


function[result] = averageSim(class,X,Y)
    average = 0;
    counter = 0;
    for i = 1: length(Y)
        if(Y(i)==class)
            avg = 0;
            count = 0;
            for j=1:length(Y)
                if(i ~= j && Y(i)==Y(j))
                    avg = avg+ findcosSimilarity(X(i,:),X(j,:)); 
                    count = count +1;
                end
            end
            if(count >0)
                counter = counter+1;
                avg = avg/count;
            end
            average =  average + avg;
        end
            
    end
    result = average/counter;
end

function[sim] = findcosSimilarity(instance,compare)
    sim = dot(instance,compare)/((dot(instance,instance)*dot(compare,compare))^0.5);
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

function[result] = getResultFromTree(tree,instance)
% walk through the tree to find out the result
    if(isempty(tree))
        error('tree is empty');
    end
    if(isempty(tree.kids))
        result  = tree.class;
    else
        if(instance(tree.op))  
            % if the instance have the feature, go right
            result = getResultFromTree(tree.kids{1,2},instance);
        else
            %go left
            result = getResultFromTree(tree.kids{1,1},instance);
        end
    end
end

function[result] = getResultFromTreesVer1(trees, instance)
    results = zeros(length(trees),1);
    % get all results from different trees
    for i = 1:length(trees)
        results(i) = getResultFromTree(trees(i), instance);
    end
    % find out which class(es) is(are) assigned
    classes = find(results==1);
    if(isempty(classes))
        % randomly assign a class
        result = randi(6);
    elseif(length(classes)==1)
        result = classes(1);
    else
        % randomly assign a class from the classes which is assigned
        result = classes(randi(length(classes)));
    end
end

function[result] = getResultFromTreesVer2(datafile,trees,instance,avgSims)
    results = zeros(length(trees),1);
    for i = 1:length(trees)
        results(i) = getResultFromTree(trees(i),instance);
    end
    % find out which class(es) is(are) assigned
    classes = find(results==1);
    if(isempty(classes))
        % randomly assign a class
        result = randi(6);
    elseif(length(classes)==1)
            result = classes(1);
    else
         likelihoods = zeros(length(classes),1);
         % calculate the likelihood of the classes which are assigned 
         for i= 1:length(classes)
            likelihoods(i) = likelihood(datafile, classes(i), instance,avgSims(i));
         end
         % find out which class(es) has max likelihood
         result_class_index = find(likelihoods==max(likelihoods));
         if(length(result_class_index)>1)
             % if we have classes also have max likelihood, randomly
             % reutrn 1
            rnd = randi(length(result_class_index));
            result = classes(rnd);
         else
            % return the class with max likelihood
            result = classes(result_class_index);
         end
    end
end

function[prob] = likelihood(datafile, class, instance, simTh)
% find out p(x|ci) here
% By conditional prob.  p(x|ci) = p(x^ci)/p(ci)
    data = load(datafile);
    x = data.x;
    y = data.y;
    if(length(x) ~= length(y))
        error('length is not the same');
    end
    tot_num_of_this_class = 0;
    num = 0;
    % here, i try to find out the conditional prob. using alternative
    % method by reducing the probrobility space.
    % and the conditional prob now = number of instances with x feature in
    % the reduced space/number of total instances in reduced space
    for i = 1:length(x)
        if(y(i)==class)
            tot_num_of_this_class = tot_num_of_this_class + 1;
            if(findcosSimilarity(instance,x(i,:))>=simTh)
                num = num+1;
            end
        end
    end
    if(tot_num_of_this_class>0)
        prob = num/tot_num_of_this_class;
    else
        prob = 0;
    end
end
