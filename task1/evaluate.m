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
function[result] = testTree(trainedTrees,testX)
    result = zeros(length(testX),1);
    for i = 1:length(testX)
        result(i) = getResultFromTreesVer1(trainedTrees,testX(i,:));
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
            % if the instance have the feature, go left
            result = getResultFromTree(tree.kids{1,1},instance);
        else
            %go right
            result = getResultFromTree(tree.kids{1,2},instance);
        end
    end
end

function[result] = getResultFromTreesVer1(trees,instance)
    results = zeros(length(trees),1);
    % get all results from different trees
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
        % randomly assign a class from the classes which is assigned
        result = classes(randi(length(classes)));
    end
end

function[result] = getResultFromTreesVer2(datafile,trees,instance)
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
                likelihoods(i) = likelihood(datafile, classes(i), instance);
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

function[prob] = likelihood(datafile, class, instance)
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
            flag = false;
            for j = 1:45
                if(instance(i) ~=x(i,:))
                    flag = true;
                    break;
                end
            end
            if(~flag)
               num = num + 1; 
            end
        end
    end
    if(tot_num_of_this_class>0)
        prob = num/tot_num_of_this_class;
    else
        prob = 0;
    end
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