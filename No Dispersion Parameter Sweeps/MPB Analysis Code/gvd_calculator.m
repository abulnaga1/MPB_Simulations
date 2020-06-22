function [GVD, gvd_1250, gvd_zerocross] = gvd_calculator(freqs,velocities)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     gvd_calculator.m
%function overlap = gvd_calculator(velocities,kvals)
%Description:       Given data on the group veloicity at given k-points,
%                   gvd_calculator computes the group velocity dispersion
%                   data, and approximates the value of the GVD at 1250nm
%                   and the approximate zero-crossing wavelength using
%                   linear interpolation
%Input Variables:   freqs       - the frequency values used in the MPB 
%                                 simulation
%                   velocities  - the group velocity data at the associated
%                                 frequency points
%Output Variables:  GVD           - the GVD at the associated freq points
%                   gvd_1250      - the approximate GVD value at 1250nm
%                   gvd_zerocross - the approximate zero-crossing
%                                   wavelength

% D = d\beta_1 / d\lambda = d(1/vg)/d\lambda = -1/(vg)^2*d(vg)/d\lambda

%First convert the k-values to wavelengths in units of nm
c = physconst('LightSpeed');    %speed of light
a = 1e-6;                       %MPB unit cell size
wavelengths = 1e9*2*pi*c./(freqs.*(c*2*pi/a));

%Calculate the GVD
GVD = (-1e15./((c.*velocities).^2)).*(gradient(c.*velocities)./gradient(wavelengths)');

%Find the GVD Zero-cross point around 1250nm
gvd_zerocross = 0;
for i = 1:(length(GVD)-1)
    if GVD(i)<0 && GVD(i+1)>0
        gvd_zerocross = interp1(GVD(i:i+1),wavelengths(i:i+1),0);  
    end
    if GVD(i)>0 && GVD(i+1)<0
        gvd_zerocross = interp1(GVD(i:i+1),wavelengths(i:i+1),0);  
    end
end

%gvd_zerocross = length(GVD(GVD>0));

%approximate the value of the GVD at 1250nm
gvd_1250 = interp1(wavelengths,GVD,1250);

end