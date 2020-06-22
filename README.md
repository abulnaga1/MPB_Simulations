# MPB_Simulations
MPB Simulation code for GaAs photonics project

# Simulating a simple waveguide using MPB

This document introduces a very basic example for simulating a waveguide in the [MPB eigenmode solver](https://mpb.readthedocs.io/en/latest/) and to subsequently analyzing the output.
The purpose is not to give a comprehensive introduction to MPB, but rather to demonstrate how it can be used for a variety of applications including calculating band structures, mode profiles, and group velocities both with and without the inclusion of material dispersion. In particular, we demonstrate how MPB can be used for running large parameter sweeps for optimizing some parameter of interest. The mpb code uses the [scheme](https://mpb.readthedocs.io/en/latest/Scheme_User_Interface/) user interface, and can be executed either directly from the terminal or using a workload manager such as [slurm](https://slurm.schedmd.com/sbatch.html). Analysis of the simulation output is done in Matlab, but can readily adapted to Python if desired.
