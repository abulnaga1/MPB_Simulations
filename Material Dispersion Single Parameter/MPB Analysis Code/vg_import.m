function vg = vg_import(omega)
%Author:        Alex Abulnaga
%Date:          2020-05-05
%Title:         vg_import.m
%function vg = vg_import(omega_name)
%Description:   Given a frequency value omega in mpb units, vg_calc opens the
%corresponding folder omega_name, imports the data files containing the
%k and vg values at the given frequency, then returns the group velocity
%at that frequency point
%
%Input Variables:   omega_name - frequency in string format
%Output variables:  vg - the group velocity

%Define formatspec for reading the .dat files
formatSpec = '%s %s %s';
delimiter = ',';

omega_name = num2str(omega);

%Import the data from the files (frequency and k-point data)
folder=omega_name;
filename_freq = strcat('velocity-',omega_name,'.dat');
file_freq = fullfile(folder,filename_freq);
fileID = fopen(file_freq,'r');
data_cell = textscan(fileID,formatSpec,'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);

vel_string_array = strsplit(string(data_cell(3)));
vg = str2double(erase(vel_string_array(1),'#('));
end
