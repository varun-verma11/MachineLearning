%
% Calculate the f alpha measure for the given actual labellings and
% predicted labellings for the given class and alpha.
%
function fa = f_alpha_measure_from_actual_and_predicted(alpha, class, ...
    actual, predicted)

    % Calculate the recall and precision rates from the class, actual
    % labellings and predicted labellings.
    [ recall_rate, precision_rate ] = ...
    recall_and_precision_rates_from_actual_and_predicted(class, ...
    actual, predicted);

    % Calculate fa measure.
    fa = f_alpha_measure(alpha, precision_rate, recall_rate);

end