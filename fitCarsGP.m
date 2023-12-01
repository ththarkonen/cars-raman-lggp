
clear
close all

files = dir("./corrected/cars");
nFiles = length( files );

theta = [];

for ii = 1:nFiles
    
    file_ii = files(ii);
    
    if( file_ii.isdir )
        continue;
    end
    
    filePath_ii = fullfile( file_ii.folder, file_ii.name);
    
    data_ii = load( filePath_ii );
    data_ii = data_ii.outputObject;
    
    minX = min( data_ii.x );
    maxX = max( data_ii.x );
    
    minY = min(data_ii.epsilon);
    maxY = max(data_ii.epsilon);
    
    rangeX = maxX - minX;
    rangeY = maxY - minY;
    midY = 0.5 * ( maxY + minY );
    
    nData_ii = length( data_ii.x );
    
    R_ii = zeros( nData_ii, nData_ii);

    for jj = 1:nData_ii
        for kk = 1:nData_ii

            x_ii_jj = data_ii.x(jj);
            x_ii_kk = data_ii.x(kk);

            R_ii(jj,kk) = abs( x_ii_jj - x_ii_kk );
        end
    end

    noise_ii = 0.025 * rangeY * randn( nData_ii, 1);
    
    dataGP_ii = {};
    dataGP_ii.X = data_ii.x;
    dataGP_ii.R = R_ii;
    dataGP_ii.f = data_ii.epsilon + noise_ii;

    ssFun = @(theta, data) -2 * computeGpLogLikelihood( data, theta);

    model = struct();
    model.ssfun  = ssFun;
    model.sigma2 = 1.0;

    model.N = nData_ii;

    options.nsimu = 100000;
    options.updatesigma = 0;
    options.waitbar = 1;
    options.verbosity = 0;
    options.method = 'dram';

    parameters = {
        {'Constant mean', midY, minY, maxY}
        {'Noise s2', 0.1, 0, 10}
        {'Length scale', 0.25 * rangeX, 0}
        {'Signal s2', 0.1, 0, 10}
    };

    [~, chain] = mcmcrun( model, dataGP_ii, parameters, options);
    
    burnedChain = chain( 0.5*end:end, :);
    theta = [ theta; burnedChain];
end

save("./models/bg/bgCars.mat", "theta");

