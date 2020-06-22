function vg_min_wavelength = vg_min(freqs, velocities)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-30
%Title:     vg_min.m
%function vg_min_wavelength = vg_min(freqs,velocities)
%Description:       Given the bands of a waveguide, calculates the
%                   wavelength at which the minima in Vg occurs
%Input Variables:   freqs - the frequency band data
%                   velocities - the vg value at each frequency point
%Output Variables:  vg_min_wavelength - the wavelength at which vg is
%                   minimized
c = physconst('LightSpeed');    %speed of light
a = 1e-6;

[~, vg_min_index] = min(velocities);
vg_min_wavelength = 1e9*2*pi*c./(freqs(vg_min_index)*(c*2*pi/a)); 
end