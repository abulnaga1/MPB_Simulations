function D_plotter(h,w)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     GVD_plotter.m
%function overlap = GVD_plotter(xlimits,h,w)
%Description:       Given desired xlimits, and a set of parameters (h,w),
%                   band_plotter plots the GVD curves for these
%                   parameters
%Input Variables:   xlimits - Desired x limits
%                   h       - waveguide heights
%                   w       - waveguide widths
%Output Variables:  Saves the plot in .png format

c = physconst('LightSpeed');    %speed of light
a = 1e-6;

figure()
hold on;

for i = 1:length(h)
    for j = i
        hname = num2str(h(i));
        wname = num2str(w(j));
        
        freqs = band_importer(hname,wname);
        velocities = velocity_importer(hname,wname);
        GVD = gvd_calculator(freqs,velocities);
        wavelengths = 1e9*2*pi*c./(freqs.*(c*2*pi/a));
        
        plot(wavelengths,GVD);
    end
end
plot(wavelengths,zeros(size(wavelengths)),'k--');
hold on;
xline(1250,'k--');
title('Group Velocity Dispersion')
xlabel('Wavelength (nm)')
ylabel('D (ps.km^{-1}.nm^{-1})')
saveas(gcf,'GVD_Curves.fig')
hold off;
end