function prediction = getPredictions(net, x2, type_of_network)
    if type_of_network==0
        prediction = NNout2labels(sim(net,x2));
    else
        prediction = NNout2labels(sim(net,x2));
    end
end