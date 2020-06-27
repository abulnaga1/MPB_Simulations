function [k, omega, neff] = n_eff_calc(omega)
%Author:        Alex Abulnaga
%Date:          2020-05-05
%Title:         w_diff.m
%function w_mismatch = w_diff(hname,wname)
%Description:   Given the dimensions of a waveguide, w_diff opens the
%corresponding folder hname-wname, imports the data files containing the
%w and k values at the signal, idler, and pump frequencies, then calculates
%the effective index at each frequency, and returns the frequency mismatch
%as defined in the function
%
%Input Variables:   hname - height of the waveguide in string format
%                   wname - weidth of the waveguide in string format
%Output variables:  w_mismatch - the calculated frequency mismatch

%Define formatspec for reading the .dat files
omega_name = num2str(omega);

formatSpec = '%s %s %s %s %s %s %s';
delimiter = ',';

%Import the data from the files (frequency and k-point data)
folder=omega_name;
filename_freq = strcat('freqs-',omega_name,'.dat');
file_freq = fullfile(folder,filename_freq);
fileID = fopen(file_freq,'r');
dataArray = textscan(fileID,formatSpec,'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);

%Extract the k-point and frequency value at each wavelength
k = table2array(dataArray(3));
k = str2double(k(end));

omega = table2array(dataArray(end));
omega = str2double(omega(end));

%Calculate the effective index at each wavelength
neff = k/omega;
end
