function vg_mismatch = vg_diff(hname,wname)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     vg_diff.m
%function vg_mismatch = vg_diff(hname,wname)
%Description:       Given the dimensions of a waveguide, vg_diff
%                   opens the corresponding folder hname-wname
%                   imports the data files containing the value
%                   of group velocity at 946nm and 1550nm from MPB
%                   simulations and returns the difference
%Input Variables:   hname - height of waveguide in string format
%                   wname - width of waveguide in string format
%Output Variables:  vg_mismatch - the calculated mismatch in group velocity


%Describe the format of data in the .dat files
formatSpec = '%*s%*s%s%[^\n\r]';
delimiter = ',';

%Import the vg data
folder=strcat(hname,'-',wname);
filename_vel_siv = strcat('velocity_siv-',hname,'-',wname,'.dat');
filename_vel_tel = strcat('velocity_tel-',hname,'-',wname,'.dat');
file_vel_siv = fullfile(folder,filename_vel_siv);
file_vel_tel = fullfile(folder,filename_vel_tel);
fileID_siv = fopen(file_vel_siv,'r');
fileID_tel = fopen(file_vel_tel,'r');
dataArray_siv = textscan(fileID_siv,formatSpec,'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
dataArray_tel = textscan(fileID_tel,formatSpec,'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID_siv);
fclose(fileID_tel);

%Clean up the data and format as double
vel_siv_string = strsplit(string(dataArray_siv(1)));
vel_siv = str2double(erase(vel_siv_string(1),'#('));
vel_tel_string = strsplit(string(dataArray_tel(1)));
vel_tel = str2double(erase(vel_tel_string(1),'#('));

%calculate and return the vg_mismatch
vg_mismatch = abs(1/vel_siv-1/vel_tel);
end