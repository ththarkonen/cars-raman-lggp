function [ll] = gpLogLikelihood( f, K)

    n = length(f);
    ll = -0.5 * f' * inv( K ) * f;
    ll = ll - 0.5 * logdet(K);
    ll = ll - 0.5 * n * log(2*pi);
end