function main()
%MAIN entrypoint for the program

load('cleandata_students.mat');
cbr = CBRinit(x, y);
save('cbr_clean_data.mat', 'cbr');

end

