% type = 0 -> train 1 netural network, 6 outputs
% type = 1:6 ->  train 1 netural network for emotion "type" and it has 1
% outputs only (1/0)
% Here, just input x,y don't need to use ANNdata
% Output the best network
function [result] = cross_validation(instances, labels, index, K, type)
    % K-fold
    for i = 1:K   
        [trainX, trainY, testX, testY] ...
            = get_data_from_fold (instances, labels, index, i);
        %normal K-fold
        [testX_,testY_] = ANNdata(testX,testY);
        [train_X,train_Y] = ANNdata(trainX,trainY);
        if(type~=0)
                testY_ = transpose(load_data(testY,type));
                train_Y = transpose(load_data(trainY,type));
        end

        net = createNetwork(best_n,train_X,train_Y,best_topology);
        net.trainFcn = best_training_function;
        net = train(net,train_X, train_Y);

        %display(length(testX_));
        %display(length(testY_));
        %display(testY_(1));
        %display(1 - mse(net, train_X, train_Y));
        %predictions = getPredictions(net, testX_,type);
        predictions = testANN(net, testX); 
        display(1-findErrorRate(predictions, testY));
            
    end
    %return a network that trains on the entire data set 
    result = createNetwork(best_n, instances,labels, best_topology);
    result.trainFcn = best_training_function;
    result.trainParam.epochs = 100;
    result.trainParam.showWindow = false;
    result = train(result, instances, labels);
end