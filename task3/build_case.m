function [ new_c ] = build_case(example, label)
% Constructs a new case from an example and label

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
