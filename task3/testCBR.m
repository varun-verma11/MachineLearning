function predictions = testCBR( cbr, testX )
%TESTCBR 
% generates predictions to the test cases in testX

    predictions = zeros(length(testX),1);
    
    for i = 1:length(testX)
        % constructs a new case from the test example
        new_c = build_case(testX(i, :), 0);
        
        % retrieve the most similar case from the cbr
        most_similar_case = retrieve(cbr, new_c);
        
        % solve the test example by reusing the most_similar_case
        solved_case = reuse(new_c, most_similar_case);
        
        % retain the solved case
        cbr = retain(cbr, solved_case);
        
        % add the solution to predictions
        predictions(i) = solved_case.solution;
    end
end

