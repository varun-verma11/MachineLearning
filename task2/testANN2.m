function prediction = testANN(net, x2)
     % make histogram for output j
    load('cleandata_students.mat');
    [training_x,training_y] = ANNdata(x,y);
    net.trainParam.epochs = 100;
    net = train(net,training_x,training_y);
    predict_y = sim(net,x2);
    
    for i=1:6
        fprintf('hi\n');
        [a,b,c] = combine_result_helper(net,training_x,y,i);
        fprintf('a:%d, b:%d, c:%d',a,b,c);
         for j=1:length(predict_y(i,:))
             y_ =  predict_y(i,j);
             if predict_y(i,j)<=0.1
                predict_y(i,j) = a*predict_y(i,j)^b;
             else
                 predict_y(i,j) = c*(predict_y(i,j) - 0.1) + a*0.1^b;
             end
             predict_y(i,j) = (2/3)*y_ + (1/3)*predict_y(i,j);
         end
    end
    prediction =  (predict_y);
end

function [a,b,c] = combine_result_helper(net,training_x,training_y,j)
    % make histogram for output j
    %load('cleandata_students.mat');
    predict_y = sim(net,training_x);
    freqs = zeros(1,10);
    for i = 1:length(predict_y)
            temp = predict_y(:,i);
            if(training_y(i) == j)
                freqs(floor(temp(j))+1) =  freqs(floor(temp(j))+1)+1;
            end
    end
    a= log(freqs(1));
    b=0;
    [c,] = linear_regression(0.1:0.1:1,freqs(1:10));
end

function [a,b] = linear_regression(x,y)
n = length(x);
a = (n*sum(x.*y)-sum(x)*sum(y))/(n*sum(x.^2)-(sum(x))^2);
b = mean(y) - a*mean(x);
end