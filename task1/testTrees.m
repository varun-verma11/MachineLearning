function predictions = testTrees(trainedTrees, testX)
% version specifies the way we use for tree combination
% version 1 is the random method
% version 2 is the likelihood method
    predictions = zeros(length(testX),1);
    
    % Note to THs: change approach here.
    version = 2;
    
    if (version == 2)  
       avgSims = zeros(6,1);
       data = load('cleandata_students.mat');
       for j = 1:6
            avgSims(j) = averageSim(j,data.x,data.y);
       end
    end
  
    for i = 1:length(testX)
        if (version == 1)
            predictions(i) = getResultFromTreesVer1(trainedTrees, testX(i,:));
        else if (version == 2)
            predictions(i) = getResultFromTreesVer2 ...
               ('cleandata_students.mat',trainedTrees, testX(i,:),avgSims);
            end
        end
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
       data = load(datafile);
        maxi = averageSimForNewInstance(1,data.x,data.y,instance);
        class = 1;
        for i=2:6
            if(averageSimForNewInstance(i,data.x,data.y,instance)>maxi)
                class=i;
            end
        end
        result = class;
    elseif(length(classes)==1)
            result = classes(1);
    else
         likelihoods = zeros(length(classes),1);
         % calculate the likelihood of the classes which are assigned 
         for i= 1:length(classes)
            likelihoods(i) = likelihood(datafile, classes(i), ...
                instance,avgSims(i));
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

function[result] = averageSimForNewInstance(class,X,Y,I)
    average = 0;
    counter = 0;
    for i = 1: length(Y)
        if(Y(i)==class)
            average = average+ findcosSimilarity(I,X(i,:)); 
            counter = counter+1;

        end  
    end
    if(counter >0)
        result = average/counter;
    else
    result = 0;
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
    sim = dot(instance,compare)/...
        ((dot(instance,instance)*dot(compare,compare))^0.5);
end