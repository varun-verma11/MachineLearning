function [ most_similar_case ] = retrieve( cbr, case_to_find )
%RETRIEVE Summary of this function goes here
%   Detailed explanation goes here
% we use k-nearest neighbour learning adn consider the 2 most clostest
% neighbour

    k = 2;

    % obtain list of au's to match
    aus_list = case_to_find.problem;

    % find all clusters which have cases which might match and obtain all cases
    % and find the cases which match within them
    best_cases = [];
    for i = 1:length(cbr.clusters)
        if(isstruct(cbr.clusters{i}))
            matches = intersect(cbr.clusters{i}.index, aus_list);
            if (~isempty(matches))
                cases_to_consider_list = cbr.clusters{i}.cases;
                for n = 1:length(cases_to_consider_list)
                    if (~isempty(intersect(cases_to_consider_list(n).problem, aus_list)))
                        best_cases = vertcat(best_cases, cases_to_consider_list(n));
                    end
                end
            end
        end
    end

    %find the case with the highest similarity using knn algorithm, initially
    %we set most similar case to a new case and if, a good match found we set 
    %it to that 
    most_similar_case = struct('problem',[],'solution',0,'typicality',1);
    if ( ~isempty(best_cases))
        % find the best matching case
        num_of_cases = length(best_cases);
        match_list = cell(num_of_cases, 2);

        for i=1:num_of_cases
            similarity_value = similarity_of_cases(case_to_find, best_cases(i));
            match_list{i,1} = best_cases(i);
            match_list{i,2} = similarity_value;
        end

        most_similar_case = find_knn(match_list,k);
    end
end

function [ matched_case ] = find_knn( match_list, k )
    % order the matching_cases in descending order to the similarity value
    match_list = reverse(sortcell(match_list, 2));

    %need at least k elements in the list of best matches
    length_of_list = length(match_list);
    k = min(k, length_of_list);

    %reduce the list to k elements
    if (length_of_list > k && match_list{k, 2} == match_list{k+1, 2})
        reduced_list = reduce(match_list,k);
    else
        % take first k elements of match list
        reduced_list = match_list(1:k, :);
    end

    % find out the solutions of each of the k best cases
    outputs_for_cases = zeros(1,6);
    for i=1:k
        target = reduced_list{i,1}.solution;
        outputs_for_cases(target) = outputs_for_cases(target) + 1;
    end

    % get all indices of the most common values
    common_labels = get_most_common_indices(outputs_for_cases);
    cases_with_common_labels = {};

    if (length(common_labels) == 1)
        most_common_val = common_labels(1);
        % get all cases which have same solution
        for i = 1:k
            if(reduced_list{i,1}.solution == most_common_val)
                cases_with_common_labels = vertcat(...
                    cases_with_common_labels, reduced_list(i, :));
            end
        end
    else
        % Since there's a tie in the most common solution we obtain each of
        % the cases which have values equal to any of the tie values in knn
        for i = 1:k
            if( ~isempty(find(...
                    common_labels==reduced_list{i,1}.solution, 1)))
                cases_with_common_labels = vertcat(...
                    cases_with_common_labels, reduced_list(i, :));
            end
        end
    end

    best_similar_indices = get_most_common_indices(cell2mat(...
        cases_with_common_labels(:,2)));
    size_of_best = length(best_similar_indices);

    if (size_of_best == 1)
        %one best matched case so we return that
        matched_case = cases_with_common_labels{1,1};
    else
        %more than one best matched case so we return the most typical one
        typicalities = zeros(1, size_of_best);
        for i = 1:size_of_best
            typicalities(i) = reduced_list{i,1}.typicality;
        end
        best_typ_index = get_most_common_indices(typicalities);
        size_of_max_typ = length(best_typ_index);

        if (size_of_max_typ==1)
            % only one most typical case
            matched_case = reduced_list{best_typ_index(1),1};
        else
            % since more than one mose typical case, so we pick a random
            % one
            matched_case = reduced_list{best_typ_index( ...
                randomval(size_of_max_typ)),1};
        end
    end
end

function [ res ] = reverse(x)
    % reverse an array
    size = length(x);
    for i = size:-1:1
        res(size-i+1,:) = x(i,:);
    end
end

function [ res ] = get_most_common_indices(x)
% used to find index of most common target in given array
    res = find(x==max(x));
end

function [ res ] = randomvals(bound, num)
% generates multiple random values within the bounds [1,bound]
    assert(num > 0 && bound >= num);
    res = zeros(1, num);
    while (num ~= 0)
        temp = randomval(bound);
        if (isempty(res(res == temp)))
            res(num) = temp;
            num = num - 1;
        end
    end
end

function [ res ] = randomval(bound)
% generate single random value from 1 to bound inclusive
    res = 1 + floor(bound*rand);
end

function [ reduced_list ] = reduce( match_list, k )
% used when k'th element in the most similar case has same outcome as k+1
    similarity_values = cell2mat(match_list(:,2));
    value = match_list{k, 2};
    %put the elemenets which have higher value than where tie occurs
    reduced_list = match_list(similarity_values > value, :);
    [ num_existing, ~ ] = size(reduced_list);

    num_of_tie_elements = k - num_existing;
    assert( num_of_tie_elements > 0 );

    % get list of cases which have same values as tie vale
    list_to_reduce = match_list(similarity_values == value, :);
    num_to_choose_from = length(list_to_reduce);
    list_by_typicality = cell(num_to_choose_from, 2);

    % obtain array according to typicality 
    for i = 1:num_to_choose_from
        list_by_typicality{i, 1} = list_to_reduce{i, 1};
        list_by_typicality{i, 2} = list_to_reduce{i, 1}.typicality;
    end
    
    % sort list by typicality in descending order
    list_by_typicality = reverse(sortcell(list_by_typicality, 2));

    if (list_by_typicality{num_of_tie_elements, 2} == ...
            list_by_typicality{num_of_tie_elements+1, 2})
        similarity_values = cell2mat(list_by_typicality(:,2));
        value = list_by_typicality{num_of_tie_elements, 2};

        % add elements to reduced list by typicality value first
        reduced_list = vertcat(reduced_list, ...
            list_by_typicality(similarity_values > value, :));

        % recheck whether more elements are needed to be removed from reduced list
        [ num_existing, ~ ] = size(reduced_list);
        num_of_tie_elements = k - num_existing;

        if (num_of_tie_elements > 0)
            % still not enough - select at random
            list_to_reduce = list_by_typicality(similarity_values == value, :);
            [ num_to_choose_from, ~ ] = size(list_to_reduce);
            reduced_list =...
                vertcat(reduced_list,...
                list_by_typicality(...
                randomvals(num_to_choose_from, num_of_tie_elements),:));

            [ num_existing, ~ ] = size(reduced_list);
            assert(num_existing == k);
        end
    end
end