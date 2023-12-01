function [fStar, fCov] = gpPrediction( f, K_xSxS, K_xSx, K_xx )

    fStar = K_xSx * ( K_xx \ f );
    fCov  = K_xSxS - K_xSx * (K_xx \ K_xSx');
end