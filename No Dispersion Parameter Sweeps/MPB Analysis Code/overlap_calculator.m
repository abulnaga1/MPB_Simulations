function overlap = overlap_calculator(hname,wname,eps_hi)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-15
%Title:     overlap_calculator.m
%function overlap = overlap_calculator(hname,wname)
%Description:       Given the dimensions of a waveguide, overlap_calculator
%                   opens the corresponding folder hname-wname,
%                   imports the field data files, cleans up the data, and
%                   calculates the mode overlap between the fields at 946nm
%                   and 1550nm
%Input Variables:   hname - height of waveguide in string format
%                   wname - width of waveguide in string format
%Output Variables:  overlap - the computed mode overlap between the fields
%                             at 946nm and 1550nm

%Import the dielectric function
folder=strcat(hname,'-',wname);

epsilon_file = strcat('epsilon-',hname,'-',wname,'.txt');
epsilon = importdata(fullfile(folder,epsilon_file));
    
%Import the E-fields
e_tel_file = strcat('e-1550-h-',hname,'-w-',wname,'-');
e_siv_file = strcat('e-946-h-',hname,'-w-',wname,'-'); 
    
E_tel_x = importdata(fullfile(folder,strcat(e_tel_file,'x-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_tel_file,'x-i.txt')));
E_tel_y = importdata(fullfile(folder,strcat(e_tel_file,'y-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_tel_file,'y-i.txt')));
E_tel_z = importdata(fullfile(folder,strcat(e_tel_file,'z-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_tel_file,'z-i.txt')));

E_siv_x = importdata(fullfile(folder,strcat(e_siv_file,'x-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_siv_file,'x-i.txt')));
E_siv_y = importdata(fullfile(folder,strcat(e_siv_file,'y-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_siv_file,'y-i.txt')));
E_siv_z = importdata(fullfile(folder,strcat(e_siv_file,'z-r.txt'))) + 1i.*importdata(fullfile(folder,strcat(e_siv_file,'z-i.txt')));

%Calculate the magnitude squared of the fields
E_siv_sq = E_siv_x.*conj(E_siv_x) + E_siv_y.*conj(E_siv_y) + E_siv_z.*conj(E_siv_z);
E_tel_sq = E_tel_x.*conj(E_tel_x) + E_tel_y.*conj(E_tel_y) + E_tel_z.*conj(E_tel_z);
        
%Calculate the Product of E1* E2
E_product = conj(E_siv_x).*E_tel_x + conj(E_siv_y).*E_tel_y + conj(E_siv_z).*E_tel_z; 

%Calculate the mode overlap in the waveguide only
wg_region = epsilon >= eps_hi; %Boolean definition of wg region
        
E_product_wg = E_product.*wg_region;
E_siv_sq_wg = E_siv_sq.*wg_region;
E_tel_sq_wg = E_tel_sq.*wg_region;

overlap = (((trapz(trapz(E_product_wg))))^2)/((trapz(trapz(E_siv_sq_wg)))*(trapz(trapz(E_tel_sq_wg))));   %dimensionless quantity
end   