function [ similarity ] = similarity_of_cases( case_one, case_two )
%SIMILARITY_OF_CASES Summary of this function goes here
%   Detailed explanation goes here
    vec1 = case_one.problem;
    vec2 = case_two.problem;
    similarity = similarity1(vec1, vec2);
%     similarity = similarity2(vec1, vec2);
end
