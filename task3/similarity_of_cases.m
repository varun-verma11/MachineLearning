function [ sim ] = similarity_of_cases(case_one, case_two)
%SIMILARITY_OF_CASES 
% computes the similarity value for case_one and case_two by
% comparing their problums (AUs)

sim = similarity(case_one.problem, case_two.problem);

end
