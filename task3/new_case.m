function [ new_case ] = new_case( example, target )

% check all elements are either 0 or 1
assert(isempty(example(example<0)));
assert(isempty(example(example>1)));

% generate indices of non-zero elements
indices_of_ones = find(example);

new_case = struct('problem-description', indices_of_ones,...
                  'solution', target,...
                  'typicality', 1);

end

