function [ cbr ] = CBRadd( cbr, case_to_add )
%CBRADD 
% adds the case_to_add to the cbr

    % flag that enables early exit when the case_to_add is added
    added = 0;
    % checks that the case_to_add has been solved
    assert(case_to_add.solution >=1 && case_to_add.solution <= 6);
    
    % retrieve the cluster that the case_to_add should belong to 
    % from the cbr
    case_cluster = case_to_add.solution;
    cluster = cbr.clusters{case_cluster};
    
    % compare with each case in the cluster to find an identical case
    for j = 1:length(cluster.cases)
        if (added == 1) 
            break;
        end
        existing_case = cluster.cases(j);
        if (isequal(existing_case.problem, case_to_add.problem))
            
            % found identical case - update existing case by
            %  - incrementing typicality
            %  - replacing the existing case's solution with the 
            %    case_to_add solution
            existing_case.typicality = existing_case.typicality + 1;
            existing_case.solution = case_to_add.solution;
            cluster.cases(j) = existing_case;
            % updates flag to indicate case added
            added = 1;
        end
    end
    
    % case_to_add is new
    if (added == 0)
        % adds the case_to_add into cluster
        cluster.cases = ...
            [cluster.cases; case_to_add];
        % merge cluster index with new case problem
        cluster.index =...
            union(cluster.index, case_to_add.problem);
    end
    
    % update cbr on the change
    cbr.clusters{case_cluster} = cluster;
end

