clear
close all

files = dir("./corrected/cars");
nFiles = length( files );

lggpObjects = [];

for ii = 6
    
    file_ii = files(ii);
    
    if( file_ii.isdir )
        continue;
    end
    
    filePath_ii = fullfile( file_ii.folder, file_ii.name);
    
    data_ii = load( filePath_ii );
    data_ii = data_ii.outputObject;
    
    result_ii = fitLGGP( data_ii.x(1:2:end), data_ii.imChi3(1:2:end));
    lggpObjects = [ lggpObjects; result_ii];

    plot( data_ii.x, data_ii.imChi3);
end

save("./models/lggp/lggpCars.mat", "lggpObjects")