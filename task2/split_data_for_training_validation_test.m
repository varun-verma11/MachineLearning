function [training_examples, training_targets, validation_examples,...
    validation_targets, test_examples, test_targets]...
    = split_data_for_training_validation_test( examples, targets  )

    [examples, targets] = sort_data(horzcat(targets, examples));

    training_examples = examples(1:3:end,:);
    training_targets = targets(1:3:end);

    % shuffle matrix
    [ rows, ~ ] = size(training_targets);
    ix = randperm(rows);
    training_examples = training_examples(ix,:);
    training_targets = training_targets(ix);

    validation_examples = examples(2:3:end,:);
    validation_targets = targets(2:3:end);
    [ rows, ~ ] = size(validation_targets);
    ix = randperm(rows);
    validation_examples = validation_examples(ix,:);
    validation_targets = validation_targets(ix);

    test_examples = examples(3:3:end,:);
    test_targets = targets(3:3:end);
    [ rows, ~ ] = size(test_targets);
    ix = randperm(rows);
    test_examples = test_examples(ix,:);
    test_targets = test_targets(ix);

end

function [examples, targets] = sort_data(data)
% sort data according to target value
data = sort(data, 1);

% split data back into examples and targets
targets  = data(:,1);
[ ~, cols ] = size(data);
examples = data(:,2:cols);
end

