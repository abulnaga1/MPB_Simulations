# Simulating a simple waveguide using MPB

This document introduces a very basic example for simulating a waveguide in the [MPB eigenmode solver](https://mpb.readthedocs.io/en/latest/) and to subsequently analyzing the output.
The purpose is not to give a comprehensive introduction to MPB, but rather to demonstrate how it can be used for a variety of applications including calculating band structures, mode profiles, and group velocities both with and without the inclusion of material dispersion. In particular, we demonstrate how MPB can be used for running large parameter sweeps for optimizing some parameter of interest. The mpb code uses the [scheme](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/) user interface, and can be executed either directly from the terminal or using a workload manager such as [slurm](https://slurm.schedmd.com/sbatch.html). Analysis of the simulation output is done in Matlab, but can readily adapted to Python if desired.

# Table of contents
1. [Fixed Index Simulations](#fixed_index_sims)
    1. [Band simulation](#Band_simulation)
    2. [Electric field simulations](#field_simulations)
    3. [Using a job manager to perform parameter sweeps](#parameter_sweeps)
2. [Including Matrial Dispersion](#paragraph2)
    1. Material Dipsersion Models
    2. Using SLURM and Matlab to generate a parameter list to simulate

## Fixed Index Simulations <a name="fixed_index_sims"></a>
In this section we consider simulating the band diagram of a simple rectangular GaAs waveguide on a diamond substrate, with a background of air.
This example simulates a single device instance at a fixed index value to generate a band dispersion diagram as well as to compute the group velocity at different k points. We additionally are able to simulation electric field profiles, compute mode overlaps, and plot mode profiles/

### Band Simulation <a name="Band_simulation"></a>
We assume the reader has read through the [MPB scheme tutorial](https://mpb.readthedocs.io/en/latest/Scheme_Tutorial/), but we will in any case walk through executing the code. We will walk through the various pieces of the code, then show how we can use the command terminal to grep the outputs that we care about, and subsequently use matlab to clean up and plot the results.

The first thing we need to do is to define the standard unit of our simulation window. Given that maxwell's equations are scale-invariant, MPB simulations are run using without any explicit physical unit of distance. It is thus up to use to define our geomtric objects with respect to some standard unit, and to subsequently use this unit for converting between real and MPB units. In our case, we will use a standard unit a=1um which will be the reference point for defining our simulation window size, waveguide dimensions, and etc. For more info, see the MPB page on [units](https://mpb.readthedocs.io/en/latest/Scheme_Tutorial/#a-few-words-on-units).

To convert between real and MPB units we can use the following conversion table.

| MPB Ouput | Conversion to Real Units               |
|----------|-------------------------|
| &omega;<sub>mpb</sub>  | &omega; = (2 &pi; c / a ) &omega;<sub>mpb</sub> |
| k<sub>mpb</sub>        | k = (2 &pi; c / a) k<sub>mpb</sub>          |
| &lambda;<sub>mpb</sub> | &lambda; = a / &omega;<sub>mpb</sub>             |

Where our choise of a defines our real units. For example, if our simulation is defined in terms of a = $1 \mu m$, then an MPB frequency $\omega_{mpb} = 0.5$ corresponds to a physical wavelength of $\lambda$ = $\frac{1 \mu m}{0.5} = 2 \mu m$.

With this discussion of units out of the way, we can define the physical parameters of our simulation. The first thing we need to do is decide the size of our simulation region. It is important that the simulation window be large enough so that we avoid any simulation artefacts from folding of the bands for our choice of supercell region. For more info we refer the reader to the following [excellent text](http://ab-initio.mit.edu/book/). In our case we will consider a 500nm x 1000nm cross-section waveguide, so a simulation window of 10&mu;m x 10&mu;m will be more than sufficient.

Next, we define our simulation window and waveguide dimension variables. We consider our waveguide to be oriented along the x direction, we will define our structures in the YZ plane. We will define all our parameters using the "define-param" function in mpb as it will allow us to change some of the parameters when executing the simulation without having to modify the code itself. We will discuss this further in the section on [parameter sweeps](link).

```scheme
(define-param w 1)              ;Width of the waveguide in units of a (e.g. here 0.28 = 0.28um since a=1um)
(define-param h 0.5)            ;Height of the waveguide
(define-param Y 10)             ;Size of computational cell in Y direction, in units of a
(define-param Z 10)             ;Size of computational cell in Z direction
```

Next, we need to define the permittivity values for our geometrical objects. In our case we consider a GaAs waveguide on a Diamond substrate, and we use the index values for &lambda; = 1250nm. For more information on the importance of material dispersion values, [see the later section](link).

```scheme
(define-param eps_wg 12)        ;The permittivity of the waveguide; GaAs in this case
(define-param eps_bkg 1)        ;The permittivity of the background media, vacuum in this case
(define-param eps_sub 5.7)      ;The permittivity of the substrate, Diamond in this case
```

Now that we have initialized all our object variables, we can go ahead and define our structures. We start by defining our background material, vacuum in our case, then we define a block of diamond which is our substrate material. We then define our waveguide. We do a little bit of math to make sure our waveguide lies directly on our substrate.

```scheme
;Define the geometric lattice and the waveguide 
;Waveguide normal is taken to be in the x direction
;We set no-size in both X as there is no variation in this directions
;We are thus left with a 2D problem (YZ plane cross-section)                                  

(set! geometry-lattice (make lattice (size no-size Y Z)))
(set! default-material (make dielectric (epsilon eps_bkg)))     ;Define the surrounding media
(set! geometry
    (list   (make block                                         ;Define our substrate block
            (center 0 0 (- (- 0 (/ h 2)) (/ Z 6)))              ;We do a little math to make sure the substrated is centered such that it lines up with the bottom of the waveguide
            (size infinity Y (/ Z 3))                           ;We define the size of the substrate to be arbitrarily large
            (material (make dielectric (epsilon eps_sub))))     ;Define the substrate material by its permittivity
            (make block                                         ;Define the waveguide
            (center 0 0 0)                                      ;Center the waveguide
            (size infinity w h)                                 ;Define the waveguide YZ cross-section
            (material (make dielectric (epsilon eps_wg))))))    ;Define waveguide material
```

Next, we define the resolution of our simulation. The resolution defines the number of simulation points per unit a. We will use a resolution of 64 which corresponds to a physical grid resolution of ~16nm.

```scheme
(set-param! resolution 64)      ;Define the # of pixels per unit distance (a) in the simulation
```

Lastly, we need to define what it is we want to compute. First, we need to define which k-points we want to execute our simulation at. As we are interested in seeing our band profile, we will define a uniformly spaced grid of k-points covering a large range.

We then define the number of bands we want to simulate, one in our case as we want to look at the fundamental mode, and lastly we add an additional output function to the "run" command instructing mpb to compute the group velocity at each k-point in addition to computing the corresponding frequency. It is at this point that we again caution the reader on the importance of material dispersion for accurately computing the group velocity at a large range of wavelengths. We recommend taking the time to understand how mpb [computes](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/#group-velocities) the group velocity. We will discuss this further in the [material dispersion](link) section.

```scheme
(set-param! resolution 64)                                               ;Define the # of pixels per unit distance (a) in the simulation
;Define the quantities to compute
(set! k-points (interpolate 250 (list (vector3 0 0 0) (vector3 5 0 0)))) ;Calculate k values between k=0 to k=5
(set-param! num-bands 1)                                                 ;Number of freqency bands to compute. In our case we care only about the fundamental mode
(run display-group-velocities)                                           ;We run the simulation with an additional output of the group velocities
```
Now that we have walked through setting up our simulation code, we can put everything together into a .ctl file that we name [wg3d.ctl](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Simulation%20Code/wg3d_vg.ctl) and run it using MPB. To do this we simply navigate to the location where the ctl file is saved in our terminal and execute the command

```C
mpb wg3d_gvd.ctl >& wg_gvd.out
```
This executes the simulation and saves the output into the wg_gvd.out file. Now we can grep the outputs of interest:

```C
grep freqs wg_gvd.out > wg_gvd-0.5-1-bands.dat
grep velocity wg_gvd.out > wg_gvd-0.5-1-vel.dat
```

At this point one can use their method of choice for cleaning up and displaying the data. We use matlab for our processing, with all scripts available [here](https://github.com/abulnaga1/MPB_Simulations/tree/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code). To look at the &omega; vs k dispersion curve we can simply call the function [band_plotter(h,w)](https://github.com/abulnaga1/MPB_Simulations/edit/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code/band_plotter.m) which takes as input the waveguide dimensions (h - height, w - width) and produces a plot Band_Dispersion.fig. We can similarly plot the group velocity and dispersion as a function of wavelength using the [vg_plotter.m](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code/vg_plotter.m) and [D_plotter.m](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code/D_plotter.m) files in the analysis code folder. Our matlab code assumes the mpb outputs to be stored in a folder named "h-w" where h and w correspond to the height and width of the waveguide respectively. Importantly the dispersion is calculated from the group velocity curve; it is not a direct simulation output. Example plots for our 500nm x 1000nm waveguide can be found in the [examples folder](https://github.com/abulnaga1/MPB_Simulations/tree/master/No%20Dispersion%20Parameter%20Sweeps/Examples/500nm%20x%20100nm%20waveguide) and are provided below. Again it is extremely important to recognize that these simulations are run at fixed indices of refraction so that material dispersion effects are not included. We will return to the discussion on including material dispersion in a later section.

![alt text](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/Examples/500nm%20x%20100nm%20waveguide/band_Dispersion.png "Band dispersion") 
![alt text](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/Examples/500nm%20x%20100nm%20waveguide/Vg_vs_L_real_units.png "Group velocity")
![alt text](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/Examples/500nm%20x%20100nm%20waveguide/Dispersion_vs_L_real_units.png "Dispersion")


### Electric Field Simulations <a name="field_simulations"></a>
In addition to simulating the band dispersion for our waveguide, we can look at the complex-valued electric field amplitude. The simulation file [wg3d_e_fields](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Simulation%20Code/wg3d_e_fields.ctl) is quite similar to our band simulation in the previous section with a few key changes. We will make use of the mpb [find-k](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/#the-inverse-problem-k-as-a-function-of-frequency) feature to solve for the electric field at a chosen frequency without knowing apriori the corresponding k-point. At the top of our simulation window we add the following four commands

```scheme
(define-param omega 0.64516)    ;w_1550 = 0.64516129032 , w_946 = 1.05708245243
(define-param kguess 2.5)		;Guessed k value
(define-param kmin 0)			;kmin_tel = 0, kmin_siv = 1.5
(define-param kmax 5)           ;kmax_tel = 3, kmax_siv = 4.5 
```

As the names suggest, omega is the frequency point of interest in mpb units. In this case, an mpb frequency of 0.64516 corresponds to a free space wavelength of 1550nm.
To find the k-point corresponding to this frequency and calculate the electric fields at this point we simply run the following command

```scheme
(find-k NO-PARITY omega 1 1 (vector3 1 0 0) 0.0001 kguess kmin kmax fix-efield-phase output-efield)
```
As before we run the simulation from our terminal using the mpb command

```C
wg3d_e_fields.ctl >& wg3d_e_fields_tel-0.5-1.out
```

The field amplitudes are saved as a .h5 file 'wg3d_e_fields-e.k01.b01.h5'. One can use their h5 editor of choice to analyze the fields, or if more convenient this data can be converted to .txt files for further processing.

```
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.i >& e-1550-h-0.5-w-1-x-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:x.r >& e-1550-h-0.5-w-1-x-r.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.i >& e-1550-h-0.5-w-1-y-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:y.r >& e-1550-h-0.5-w-1-y-r.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:z.i >& e-1550-h-0.5-w-1-z-i.txt
h5totxt -0 -x 0 wg3d_e_fields-e.k01.b01.h5:z.r >& e-1550-h-0.5-w-1-z-r.txt
```

Where we have separately extracted each field amplitude component. The matlab file [overlap_calculator.m](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code/overlap_calculator.m) provides an example of how one can simulate the field amplitudes at two different frequencies then approximate the overlap between the two modes using a trapezoidal integral. This code restricts the integral to the waveguide region and so the output dielectric profile is required. MPB provides the dielectric function in .h5 format which can also be converted to text.

```C
h5totxt -0 -x 0 wg3d_e_fields-epsilon.h5:data >& epsilon-0.5-1.txt
```

Where we have taken a slice of the YZ plane in which our waveguide is defined by specifying the normal axis by the "-x" flag.
If instead of the full field amplitudes we only wanted the field power, we could modify our run command as follows

```scheme
(find-k NO-PARITY omega 1 1 (vector3 1 0 0) 0.0001 kguess kmin kmax output-dpwr)
```
and simply use the [h5topng](https://github.com/NanoComp/h5utils/blob/master/doc/h5topng-man.md) command to produce an image of the mode profile.


### Using a Job Manager to Perform Parameter Sweeps <a name="parameter_sweeps"></a>
In our MPB code thus far we have been making use of the MPB "define-param" command to initialize our variables of interest. An added benefit of defining our variables in advance is that we can use a single MPB .ctl file to run simulations with different geometries, materials, target wavelengths, etc... For example, in the previous section we discussed creating a simulation file "wg3d.ctl" and executing the simulation from the terminal by calling "mpb wg3d_gvd.ctl >& wg_gvd.out" to run and store the output. In this simulation we considered a 500nm x 1000nm waveguide. If we wanted to see how changing the width of the waveguide affects our bands we could open the file and change our "w" parameter, but we could also simply change the width in the terminal when we execute the simulation. For example, let's say we want to run the same simulation with a width of 1200nm instead of 1000nm. We would do the following:

```C
mpb w=1.2 wg3d_gvd.ctl >& wg_gvd.out
```

This command tells mpb to execute our simulation with the parameter "w" set to 1.2 in MPB units. Similarly, we could change any of the defined parameters such as the waveguide height, "h", the waveguide permittivitiy, "eps_wgd", etc... 

With this, we can easily see how we could run a parameter sweep wherein we change for example the width and height of the waveguide, and see how the bands change. The file [batch_submitter.cmd](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Simulation%20Code/batch_submitter.cmd) gives an example of how we could do exactly this. We make use of a job submitter, [SLURM](https://slurm.schedmd.com/sbatch.html) in our case, execute a series of simulations with different waveguide heights and widths as defined by an array of tuples. The batch submitter creates a new folder for each simulation we plan to execute, copies the .ctl files into the folders, then executes the simulations with the desired parameters, extracts the outputs of interests, and cleans up the leftover .h5 files which can take up a lot of memory. The desired tuple array is can be generated using the [tuple_generator.m](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Simulation%20Code/tuple_generator.m) file which creates a text file and a matlab variable file with the parameter instances formatted for copy-pasting directly into the batch submitter. All of our matlab analysis code is setup to process the resultant data as formatted by the batch submitter. For example the [worker_master.m](https://github.com/abulnaga1/MPB_Simulations/blob/master/No%20Dispersion%20Parameter%20Sweeps/MPB%20Analysis%20Code/worker_master.m) imports the simulated tuples and sweeps over all the folders to extract and plot the data.
