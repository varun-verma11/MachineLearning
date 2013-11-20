function net = createNetwork(layers,training_instances, training_labels,topology)
    if (topology==1)
        net = feedforwardnet(layers);
    elseif (topology==2)
        net = fitnet(layers);
    else
        net = cascadeforwardnet(layers);
    end
    net = configure(net, training_instances, training_labels); 
    net.divideFcn = 'dividetrain';
    %net.trainParam.epochs = 50;
    
    net.trainParam.showWindow = false;
    %net = train(net,training_instances, training_labels);
end