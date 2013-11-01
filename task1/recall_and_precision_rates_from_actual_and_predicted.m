%
% Calculate the recall and precision rates for the given actual labellings
% and predicted labellings for the given class and alpha.
%
function [ recall_rate, precision_rate ] = ...
    recall_and_precision_rates_from_actual_and_predicted(...
    class, actual, predicted)

    % Calculate classification values.
    [true_positives, ~, false_positives, false_negatives] = ...
        classification_values(class, actual, predicted);

    % Calculate recall and precision rates.
    [ recall_rate, precision_rate ] = recall_and_precision_rates(...
        true_positives, false_positives, false_negatives);
    
end