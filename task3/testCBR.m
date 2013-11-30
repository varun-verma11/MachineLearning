function [ predictions ] = testCBR( cbr, testX )
%TESTCBR 
% generates predictions to the test cases in testX

    for i = 1:length(testX)
        new_c = build_case(testX(i, :), 0);
        most_similar_case = retrieve(cbr, new_c);
        solved_case = reuse(new_c, most_similar_case);
        cbr = cbr.retain(cbr, new_c);
        predictions(i) = solved_case.solution;
    end
end

