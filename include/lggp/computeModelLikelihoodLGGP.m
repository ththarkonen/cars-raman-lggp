function [ll] = computeModelLikelihoodLGGP( x, alpha, beta)

    ll = -gammaln( alpha );
    ll = ll - alpha .* log( beta );
    ll = ll + (alpha - 1) .* log( x ) ;
    ll = ll - x ./ beta;

    ll = sum( ll );
end