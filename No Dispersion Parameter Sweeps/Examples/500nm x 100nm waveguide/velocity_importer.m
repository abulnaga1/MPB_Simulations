function velocities = velocity_importer(hname,wname)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     velocity_importer.m
%function velocities = velocity_importer(hname,wname)
%Description:       Given the dimensions of a waveguide, velocity_importer
%                   opens the corresponding folder hname-wname,
%                   imports the velocity data file, cleans up the data and
%                   stores it in an array of doubles which is returned
%Input Variables:   hname - height of waveguide in string format
%                   wname - width of waveguide in string format
%Output Variables:  velocities - array containing the group velocity at
%                   each simulated k-point

%Specify the data format in the file
formatSpec = '%*s%*s%s%[^\n\r]';
delimiter = ',';

%Import the data
folder=strcat(hname,'-',wname);
filename_vg = strcat('wg_gvd-',hname,'-',wname,'-vel.dat');
file_vg = fullfile(folder,filename_vg);
fileID_vg = fopen(file_vg,'r');
dataArray_vg = textscan(fileID_vg,formatSpec,'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID_vg);

%Clean up the data and store as a double which is returned
num_kpoints = length(dataArray_vg{1});
velocities = zeros(1,num_kpoints);
for i = 1:num_kpoints
    velocities_string = strsplit(dataArray_vg{1}(i));
    velocities(i) = str2double(erase(velocities_string(1),'#('));
end
%Get rid of the first k-point because MPB just sets everything to 0
%at the first k-point simulated, which is k =<0,0,0>
velocities = velocities(2:end);
end