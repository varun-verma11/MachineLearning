%
% Create a network
%
% Layers is an array of numbers - each number is the number of neurons for
% the current layer. The length of layers is the number of layers.
%
% Topology = 1 -> create a feed forward network
% Topology = 2 -> create a fit network
% Topology = 3 -> create a cascase forward network
%
function net = createNetwork(layers, trainingInstances, ...
    trainingLabels, topology, trainingEpochs, trainingFunction)

    % Create a feed forward tolopology network
    if (topology == 1)
        net = feedforwardnet(layers);
        
    % Create fit net topology network
    elseif (topology == 2)
        net = fitnet(layers);
        
    % Create a cascade forward topology network
    else
        net = cascadeforwardnet(layers);
    end
    
    % Configure the network for training
    net = configure(net, trainingInstances, trainingLabels);
    
    % Is there anything wrong with the default value?!?!
    %net.divideFcn = 'dividetrain';
   
    % Configure training
    net.trainParam.epochs = trainingEpochs;
    net.trainFcn = trainingFunction;
    net.trainParam.showWindow = false; % Always false
    
    % Train the network
    net = train(net, trainingInstances, trainingLabels);
end