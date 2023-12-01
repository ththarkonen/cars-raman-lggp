function [ll] = computeIncrementLogLikelihood( x, alpha, beta)
    
    u = diff( x );
    n = length( u );
    ll = zeros( n, 1);

    if( isscalar(alpha) )
        alpha = alpha * ones( n + 1, 1);
    end

    if( isscalar(beta) )
        beta = beta * ones( n + 1, 1);
    end

    nonPositiveInds = u <= 0;
    positiveInds = ~nonPositiveInds;

    u( nonPositiveInds ) = -u( nonPositiveInds );
    
    alpha_1 = alpha(2:end);
    alpha_2 = alpha(1:end-1);

    beta_1 = beta(2:end);
    beta_2 = beta(1:end-1);

    alphaSum = 0.5 * ( alpha_1 + alpha_2 );
    alphaDelta = 0.5 * ( alpha_1 - alpha_2 );

    beta_0 = (1 ./ beta(1:end - 1)) + (1 ./ beta(2:end));
    betaSum = beta_1 + beta_2;

    inverseBetaSum = (1 ./ beta_1) - (1 ./ beta_2);
    inverseBetaSum( nonPositiveInds ) = (1 ./ beta_2( nonPositiveInds )) - (1 ./ beta_1( nonPositiveInds ));

    whitArg_1 = alphaDelta;
    whitArg_1( nonPositiveInds ) = -alphaDelta( nonPositiveInds );

    whitArg_2 = 0.5 * ( 1 - alpha_1 - alpha_2 );
    whitArg_3 = beta_0 .* u;

    % C
    ll( positiveInds ) = -gammaln( alpha_1( positiveInds ) );
    ll( nonPositiveInds ) = -gammaln( alpha_2( nonPositiveInds ) );

    % u^( * ) part
    ll = ll - alphaDelta .* log( beta_1 );
    ll = ll + alphaDelta .* log( beta_2 );
    ll = ll - alphaSum .* log( betaSum );

    % exponential part
    ll = ll + ( alphaSum - 1 ) .* log( u );
    ll = ll - 0.5 .* u .* inverseBetaSum;

    % Whittaker part
    whittaker_ll = zeros( n, 1);

    parfor kk = 1:n

        arg_1_kk = whitArg_1(kk);
        arg_2_kk = whitArg_2(kk);
        arg_3_kk = whitArg_3(kk);

        whitW_kk = py.mpmath.whitw( arg_1_kk, arg_2_kk, arg_3_kk);
        whitW_kk = py.float( whitW_kk );
        logWhitW_kk = log( 1 * whitW_kk );

        whittaker_ll(kk) = logWhitW_kk;
    end

    infInds = ~isfinite( whittaker_ll );
    whittaker_ll( infInds ) = -Inf;

    ll = ll + whittaker_ll;
    ll = sum(ll);
    ll = real(ll);
end