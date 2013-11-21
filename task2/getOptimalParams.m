function [layers, trainingFunction, topology] = getOptimalParams()
    training_functions = {'trainbfg','traincgb','traincgf','traincgp','traingda','traingdm','traingdx','trainlm','trainoss','trainrp','trainscg'};
    % We will find the best number of layers, the best number of neurons in
    % each layer, training functions and best topology
    best_n = 3;
    best_err = 1;
    best_topology = 4;
    best_training_function = '';
[trainX, trainY, testX, testY] = get_data_from_fold (instances, labels, index, 1);
        %Optimise parameter in first fold
  
            % Nested K-fold here where K=3
            ind = crossvalind('Kfold', size(trainX,1), 3);
            for j = 1:3    
                [trainX_, trainY_, validX, validY] = get_data_from_fold (trainX, trainY, ind, j);
                    [tX,tY] = ANNdata(trainX_,trainY_);
                    [vX,vY] = ANNdata(validX,validY);
                if(type~=0)
                    %make the labels trainnable
                    tY = transpose(load_data(trainY_,type));
                    validY = transpose(load_data(validY,type));
                end
                best_n_in_this_subfold = 3;
                best_err_in_this_subfold = 1;
                best_training_function_in_this_subfold = '';
                best_topology_in_this_subfold = 4;
                %Train topology, for 1-3 see createNetwork
                for t=3:3
                    %optimise first hidden layers max 3 neturons in this layer
                    for a=3:3   %1
                            % optimise second layers as well 
                            for b=3:3 % 0
                                %optimise third layers
                               for c=3:3  %0
                                    layers = [a,b,c];
                                    temp_n = layers(layers~=0);
                                    best_training_function_local = '';
                                    best_net_err_local = 1;
                                    % optimise training funciton
                                    for z = 1 : length(training_functions)
                                        %create a network
                                        temp_net = createNetwork(temp_n,tX,tY,t);
                                          % configure parameters for the nueral network
                                            DDF = 'divideind';
                                            temp_net.divideFcn = DDF;
                                     
                                            temp_net.trainParam.epochs = 100;
                                            temp_net.trainParam.show = 5;
                                            temp_net.trainParam.lr = 0.001;
                                            size_t_y = length(trainY);
                                            temp_net.divideParam.trainInd = 1:size_t_y;
                                            temp_net.divideParam.valInd   = size_t_y+1:length(validY)+size_t_y;
                                            [ann_trained, ann_para] = train(temp_net, horzcat(tX,vX), horzcat(tY,vY));
                                            %fprintf('Error Rate: %d', error_rate);
                                            display(ann_para.best_perf);
                                        %caculate error rate 
                                            temp_err = ann_para.best_perf;
                                            %temp_err = findErrorRate(getPredictions(temp_net, vX, type),validY);
                                        if(temp_err < best_net_err_local)
                                            best_training_function_local = training_functions{z};
                                            best_net_err_local = temp_err;
                                        end
                                    end
                                    %save the best error in subfold
                                    if( best_net_err_local<best_err_in_this_subfold)
                                        best_err_in_this_subfold=best_net_err_local;
                                        best_n_in_this_subfold = temp_n;
                                        best_topology_in_this_subfold = t;
                                        best_training_function_in_this_subfold = best_training_function_local;
                                    end 
                                end
                            end
                    end
                end
                display(best_n_in_this_subfold);
                fprintf('\nIn subfold %d, best training function is %s and best topology is %d with error rate %d in validation set\n',j,best_training_function_local,best_topology_in_this_subfold,best_err_in_this_subfold);
                %save the best net
                if(best_err_in_this_subfold<best_err)
                        best_err = best_err_in_this_subfold;
                        best_n= best_n_in_this_subfold;
                        best_topology =  best_topology_in_this_subfold;
                        best_training_function = best_training_function_in_this_subfold;
                end
            display(best_n);
            fprintf('\nIn conclude, best training function is %s and best topology is %d with error rate %d in validation set\n',best_training_function,best_topology,best_err);
 end