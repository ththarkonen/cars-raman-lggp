function [K] = expCovMatrix( R, lengthScale)

    K = exp( -0.5 * abs( R / lengthScale ) );
end