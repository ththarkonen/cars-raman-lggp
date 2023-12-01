
clear
close all

backgroundSettings = {};
backgroundSettings.start = makedist( "Uniform", 0.90, 1.10);
backgroundSettings.end = makedist( "Uniform", 0.90, 1.10);

bgData = load("models/bg/bgRaman.mat");
% bgData = load("models/bg/bgCARS.mat");

lggpData = load("models/lggp/lggpRaman.mat");
% lggpData = load("models/lggp/lggpCars.mat");

backgroundSettings.theta = bgData.theta;
lggpObjects = lggpData.lggpObjects;

nData = 640;
nLGGP = length( lggpObjects );

nSpectra = 1000;
carsData = zeros( nSpectra, nData);
imChi3Data = zeros( nSpectra, nData);
ramanData = zeros( nSpectra, nData);

background = zeros( nSpectra, nData);
epsilon = zeros( nSpectra, nData);

amplitude = zeros( nSpectra, 1);
alpha = zeros( nSpectra, 1);
amplitudeAlpha = zeros( nSpectra, 2);
beta = zeros( nSpectra, nData);

figure();

tic
for ii = 1:nSpectra

    randomIndex = randsample( nLGGP, 1);
    outputLGGP = lggpObjects( randomIndex )

    x = outputLGGP.x;

    minX = min(x);
    maxX = max(x);
    
    xNew = linspace( minX, maxX, nData);
    outputLGGP.x = xNew(:);

    [ epsilon_ii, ramanSpectrum_ii, carsSpectrum, dataSpectrum_ii, yPoints, spectrumObject] = sampleSpectrumCARS( outputLGGP, backgroundSettings);

    carsData( ii, :) = dataSpectrum_ii;
    imChi3Data( ii, :) = ramanSpectrum_ii;
    ramanData( ii, :) = spectrumObject.raman;

    amplitude( ii ) = spectrumObject.amplitude;
    alpha( ii ) = spectrumObject.alpha;
    beta( ii, :) = spectrumObject.beta;

    background( ii, :) = spectrumObject.background;
    epsilon( ii, :) = spectrumObject.epsilon;

    amplitudeAlpha( ii, :) = [ spectrumObject.amplitude, spectrumObject.alpha];

    plot( carsData( ii, :) )
    yyaxis right
    h = plot( beta( ii, :) )
    hold on 
    h = plot( ramanData( ii, :) )

    title( num2str(spectrumObject.alpha) )
    drawnow();
    pause
    cla reset
    ii
end
toc

dataSetFileName = "synthetic-data.mat";
save( dataSetFileName, 'beta', 'imChi3Data', 'carsData', 'ramanData', 'epsilon', 'background');
