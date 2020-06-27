%Author:        Alex Abulnaga
%Date:          2020-05-05
%Title:         eps_gaas_skauli.m
%function eps = eps_gaas_skauli(lambda)
%Description:   Given a wavelength in units of microns, returns the
%               refractive index of GaAs at that wavelength using the 
%               Skauli sellmeier model from the paper
%               J. Appl. Phys., 94, 6447-6455 (2003)
%Input Variables:   lambda - the wavelength in units of microns
%Output variables:  eps - the GaAs permitivity at the input wavelength
function eps = eps_gaas_skauli(lambda)
eps = 5.372514 + 5.466742*(lambda^2)/(lambda^2 - 0.4431307^2) + 0.02429960*(lambda^2)/(lambda^2 - 0.8746453^2) + 1.957522*(lambda^2)/(lambda^2 - 36.9166^2);
end