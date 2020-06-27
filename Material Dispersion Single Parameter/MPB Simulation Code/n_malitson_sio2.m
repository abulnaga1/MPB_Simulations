%Author:        Alex Abulnaga
%Date:          2020-05-05
%Title:         n_malitson_sio2.m
%function n = n_malitson_sio2(lambda)
%Description:   Given a wavelength in units of microns, returns the
%               refractive index of SiO2 at that wavelength using the 
%               malitson sellmeier model from the paper
%               J. Opt. Soc. Am. 55, 1205-1208 (1965)
%Input Variables:   lambda - the wavelength in units of microns
%Output variables:  n - the SiO2 refractive index at the input wavelength
function n = n_malitson_sio2(lambda)
n=sqrt(1+0.6961663*lambda.^2./(lambda.^2-0.0684043^2)+0.4079426*lambda.^2./(lambda.^2-0.1162414^2)+0.8974794*lambda.^2./(lambda.^2-9.896161^2));
end