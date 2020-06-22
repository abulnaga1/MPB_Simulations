function top_params(master_data,k)
%Authors:   Alex Abulnaga, Sacha Welinski
%Date:      2019-08-30
%Title:     top_params.m
%function void = top_params(master_data,k)
%Description:       Given master data containing [height, width, data],
%                   top_params saves the top k parameter instances into
%                   a file top_params.txt
%Input Variables:   master_data - data to be plotted
%                   k - number of params to save
%Output:            top_params.txt


%Also output the 10 parameters with smallest vg mismatch, and largest mode
%overlap, gvd(1250nm), and gvd_zerocross

%Top k smallest vg mismatch
[vg_diff_min, vg_diff_min_index] = mink(master_data(:,3),k);

%Top k mode overlap
[mode_overlap_max, mode_overlap_max_index] = maxk(master_data(:,4),k);

%Top k gvd zerocross closest to 1250nm
[~, gvd_zero_index] = mink(abs(master_data(:,6) - 1250),k);

%Top k vg_min closest to 1250nm
[~, vg_min_best_index] = mink(abs(master_data(:,7) - 1250),k);


%File to write top k data to
fid_top_params = fopen('top_params.txt', 'wt');
%Start with ten smallest vg_diff
fprintf(fid_top_params,'Best Vg_Diff \n');
fprintf(fid_top_params,'height \t width \t vg_diff \t mode_overlap \t gvd_zerocross \t vg_min_wavelength \n');
formatspec = '%f \t %f \t %f \t %f \t %f \t %f';
for n = 1:k
    fprintf(fid_top_params,formatspec,master_data(vg_diff_min_index(n),1), ... 
        master_data(vg_diff_min_index(n),2),vg_diff_min(n), ...
        master_data(vg_diff_min_index(n),4), master_data(vg_diff_min_index(n),6), ...
        master_data(vg_diff_min_index(n),7));
    fprintf(fid_top_params,'\n');
end
fprintf(fid_top_params, '\n \n \n \n');

%print top mode overlap data
fprintf(fid_top_params,'Best Mode Overlap \n');
fprintf(fid_top_params,'height \t width \t mode_overlap \t vg_diff \t gvd_zerorcross \t vg_min_wavelength \n');
for n = 1:k
    fprintf(fid_top_params,formatspec,master_data(mode_overlap_max_index(n),1), ...
        master_data(mode_overlap_max_index(n),2),mode_overlap_max(n), ...
        master_data(mode_overlap_max_index(n),3),master_data(mode_overlap_max_index(n),6), ...
        master_data(mode_overlap_max_index(n),7));
    fprintf(fid_top_params,'\n');
end
fprintf(fid_top_params, '\n \n \n \n');

%print top gvd zero-cross data
fprintf(fid_top_params,'Best GVD zero-cross data \n');
fprintf(fid_top_params,'height \t width \t gvd_zerocross \t vg_diff \t mode_overlap \t vg_min_wavelength \n');
for n = 1:k
    fprintf(fid_top_params,formatspec,master_data(gvd_zero_index(n),1), ...
        master_data(gvd_zero_index(n),2),master_data(gvd_zero_index(n),6), ...
        master_data(gvd_zero_index(n),3), master_data(gvd_zero_index(n),4), ...
        master_data(gvd_zero_index(n),7));
    fprintf(fid_top_params,'\n');
end
fprintf(fid_top_params, '\n \n \n \n');

%print top vg_min data
fprintf(fid_top_params,'Best Vg_min_wavelength data \n');
fprintf(fid_top_params,'height \t width \t vg_min_wavelength \t gvd_zerocross \t vg_diff \t mode_overlap \t vg_min_wavelength \n');
for n = 1:k
    fprintf(fid_top_params,formatspec,master_data(vg_min_best_index(n),1), ...
        master_data(vg_min_best_index(n),2), master_data(vg_min_best_index(n),7),...
        master_data(vg_min_best_index(n),6), ...
        master_data(vg_min_best_index(n),3), master_data(vg_min_best_index(n),4));
    fprintf(fid_top_params,'\n');
end

fclose(fid_top_params);
end