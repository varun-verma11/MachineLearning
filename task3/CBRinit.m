function [ cbr ] = CBRinit(examples, labels)
%CBRINIT 
% Implement a CBR system

    % checks that the dimensions of examples and labels are correct
    check_input(examples, labels);
    
    % gets the number of clusters i.e. number of emotions
    num_clusters = length(unique(labels));
    
    % creates a new cbr with 6 empty clusters
    % each cluster contains an empty case_list
    cbr = new_CBR(num_clusters);
    
    N = length(examples);
    % adds each example to the cbr
    for i = 1:N
       % Constructs a new case from the ith example and label
       new_c = get_ith_new_case(examples(i, :), labels(i,:));
       cbr = CBRadd(cbr, new_c);
    end  
end

function [ cbr ] = new_CBR( num_clusters )
 % creates a new cbr with empty clusters
    %cbr.clusters = {};
    for i = 1:num_clusters
        cbr.clusters{i} = new_case_list(i);
    end
end

function [case_list] = new_case_list(emotion_index)
% creates a new list to contain cases for a emotion
    case_list = struct('label', emolab2str(emotion_index),...
                       'cases', [],...
                       'index', []);
end

function check_input(examples, labels)
% checks that the dimensions of examples and labels are correct
    [examples_rows, examples_cols] = size(examples);
    [labels_rows, labels_cols] = size(labels);
    assert(examples_rows == labels_rows);
    assert(examples_cols == 45);
    assert(labels_cols == 1);
end

function [ new_c ] = get_ith_new_case(example, label)
% Constructs a new case from the ith example and label
    % checks that the label is within range
    assert(label >=1 && label <= 6);
    % obtains the indices for the active AUs
    active_AUs = get_active_AUs(example);

    new_c = new_case(active_AUs, label);
end

function [ active_AUs ] = get_active_AUs(example)
% takes in a [1*45] binary AU vector and 
%returns an vector that contains the active AUs

   % check all elements are either 0 or 1
   assert(isempty(example(example<0)));
   assert(isempty(example(example>1)));
   
   % generate indices of non-zero elements
   active_AUs = find(example);
end