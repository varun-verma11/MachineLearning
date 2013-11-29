function [ new_case ] = new_case( example, target )

% safety check: elements in example are in range [0,1]
assert(isempty(example(example<0)));
assert(isempty(example(example>1)));

% generate indices of non-zero elements
indices_of_ones = find(example);

new_case = struct('problem-description', indices_of_ones,...
                  'solution', target,...
                  'typicality', 1);

end

