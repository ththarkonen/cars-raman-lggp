function [ll] = lggpLogLikelihood( data, param, betaProfile)
% Log-likelihood of a log-Gaussian gamma process based on
% https://en.wikipedia.org/wiki/Gamma_distribution PDF

    r = data.Y;

    alpha = param(1);

    betaScale = param(2);
    beta = betaScale * betaProfile;

    smoothingSigma = param(3);
    beta = smoothdata( beta, 'gaussian', smoothingSigma);

    gpTheta = param( 4:end );
    data.f = log( beta );

    ll_data = computeModelLikelihoodLGGP( r, alpha, beta);
    ll_gpPrior = computeGpLogLikelihood( data, gpTheta);

    ll = ll_data + ll_gpPrior;

    if( ~isfinite( ll ) )
        ll = -Inf;
    end
end