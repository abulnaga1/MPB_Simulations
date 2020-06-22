function [freqs, kvals] = band_importer(hname,wname)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     band_importer.m
%function [freqs, kvals] = band_importer(hname,wname)
%Description:       Given the dimensions of a waveguide, band_importer
%                   opens the corresponding folder hname-wname,
%                   imports the band data file, cleans up the data and
%                   stores the frequencies and the associated k vals
%                   in arrays of doubles which are returned
%Input Variables:   hname - height of waveguide in string format
%                   wname - width of waveguide in string format
%Output Variables:  kvals - array containing the simulated k-points
%                   freqs - the frequency associated with each k-point


%Import the data
folder=strcat(hname,'-',wname);
filename_bands = strcat('wg_gvd-',hname,'-',wname,'-bands.dat');        
file_bands = fullfile(folder,filename_bands);        
dataArray_bands = csvread(file_bands,1,1);
%Ignore the first k-point (k = 0,0,0) because there's no frequency value
%reported at this k-point
kvals = dataArray_bands(2:end,2);
freqs = dataArray_bands(2:end,end);

end
