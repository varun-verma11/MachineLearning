function [ new_case ] = new_case( active_AUs, target )

new_case = struct('problem', active_AUs,...
                  'solution', target,...
                  'typicality', 1);

end

