function [indices] = cross_validation ()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

K = 10
[x, y] = load_data(1)
N = size(y)

indices = crossvalind('Kfold', N, K)

for j=1:K
    test = (indices == i)
    train = ~test
end


end

