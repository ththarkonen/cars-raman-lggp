function [ spectrum, alpha, beta, amplitude, normalizedIntensity] = sampleRaman( outputLGGP )

    x = outputLGGP.x;
    burnedChain = outputLGGP.burnedChain;

    nChain = size( burnedChain, 1);
    nData = length( x );

    xMin = min(x);
    xMax = max(x);
    xInterval = xMax - xMin;
    
    xExtended = linspace( xMin - xInterval, xMax + xInterval, 3 * nData)';
    n = length( xExtended );
    R = zeros( n, n);
    
    for ii = 1:n
        for jj = 1:n
    
            x_ii = xExtended( ii );
            x_jj = xExtended( jj );
    
            R( ii, jj) = abs( x_ii - x_jj );
        end
    end
    
    randomIndex = randsample( nChain, 1);
    theta = burnedChain( randomIndex, :);
    
    alpha = theta(1);
    C_beta = theta(2);
    
    mu = theta(4);
    s2 = 0.00000001 * theta(6); theta(5);
    lengthScale = theta(6);
    sf2 = theta(7);
    
    K = sf2 * sqrExpCovMatrix( R, lengthScale);
    K = K + s2 * eye( n, n);
    L = chol( K );  

    w = randn( n, 1);
    logIntensity = mu + L' * w;
    
    nonExtendedInds = (nData + 1):( 2 * nData );
    
    beta = C_beta * exp( logIntensity );
    normalizedIntensity = beta / max( beta( nonExtendedInds ) );

    spectrum = gamrnd( alpha, beta);
    amplitude = 0.3 * rand() + 0.2;

    spectrum = amplitude * spectrum / max( spectrum( nonExtendedInds ) );
end