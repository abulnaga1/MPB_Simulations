%Quick code for generating a text file of tuples that can be copy pasted
%into the mpb batch submitted

%Specify path to save data to
%addpath('C:\Users\alexa\OneDrive\Documents\Research - Princeton\GaAs Freq Conv\Simulations\MPB\3D GaAs Waveguide\SiO2\Matlab Files')
clear all;

w=0.25:0.025:1.1;
h=0.66:0.02:0.7;
fid = fopen('parameters.txt', 'wt');
formatspec = '"%s","%s" ';
num_tuples = 0;
tuples = zeros(length(h)*length(w),2);

for i = 1:length(w)
    for j = 1:length(h)
        fprintf(fid,formatspec,num2str(h(j)),num2str(w(i)));
        num_tuples = num_tuples + 1;
        tuples(num_tuples,1) = h(j);
        tuples(num_tuples,2) = w(i);
    end
    fprintf(fid,'\n');
end

%Generate an array of the tuples that is easy to import later
save('tuples.mat','tuples');







