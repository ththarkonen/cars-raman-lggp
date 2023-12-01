# Log-Gaussian gamma process parameter estimation and synthetic data generation for coherent anti-Stokes scattering (CARS) and Raman spectra.
Implementantion of the log-Gaussian gamma process procedures described in the paper ([doi.org/10.48550/arXiv.2310.08055](https://doi.org/10.48550/arXiv.2310.08055)).
Raman spectra are modelled as gamma-distributed variables where the $\beta$-process for the gamma process is modelled as a log-Gaussian gamma process.
The formulation was originally inspired by log-Gaussian Cox processes.

The parameter estimation is done using Markov chain Monte Carlo methods. The estimated parameters can then be used to generate arbitrary amounts of synthetic spectra.
This is designed in particular for training neural networks for correcting spectral measurements. For more details, see the paper above. The associated Bayesian
neural network architecture can be found [here](https://github.com/ththarkonen/partially-bayesian-gamma-network).

# References
If you find the software useful, please cite ([doi.org/10.48550/arXiv.2310.08055](https://doi.org/10.48550/arXiv.2310.08055)).
