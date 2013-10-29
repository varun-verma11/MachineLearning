function [ x, y ] = load_data( desired_label )
% function for Loading Data
% This function takes in a label of the emotion for which the decision 
% tree is to be trained, and returns the remapped clean data [x,y].

%var x = load('cleandata_students.mat')
matObj = matfile('cleandata_students.mat')
x = matObj.x
y = matObj.y
N = size(y)

for i=1:N
    y(i) = y(i) == desired_label
end

end

