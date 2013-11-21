%
% Getting the output of the neural using x2 as an input
%
function predictions = getPredictions(net, x2, typeOfNetwork)
    if(typeOfNetwork == 0)
        predictions = NNout2labels(sim(net,x2));
    else
        predictions = NNout2labels(sim(net,x2));
    end
end