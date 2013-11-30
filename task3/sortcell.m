function Y = sortcell(X, DIM)
% SORTCELL    Sort a cell array in ascending order.
%
% Description: SORTCELL sorts the input cell array according to the
%   dimensions (columns) specified by the user.

ndim = length(DIM);
if ndim > 1
	col = DIM(2:end);
	X = sortcell(X, col);
end

% Get the dimensions of the input cell array.
[nrows, ~] = size(X);

% Retrieve the primary dimension (column) to be sorted.
col = DIM(1);
B = X(:,col);

a = cellfun('isclass', B, 'char');
suma = sum(a);
b = cellfun('isclass', B, 'double');
sumb = sum(b);

if suma == nrows
% Check to see if cell array 'B' contained only numeric values.
elseif sumb == nrows
  % If the cells in cell array 'B' contain numeric values retrieve the cell
  % contents and change 'B' to a numeric array.
  B = [B{:}];
else
	error('This column is mixed so sorting cannot be completed.');
end

% Sort the current array and return the new index.
[~,ix] = sort(B);

Y = X(ix,:);