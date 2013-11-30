function sim = similarity(vec1,vec2)
sim=similarity1(vec1, vec2);
end
function sim = similarity1(vec1, vec2)
%cos-similarity
if length(vec1) >= length(vec2)
    sim = sum(ismember(vec1,vec2))/length(vec1);
else
    sim = sum(ismember(vec2,vec1))/length(vec2);
end
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