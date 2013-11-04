function [predictions] = evaluate (datafile)
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
        predictions = testTrees(trainedTree, testX);
        fprintf('\nconfusion matrix for fold %d\n',i);
        display(confusion_matrix(testY, predictions));
        %for j = 1:6
        %    fprintf('\nf alpha(1) for class %d in fold %d\n',j,i);
        %    display(f_alpha_measure_from_actual_and_predicted(1,j,testY, predictions));
        %end
        crate = sum(predictions == testY)/length(testY);
        display(crate);
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

function[result] = testTrees(trainedTrees, testX)
    result = zeros(length(testX),1);
    avgSims = zeros(6,1);
    data = load('cleandata_students.mat');
    for i = 1:6
        avgSims(i) = averageSim(1,data.x,data.y);
    end
    for i = 1:length(testX)
        result(i) = getResultFromTreesVer2('cleandata_students.mat',trainedTrees, testX(i,:),avgSims);
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
