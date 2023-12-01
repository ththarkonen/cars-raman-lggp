function [ll] = computeGpLogLikelihood( data, theta)

    f = data.f;
    R = data.R;
    nData = length(f);

    m = theta(1);
    s2 = theta(2).^2;
    ls = theta(3);
    s2F = theta(4).^2;

    f = f - m;
    
    s2I = s2 * eye( nData );% + 0.0000001 * var( f ) * eye( nData );
    K = s2F * sqrExpCovMatrix( R, ls);
    
    try
        ll = gpLogLikelihood( f, K + s2I);
    catch
        ll = -Inf; 
    end
end