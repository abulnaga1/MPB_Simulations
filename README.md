# Simulating a simple waveguide using MPB

This document introduces a very basic example for simulating a waveguide in the [MPB eigenmode solver](https://mpb.readthedocs.io/en/latest/) and to subsequently analyzing the output.
The purpose is not to give a comprehensive introduction to MPB, but rather to demonstrate how it can be used for a variety of applications including calculating band structures, mode profiles, and group velocities both with and without the inclusion of material dispersion. In particular, we demonstrate how MPB can be used for running large parameter sweeps for optimizing some parameter of interest. The mpb code uses the [scheme](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/) user interface, and can be executed either directly from the terminal or using a workload manager such as [slurm](https://slurm.schedmd.com/sbatch.html). Analysis of the simulation output is done in Matlab, but can readily adapted to Python if desired.

# Table of contents
1. [Introduction](#introduction)
2. [Fixed Index Simulations](#fixed_index_sims)
    1. [Band simulation](#Band_simulation)
    2. Electric field simulations
    3. Mode profile simulation
3. [Including Matrial Dispersion](#paragraph2)
    1. Material Dipsersion Models
    2. Using SLURM and Matlab to generate a parameter list to simulate
    
## This is the introduction <a name="introduction"></a>
Some introduction text, formatted in heading 2 style

## Fixed Index Simulations <a name="fixed_index_sims"></a>
In this section we consider simulating the band diagram of a simple rectangular GaAs waveguide on a diamond substrate, with a background of air.
This example simulates a single device instance at a fixed index value to generate a band dispersion diagram as well as to compute the group velocity at different k points. We additionally are able to simulation electric field profiles, compute mode overlaps, and plot mode profiles/

### Band Simulation <a name="Band_simulation"></a>
We assume the reader has read through the [MPB scheme tutorial](https://mpb.readthedocs.io/en/latest/Scheme_Tutorial/), but we will in any case walk through executing the code. We will walk through the various pieces of the code, then show how we can use the command terminal to grep the outputs that we care about, and subsequently use matlab to clean up and plot the results.

The first thing we need to do is to define the standard unit of our simulation window. Given that maxwell's equations are scale-invariant, MPB simulations are run using without any explicit physical unit of distance. It is thus up to use to define our geomtric objects with respect to some standard unit, and to subsequently use this unit for converting between real and MPB units. In our case, we will use a standard unit a=1um which will be the reference point for defining our simulation window size, waveguide dimensions, and etc. For more info, see the MPB page on [units](https://mpb.readthedocs.io/en/latest/Scheme_Tutorial/#a-few-words-on-units).

To convert between real and MPB units we can use the following conversion table.

| MPB Ouput | Conversion to Real Units               |
|----------|-------------------------|
| &omega;<sub>mpb</sub>  | &omega; = $\frac{2 \pi c}{a}$&omega;<sub>mpb</sub> |
| k<sub>mpb</sub>        | k = $\frac{2 \pi c}{a}$k<sub>mpb</sub>          |
| &lambda;<sub>mpb</sub> | &lambda; = $\frac{a}{\omega_{mpb}}$             |

Where our choise of a defines our real units. For example, if our simulation is defined in terms of a = $1 \mu m$, then an MPB frequency $\omega_{mpb} = 0.5$ corresponds to a physical wavelength of $\lambda$ = $\frac{1 \mu m}{0.5} = 2 \mu m$.

With this discussion of units out of the way, we can define the physical parameters of our simulation. The first thing we need to do is decide the size of our simulation region. It is important that the simulation window be large enough so that we avoid any simulation artefacts from folding of the bands for our choice of supercell region. For more info we refer the reader to the following [excellent text](http://ab-initio.mit.edu/book/). In our case we will consider a 500nm x 1000nm cross-section waveguide, so a simulation window of 10&mu;m x 10&mu;m will be more than sufficient.

Next, we define our simulation window and waveguide dimension variables. We consider our waveguide to be oriented along the x direction, we will define our structures in the YZ plane

(define-param w 1)              ;Width of the waveguide in units of a (e.g. here 0.28 = 0.28um since a=1um)
(define-param h 0.5)            ;Height of the waveguide
(define-param Y 10)             ;Size of computational cell in Y direction, in units of a
(define-param"Z 10)             ;Size of computational cell in Z direction

Next, we need to define the permittivity values for our geometrical objects. In our case we consider a GaAs waveguide on a Diamond substrate, and we use the index values for &lambda; = 1250nm. For more information on the importance of material dispersion values, [see the later section](link).

(define-param eps_wg 12)        ;The permittivity of the waveguide; GaAs in this case
(define-param eps_bkg 1)        ;The permittivity of the background media, vacuum in this case
(define-param eps_sub 5.7)      ;The permittivity of the substrate, Diamond in this case

Now that we have initialized all our object variables, we can go ahead and define our structures. We start by defining our background material, vacuum in our case, then we define a block of diamond which is our substrate material. We then define our waveguide. We do a little bit of math to make sure our waveguide lies directly on our substrate.

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
            
Next, we define the resolution of our simulation. The resolution defines the number of simulation points per unit a. We will use a resolution of 64 which corresponds to a physical grid resolution of ~16nm.

(set-param! resolution 64)                                               ;Define the # of pixels per unit distance (a) in the simulation

Lastly, we need to define what it is we want to compute. First, we need to define which k-points we want to execute our simulation at. As we are interested in seeing our band profile, we will define a uniformly spaced grid of k-points covering a large range.

We then define the number of bands we want to simulate, one in our case as we want to look at the fundamental mode, and lastly we add an additional output function to the "run" command instructing mpb to compute the group velocity at each k-point in addition to computing the corresponding frequency. It is at this point that we again caution the reader on the importance of material dispersion for accurately computing the group velocity at a large range of wavelengths. We recommend taking the time to understand how mpb [computes](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/#group-velocities) the group velocity. We will discuss this further in the [material dispersion](link) section.

(set-param! resolution 64)                                               ;Define the # of pixels per unit distance (a) in the simulation
;Define the quantities to compute
(set! k-points (interpolate 250 (list (vector3 0 0 0) (vector3 5 0 0)))) ;Calculate k values between k=0 to k=5
(set-param! num-bands 1)                                                 ;Number of freqency bands to compute. In our case we care only about the fundamental mode
(run display-group-velocities)                                           ;We run the simulation with an additional output of the group velocities

Now that we have walked through setting up our simulation code, we can put everything together into a .ctl file and run it using MPB.
We could also have entered mpb in interactive mode and run the commands one at at time, but executing the code from saved files will allow us to later perform parameter sweeps by simply changing our defined parameters when executing the simulation. We will touch on this briefly.
