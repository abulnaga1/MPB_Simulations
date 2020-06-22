function [D, D_1250, D_zerocross] = D_calculator(freqs,velocities)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     D_calculator.m
%function overlap = D_calculator(velocities,kvals)
%Description:       Given data on the group veloicity at given k-points,
%                   D_calculator computes the group velocity dispersion
%                   data, and approximates the value of the D at 1250nm
%                   and the approximate zero-crossing wavelength using
%                   linear interpolation
%Input Variables:   freqs       - the frequency values used in the MPB 
%                                 simulation
%                   velocities  - the group velocity data at the associated
%                                 frequency points
%Output Variables:  D           - the D at the associated freq points
%                   D_1250      - the approximate D value at 1250nm
%                   D_zerocross - the approximate zero-crossing
%                                   wavelength

% D = d\beta_1 / d\lambda = d(1/vg)/d\lambda = -1/(vg)^2*d(vg)/d\lambda

%First convert the k-values to wavelengths in units of nm
c = physconst('LightSpeed');    %speed of light
a = 1e-6;                       %MPB unit cell size
wavelengths = 1e9*2*pi*c./(freqs.*(c*2*pi/a));

%Calculate the D
D = (-1e15./((c.*velocities).^2)).*(gradient(c.*velocities)./gradient(wavelengths)');

%Find the D Zero-cross point around 1250nm
D_zerocross = 0;
for i = 1:(length(D)-1)
    if D(i)<0 && D(i+1)>0
        D_zerocross = interp1(D(i:i+1),wavelengths(i:i+1),0);  
    end
    if D(i)>0 && D(i+1)<0
        D_zerocross = interp1(D(i:i+1),wavelengths(i:i+1),0);  
    end
end

%D_zerocross = length(D(D>0));

%approximate the value of the D at 1250nm
D_1250 = interp1(wavelengths,D,1250);

end