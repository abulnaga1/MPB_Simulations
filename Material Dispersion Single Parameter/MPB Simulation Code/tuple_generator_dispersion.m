%Quick code for generating a text file of tuples that can be copy pasted
%into the mpb batch submitted

%Specify path to save data to
%addpath('C:\Users\alexa\OneDrive\Documents\Research - Princeton\GaAs Freq Conv\Simulations\MPB\3D GaAs Waveguide\SiO2\Matlab Files')
clear all;

lambda = 0.9:0.006:1.61;
omega = 1./lambda;

eps_gaas = zeros(size(lambda));
eps_diamond = zeros(size(lambda));
%nsio2 = n;

for i = 1:length(lambda)
    eps_gaas(i) = eps_gaas_skauli(lambda(i));
    eps_diamond(i) = eps_diamond_sellmeier(lambda(i));
end

fid = fopen('parameters.txt', 'wt');
formatspec = '"%s","%s","%s" ';
num_tuples = 0;
tuples = zeros(length(lambda),2);%*length(eps),2);

for i = 1:length(lambda)
    %for j = 1:length(eps)
        fprintf(fid,formatspec,num2str(eps_gaas(i)), num2str(eps_diamond(i)), num2str(omega(i)));
        num_tuples = num_tuples + 1;
        tuples(num_tuples,1) = eps_gaas(i);
        tuples(num_tuples,2) = eps_diamond(i);
        tuples(num_tuples,3) = omega(i);
    %end
    fprintf(fid,'\n');
end

%Generate an array of the tuples that is easy to import later
save('tuples.mat','tuples');


%%








