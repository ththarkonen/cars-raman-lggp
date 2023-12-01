clear
close all

files = dir("./corrected/raman");
nFiles = length( files );

lggpObjects = [];

for ii = 1:nFiles
    
    file_ii = files(ii);
    
    if( file_ii.isdir )
        continue;
    end
    
    filePath_ii = fullfile( file_ii.folder, file_ii.name);
    
    data_ii = load( filePath_ii );
    data_ii = data_ii.outputObject;
    
    result_ii = fitLGGP( data_ii.x, data_ii.correctedSpectrum);
    lggpObjects = [ lggpObjects; result_ii];
end

save("./models/lggp/lggpRaman.mat", "lggpObjects")