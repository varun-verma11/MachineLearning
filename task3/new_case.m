function [ new_c ] = new_case( active_AUs, label )
% constructs a new case from a list of active AUs and the corresponding
% label
new_c = struct('problem', active_AUs,...
                  'solution', label,...
                  'typicality', 1);
end

