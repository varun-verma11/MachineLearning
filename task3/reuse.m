function [ case_solved ] = reuse( new_case, previous_case )
%REUSE Summary of this function goes here
%   Detailed explanation goes here

    case_solved = new_case;
    case_solved.solution = previous_case.solution;
end

