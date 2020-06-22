function band_plotter(h,w)%,legend_string)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     band_plotter.m
%function overlap = band_plotter(xlimits,h,w)
%Description:       Given desired xlimits, and a set of parameters (h,w),
%                   band_plotter plots the dispersion curves for these
%                   parameters
%Input Variables:   xlimits - Desired x limits
%                   h       - waveguide heights
%                   w       - waveguide widths
%Output Variables:  Saves the plot in .png format


figure()
hold on;

for i = 1:length(h)
    for j = i
        hname = num2str(h(i));
        wname = num2str(w(j));
        [freqs, kvals] = band_importer(hname,wname);
        plot(kvals,freqs)
    end
end

%Plot light lines
%plot(data_band(:,5,number),data_band(:,5,number),'--') % air
plot(kvals,kvals./sqrt(5.7),'--') % Diamond
plot(kvals,kvals./sqrt(11.67),'--') % GaAs
hold off;

title('Band Dispersion in MPB Units')
ylabel('wa/2\pic')
xlabel('ka/2\pi')
%xlim(xlimits)
%legend(legend_string)
saveas(gcf,'Band_Dispersion.fig');

end