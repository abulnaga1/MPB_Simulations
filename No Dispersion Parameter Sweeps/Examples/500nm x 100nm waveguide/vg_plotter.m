function vg_plotter(xlimits,h,w)%,legend_string)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     vg_plotter.m
%function overlap = vg_plotter(xlimits,h,w)
%Description:       Given desired xlimits, and a set of parameters (h,w),
%                   band_plotter plots the group velocity dispersion
%                   curves for these parameters
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
        [freqs, ~] = band_importer(hname,wname);
        velocities = velocity_importer(hname,wname);
        wavelengths = 1e9*2*pi*c./(freqs.*(c*2*pi/a));
        
        plot(wavelengths,velocities);
    end
end

%Plot vertical lines at 946nm and 1550nm
xline(946,'k--');
xline(1550,'k--');

title('Group velocity vs wavelength')
xlabel('\lambda (nm)')
ylabel('vg/c')
%xlim(xlimits);
saveas(gcf,'Vg_vs_L_real_units.fig');

end