function [hFig] = plotChainsLGGP( outputLGGP )

    chain = outputLGGP.chain;
    burnedChain = outputLGGP.burnedChain;
    nParameters = size( chain, 2);

    titleString = ["$\alpha$",
                        "$C_\beta$",
                        "$G_\sigma$",
                        "$\mu$",
                        "$\sigma_\beta$",
                        "$\l$",
                        "$\sigma_{\beta, f}$"];

    hFig = figure();
    tiledlayout( 2, nParameters);
    
    for ii = 1:nParameters
    
        theta_ii = burnedChain( :, ii);
        title_ii = titleString( ii );

        nexttile();
        h = histogram( theta_ii );

        h = title( title_ii );
        h.Interpreter = "latex";

        ax = gca();
        ax.FontSize = 20;
    end
    
    for ii = 1:nParameters
    
        theta_ii = chain( :, ii);
        title_ii = titleString( ii );
        
        nexttile();
        h = plot( theta_ii );

        h = title( title_ii );
        h.Interpreter = "latex";

        ax = gca();
        ax.FontSize = 20;
    end
end