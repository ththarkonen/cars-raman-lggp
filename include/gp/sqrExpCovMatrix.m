function [K] = sqrExpCovMatrix( R, lengthScale)

    K = exp( -0.5 * ( R / lengthScale ).^2 );
end