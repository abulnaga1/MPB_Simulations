#!/bin/bash
# array job using 1 nodes and 1 processor,
# and runs for 5 minutes max per task.
#SBATCH -J array_example
#SBATCH --output=wg_%A_%a.out
#SBATCH -N 1   # node count
#SBATCH --ntasks-per-node=1
#SBATCH -t 03:00:00
#SBATCH --array=0-119

TUPLES=("0.66","0.25" "0.68","0.25" "0.7","0.25" 
"0.66","0.275" "0.68","0.275" "0.7","0.275" 
"0.66","0.3" "0.68","0.3" "0.7","0.3" 
"0.66","0.325" "0.68","0.325" "0.7","0.325" 
"0.66","0.35" "0.68","0.35" "0.7","0.35" 
"0.66","0.375" "0.68","0.375" "0.7","0.375" 
"0.66","0.4" "0.68","0.4" "0.7","0.4" 
"0.66","0.425" "0.68","0.425" "0.7","0.425" 
"0.66","0.45" "0.68","0.45" "0.7","0.45" 
"0.66","0.475" "0.68","0.475" "0.7","0.475" 
"0.66","0.5" "0.68","0.5" "0.7","0.5" 
"0.66","0.525" "0.68","0.525" "0.7","0.525" 
"0.66","0.55" "0.68","0.55" "0.7","0.55" 
"0.66","0.575" "0.68","0.575" "0.7","0.575" 
"0.66","0.6" "0.68","0.6" "0.7","0.6" 
"0.66","0.625" "0.68","0.625" "0.7","0.625" 
"0.66","0.65" "0.68","0.65" "0.7","0.65" 
"0.66","0.675" "0.68","0.675" "0.7","0.675" 
"0.66","0.7" "0.68","0.7" "0.7","0.7" 
"0.66","0.725" "0.68","0.725" "0.7","0.725" 
"0.66","0.75" "0.68","0.75" "0.7","0.75" 
"0.66","0.775" "0.68","0.775" "0.7","0.775" 
"0.66","0.8" "0.68","0.8" "0.7","0.8" 
"0.66","0.825" "0.68","0.825" "0.7","0.825" 
"0.66","0.85" "0.68","0.85" "0.7","0.85" 
"0.66","0.875" "0.68","0.875" "0.7","0.875" 
"0.66","0.9" "0.68","0.9" "0.7","0.9" 
"0.66","0.925" "0.68","0.925" "0.7","0.925" 
"0.66","0.95" "0.68","0.95" "0.7","0.95" 
"0.66","0.975" "0.68","0.975" "0.7","0.975" 
"0.66","1" "0.68","1" "0.7","1" 
"0.66","1.025" "0.68","1.025" "0.7","1.025" 
"0.66","1.05" "0.68","1.05" "0.7","1.05" 
"0.66","1.075" "0.68","1.075" "0.7","1.075" 
"0.66","1.1" "0.68","1.1" "0.7","1.1")

IFS="," read h w <<< "${TUPLES[$SLURM_ARRAY_TASK_ID]}"
echo "${h} ${w}"

cd /your_folder
mkdir $h-$w
mkdir images
mkdir images/dpwr
mkdir images/dpwr/946
mkdir images/dpwr/1550
mkdir images/epsilon

cp wg3d_e_fields.ctl $h-$w
cp wg3d_vg.ctl $h-$w
cp wg3d_gvd.ctl $h-$w
cp wg3d_dpwr.ctl $h-$w

cd $h-$w

#Vg Calculations, Telecom
mpb h=$h w=$w eps_wgd=11.3569 eps_sub=5.7016 eps_sin=3.9852 omega=0.64516129032 kguess=1.55 kmin=0 kmax=3 wg3d_vg.ctl >& wg_vg_tel-$h-$w.out
grep velocity wg_vg_tel-$h-$w.out > velocity_tel-$h-$w.dat

#Vg Calculations, SiV
mpb h=$h w=$w eps_wgd=12.5580 eps_sub=5.7413 eps_sin=4.0647 omega=1.05708245243 kguess=3.3 kmin=1.5 kmax=4.5 wg3d_vg.ctl >& wg_vg_siv-$h-$w.out
grep velocity wg_vg_siv-$h-$w.out > velocity_siv-$h-$w.dat

#Band Calculation, 1250nm
mpb h=$h w=$w wg3d_gvd.ctl >& wg_gvd-$h-$w.out
grep freqs wg_gvd-$h-$w.out > wg_gvd-$h-$w-bands.dat
grep velocity wg_gvd-$h-$w.out > wg_gvd-$h-$w-vel.dat

#E fields, Telecom
mpb h=$h w=$w eps_wgd=11.3569 eps_sub=5.7016 eps_sin=3.9852 omega=0.64516129032 kguess=1.55 kmin=0 kmax=3 wg3d_e_fields.ctl >& wg3d_e_fields_tel-$h-$w.out
h5totxt -0 -x 0 wg3d_e_fields-epsilon.h5:data >& epsilon-$h-$w.txt

h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.i >& e-1550-h-$h-w-$w-x-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.r >& e-1550-h-$h-w-$w-x-r.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.i >& e-1550-h-$h-w-$w-y-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.r >& e-1550-h-$h-w-$w-y-r.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:z.i >& e-1550-h-$h-w-$w-z-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:z.r >& e-1550-h-$h-w-$w-z-r.txt

#E fields, SiV
mpb h=$h w=$w eps_wgd=12.5580 eps_sub=5.7413 eps_sin=4.0647 omega=1.05708245243 kguess=3.3 kmin=1.5 kmax=4.5 wg3d_e_fields.ctl >& wg3d_e_fields_siv-$h-$w.out

h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.i >& e-946-h-$h-w-$w-x-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.r >& e-946-h-$h-w-$w-x-r.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.i >& e-946-h-$h-w-$w-y-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.r >& e-946-h-$h-w-$w-y-r.txt
h5totxt -0 -x 0	wg3d_e_fields-e.k01.b01.h5:z.i >& e-946-h-$h-w-$w-z-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:z.r >& e-946-h-$h-w-$w-z-r.txt

#D-pwr, Telecom
mpb h=$h w=$w eps_wgd=11.3569 eps_sub=5.7016 eps_sin=3.9852 omega=0.64516129032 kguess=1.55 kmin=0 kmax=3 wg3d_dpwr.ctl >& wg3d_dpwr_tel-$h-$w.out
h5topng -c bluered -x -0 wg3d_dpwr-dpwr.k01.b01.h5:data
mv wg3d_dpwr-dpwr.k01.b01.png /your_folder/images/dpwr/1550/h-$h-w-$w.png

#D-pwr, SiV
mpb h=$h w=$w eps_wgd=12.5580 eps_sub=5.7413 eps_sin=4.0647 omega=1.05708245243 kguess=3.3 kmin=1.5 kmax=4.5 wg3d_dpwr.ctl >& wg3d_dpwr_siv-$h-$w.out
h5topng -c bluered -x -0 wg3d_dpwr-dpwr.k01.b01.h5:data
mv wg3d_dpwr-dpwr.k01.b01.png /your_folder/images/dpwr/946/h-$h-w-$w.png

#Save the dielectric image
h5topng -x -0 wg3d_dpwr-epsilon.h5:data
mv wg3d_dpwr-epsilon.png /your_folder/images/epsilon/h-$h-w-$w.png

rm *.h5
rm *.png