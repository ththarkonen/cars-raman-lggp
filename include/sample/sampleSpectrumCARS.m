function [ epsilon, ramanSpectrum, carsSpectrum, dataSpectrum, yPoints, outputObject] = sampleSpectrumCARS( outputLGGP, backgroundSettings)

    x = outputLGGP.x;
    nData = length( x );
    A_j = 1 + 0.5 * rand();

    [ramanSpectrum, alpha, beta, amplitude] = sampleRaman( outputLGGP );
    [epsilon, yPoints] = sampleBackground( x, backgroundSettings );
    
    nonExtendedInds = (nData + 1):( 2 * nData );
        
    realPart = -hilbert( ramanSpectrum );
    realPart = imag( realPart );
    realPart = realPart( nonExtendedInds );

    imaginaryPart = 1i * ramanSpectrum;
    imaginaryPart = imaginaryPart( nonExtendedInds );

    ramanSpectrum = ramanSpectrum( nonExtendedInds );
    carsSpectrum = abs( A_j + realPart + imaginaryPart ).^2;
    dataSpectrum =  epsilon .* carsSpectrum;

    minEpsilon = min( epsilon );
    maxEpsilon = max( epsilon );
    intervalEpsilon = maxEpsilon - minEpsilon;

    ramanBackground = 0.2 * ( epsilon - minEpsilon ) / intervalEpsilon;
    ramanSpectrumBg = ramanSpectrum + ramanBackground;
    
    beta = beta( nonExtendedInds );
    betaNormalized = beta / max( beta );

    outputObject = {};
    outputObject.cars = dataSpectrum;
    outputObject.alpha = alpha;
    outputObject.beta = betaNormalized;
    outputObject.amplitude = amplitude;
    outputObject.raman = ramanSpectrumBg;
    outputObject.background = ramanBackground;
    outputObject.epsilon = epsilon;
end