function sim = similarity(vec1,vec2)
sim=similarity1(vec1, vec2);
end
function sim = similarity1(vec1, vec2)
%cos-similarity
x1 = zeros(45,1);
x2 = zeros(45,1);
for i=1:length(vec1)
    x1(vec1(i)) = 1;
end
for i=1:length(vec2)
    x2(vec2(i)) = 1;
end
sim = findcosSimilarity(x1,x2);
end
function[sim] = findcosSimilarity(instance,compare)
    sim = dot(instance,compare)/...
        ((dot(instance,instance)*dot(compare,compare))^0.5);
end
function sim = similarity2(vec1, vec2)
    dist = sqrt(sum(~ismember(vec1,vec2))+sum(~ismember(vec2,vec1)));
    max_dist = sqrt(45);
    normalised_dist = dist/(max_dist);
    sim = (1-normalised_dist^3)^3;
end
function sim = similarity3(vec1, vec2)
    dist = sqrt(sum(~ismember(vec1,vec2))+sum(~ismember(vec2,vec1)));
    if dist>0
        sim = 1/(dist^2);
    else
        sim = 1;
    end
end