function [ updated_cbr ] = retain( cbr, new_solved_case )
%RETAIN 
% adds the new_solved_case to the cbr

updated_cbr = CBRadd(cbr, new_solved_case);

end

