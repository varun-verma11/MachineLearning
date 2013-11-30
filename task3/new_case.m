function [ new_c ] = new_case( active_AUs, label )

assert(label >=1 && label <= 6);
new_c = struct('problem', active_AUs,...
                  'solution', label,...
                  'typicality', 1);
end

