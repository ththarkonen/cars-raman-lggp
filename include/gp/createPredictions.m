function [yStar, fStarSigma, fCov] = createPredictions( x, y, xS, theta)

    nData = length( x );
    nPredictions = length( xS );
    
    nDimensions = size( x, 2);

    mu = theta(1);
    s2 = theta(2);
    ls = theta(3);
    s2F = theta(4);
    
    R_xx = ones( nData, nData, nDimensions);
    R_xSx = ones( nPredictions, nData, nDimensions);
    R_xSxS = ones( nPredictions, nPredictions, nDimensions);
    
    for ii = 1:nData
        for jj = 1:nData
            for kk = 1:nDimensions

                x_ii_kk = x( ii, kk);
                x_jj_kk = x( jj, kk);
    
                r_ii_jj_kk = x_ii_kk - x_jj_kk;
                R_xx( ii, jj, kk) = abs( r_ii_jj_kk );
            end
        end
    end
    
    for ii = 1:nPredictions
        for jj = 1:nData
            for kk = 1:nDimensions

                x_ii_kk = xS( ii, kk);
                x_jj_kk = x( jj, kk);
    
                r_ii_jj_kk = x_ii_kk - x_jj_kk;
                R_xSx( ii, jj, kk) = abs( r_ii_jj_kk );
            end
        end
    end

    for ii = 1:nPredictions
        for jj = 1:nPredictions
            for kk = 1:nDimensions

                x_ii_kk = xS( ii, kk);
                x_jj_kk = xS( jj, kk);
    
                r_ii_jj_kk = x_ii_kk - x_jj_kk;
                R_xSxS( ii, jj, kk) = abs( r_ii_jj_kk );
            end
        end
    end
    
    s2I = s2 * eye( nData, nData);
    K_xSxS = s2F * sqrExpCovMatrix( R_xSxS, ls);
    K_xSx = s2F * sqrExpCovMatrix( R_xSx, ls);
    K_xx = s2F * sqrExpCovMatrix( R_xx, ls) + s2I;

    [yStar, fCov] = gpPrediction( y - mu, K_xSxS, K_xSx, K_xx );
    
    yStar = yStar + mu;
    fStarSigma = sqrt( diag( fCov ) );
end