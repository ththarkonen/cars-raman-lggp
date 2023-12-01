function [background, yPoints] = sampleBackground( x, backgroundSettings )

    nData = length( x );

    yStart =  random( backgroundSettings.start );
    yEnd = random( backgroundSettings.end );
    yPoints = [ yStart; yEnd];

    xStart = x(1);
    xEnd = x(end);

    xData = [ xStart; xEnd];
    yData = [ yStart; yEnd];

    thetaChain = backgroundSettings.theta;

    nChain = size( thetaChain, 1);
    randomIndex = randsample( nChain, 1);
    
    theta = thetaChain( randomIndex, :);
    
    [ mu, ~, K] = createPredictions( xData, yData, x, theta);

    K = K + 0.0000000001 * eye( nData, nData);

    L = chol( K );
    w = randn( nData, 1);
    background = mu + L' * w;
    background = background - mean( background ) + 1;
end