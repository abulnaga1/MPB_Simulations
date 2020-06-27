%Author:        Alex Abulnaga
%Date:          2020-05-05
%Title:         eps_diamond_sellmeier.m
%function eps = eps_diamond_sellmeier(lambda)
%Description:   Given a wavelength in units of microns, returns the
%               refractive index of Diamond at that wavelength using the 
%               model from http://www.diamond-materials.com/downloads/cvd_diamond_booklet.pdf
%Input Variables:   lambda - the wavelength in units of microns
%Output variables:  eps - the diamond permitivity at the input wavelength
function eps = eps_diamond_sellmeier(lambda)
eps = 1 + 0.3306*(lambda^2)/(lambda^2 - 0.175^2) + 4.3356*(lambda^2)/(lambda^2 - 0.106^2);
end