function master_plotter(master_data)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     band_plotter.m
%function overlap = master_plotter(xlimits,h,w)
%Description:       Given master data containing [height, width, data],
%                   master_plotter plots each data entry as a function of
%                   waveguide cross-section
%Input Variables:   master_data - data to be plotted
%Output Variables:  Saves the plot in .png format

%Plot the data
N = size(master_data,1);

%2D plot of (h,w,vg_diff)
figure()
stem3(master_data(:,1).*1000,master_data(:,2).*1000,master_data(:,3),'bo')
xlabel('Waveguide Height (nm)');
ylabel('Waveguide Width (nm)');
zlabel('|1/Vg_9_4_6 - 1/Vg_1_5_5_0|');
zlim([min(master_data(:,3)) max(master_data(:,3))])
title('Group Velocity Mismatch vs Waveguide Cross Section');
saveas(gcf,'vg_diff_2D.png')

%Take a 1D Projection
figure()
plot(1:N,master_data(:,3),'o--');
xlabel('Parameter Bin (h,w)');
ylabel('|1/Vg_9_4_6 - 1/Vg_1_5_5_0|');
title('1D Projection of Vg Mismatch');
saveas(gcf,'vg_diff_1D.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%2D plot of (h,w,mode_overlap)
figure()
stem3(master_data(:,1).*1000,master_data(:,2).*1000,master_data(:,4),'ro')
xlabel('Waveguide Height (nm)');
ylabel('Waveguide Width (nm)');
zlabel('Mode Overlap');
zlim([min(master_data(:,4)) max(master_data(:,4))])
title('Mode Overlap vs Waveguide Cross Section');
saveas(gcf,'mode_overlap_2D.png')

%Take a 1D Projection
figure()
plot(1:N,master_data(:,4),'ro--');
xlabel('Parameter Bin (h,w)');
ylabel('Mode Overlap');
title('1D Projection of Mode Overlap');
saveas(gcf,'mode_overlap_1D.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%2D Plot of GVD(1250nm)
figure()
stem3(master_data(:,1).*1000,master_data(:,2).*1000,abs(master_data(:,5)),'bo')
xlabel('Waveguide Height (nm)');
ylabel('Waveguide Width (nm)');
zlabel('|GVD| at 1250nm');
zlim([min(abs(master_data(:,5))) max(abs(master_data(:,5)))])
title('|GVD| at 1250nm vs Waveguide Cross Section');
saveas(gcf,'GVD_2D.png')

figure()
stem3(master_data(:,1).*1000,master_data(:,2).*1000,1./abs(master_data(:,5)),'ro')
xlabel('Waveguide Height (nm)');
ylabel('Waveguide Width (nm)');
zlabel('1/|GVD| at 1250nm');
zlim([min(1./abs(master_data(:,5))) max(1./abs(master_data(:,5)))])
title('1/|GVD| at 1250nm vs Waveguide Cross Section');
saveas(gcf,'GVD_2D_inverse.png')

%1D Projection
figure()
plot(1:N,master_data(:,5),'o--')
title('GVD Value at 1250nm, 1D Projection')
ylabel('D (ps.km^{-1}.nm^{-1})');
xlabel('Parameter Instance')
saveas(gcf,'GVD_1250.png')

%2D Plot of GVD zero-crossing wavelength
figure()
stem3(master_data(:,1).*1000,master_data(:,2).*1000,master_data(:,6),'ro')
xlabel('Waveguide Height (nm)');
ylabel('Waveguide Width (nm)');
zlabel('Wavelength');
zlim([min(master_data(:,6)) max(master_data(:,6))])
title('GVD zero-cross wavelength vs Waveguide Cross Section');
saveas(gcf,'GVD_zero_cross_2D.png')

%1D Projection
figure()
plot(1:N,master_data(:,6),'ro--')
hold on;
plot(1:N,1250*ones(1,N),'k--');
title('GVD Zero-Cross Wavelength, 1D Projection')
ylabel('Wavelength (nm)');
xlabel('Parameter Instance')
saveas(gcf,'GVD_zero_cross.png')
end
