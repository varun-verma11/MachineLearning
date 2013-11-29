function [ cbr ] = retain( cbr, case_to_add )
%RETAIN 
%- The following code is copied from the reference project
% need to rewrite

    exists = 0;

    % attempt to find the case within existing CBR
    for i = 1:length(cbr.clusters)
        if (exists == 1)
            break;
        end
        for j = 1:length(cbr.clusters{i}.cases)
            if (exists == 1)
                break;
            end
            existing_case = cbr.clusters{i}.cases(j);
            if (isequal(existing_case.problem, the_case.problem))
                % found identical case - update case appropriately
                % increment typicality if it already exists in CBR
                existing_case.typicality = existing_case.typicality + 1;

                % take new case's solution as long as it is not UNSOLVED
                if (the_case.solution ~= 0)
                    existing_case.solution = the_case.solution;
                end

                % update flag to indicate case found
                exists = 1;
            end
        end
    end

    % encountered entirely new case
    if (exists == 0)
        % sanity check: cases cannot be unsolved
        assert(the_case.solution > 0);

        % find appropriate cluster
        case_emotion_no = the_case.solution;
        % update cluster info with new case data
        cbr.clusters{case_emotion_no}.cases =...
            [cbr.clusters{case_emotion_no}.cases; the_case];
        % merge cluster index with new case problem
        cbr.clusters{case_emotion_no}.index =...
            union(cbr.clusters{case_emotion_no}.index, the_case.problem);
    end
    
end

