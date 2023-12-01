function [outputObject] = fitLGGP( x, y)

    includeFolders = genpath('include');
    addpath( includeFolders );

    xMin = min(x);
    xMax = max(x);
    xInterval = xMax - xMin;

    y = y - min(y);
    y = y + 0.01 * max(y);

    yMax = max( y );
    yNorm = y / yMax;
    
    nData = length( x );
    R = zeros( nData, nData);
    
    for ii = 1:nData
        for jj = 1:nData
    
            x_ii = x(ii);
            x_jj = x(jj);
    
            R(ii,jj) = abs( x_ii - x_jj );
        end
    end
    
    dataLGGP = struct();
    dataLGGP.Y = yNorm;
    dataLGGP.R = R;
    
    ssFun = @( theta, data) -2 * lggpLogLikelihood( data, theta, yNorm);
    
    model = struct();
    model.ssfun  = ssFun;
    model.sigma2 = 1.0;
    
    model.N = nData; 
    nIterations = 100000;
    
    optionsRAM.nsimu = nIterations;
    optionsRAM.updatesigma = 0;
    optionsRAM.waitbar = 1;
    optionsRAM.verbosity = 1;
    optionsRAM.method = 'dram';
    
    parameters = {
        {'Alpha:', 100, 0}
        {'Scale scaling C_theta:', 1 / 100, 0}
        {'Smoothing sigma:', 10, 1}
        {'GP constant mean:', 0}
        {'GP noise STD:', 0.1, 0}
        {'GP lenght scale:', 0.1 * xInterval, 0 xInterval, 2 * xInterval}
        {'GP signal STD:', 1, 0}
    };
    
    [ ~, chainDRAM] = mcmcrun( model, dataLGGP, parameters, optionsRAM);
    burnedChainDRAM = chainDRAM( 0.5*end:end, :);

    outputObject = {};
    outputObject.x = x;
    outputObject.y = y;

    outputObject.chain = chainDRAM;
    outputObject.burnedChain = burnedChainDRAM;
end