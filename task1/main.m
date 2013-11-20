function main () 
    draw_decision_trees_with_clean_data();
    
    K=10;
    % generate_K_fold_indices_for_file is only run once to 
    % generate the indices. 
    % Future evaluation is done using the generated indices directly.
    %generate_K_fold_indices_for_file ('cleandata_students.mat', K);
    %generate_K_fold_indices_for_file ('noisydata_students.mat', K);
    evaluate('cleandata_students.mat');
    evaluate('noisydata_students.mat');
end

function draw_decision_trees_with_clean_data ()
% Use the clean dataset provided to train 6 trees, one for each emotion
% Save the visualisation generated using the DrawDecisionTree function
    load ('cleandata_students.mat');
    for label=1:6
        binary_targets = load_data (y, label);
        attributes = 1:45;
        tree = decision_tree_learning(x, attributes, binary_targets);
        titletext = strcat (num2str(label), emolab2str(label),'_tree');
        save(titletext, 'tree');
        %DrawDecisionTree (tree, titletext);
    end
end