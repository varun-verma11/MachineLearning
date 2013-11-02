function main () 
    draw_decision_trees_with_clean_data();

end

function draw_decision_trees_with_clean_data ()
% Use the clean dataset provided to train 6 trees, one for each emotion
% Save the visulation generated using the DrawDecisionTree function
    load ('cleandata_students.mat');
    for label=1:6
        binary_targets = load_data (y, label);
        attributes = 1:45;
        tree = decision_tree_learning(x, attributes, binary_targets);
        titletext = strcat (num2str(label), emolab2str(label),'_tree');
        DrawDecisionTree (tree, titletext);
    end
end