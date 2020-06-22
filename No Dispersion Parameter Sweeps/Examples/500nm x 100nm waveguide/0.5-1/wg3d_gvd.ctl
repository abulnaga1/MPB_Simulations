;Simulation of a 3D GaAs waveguide on a Diamond substrate
;Author:    Alex Abulnaga
;           Modified by Sacha on the 03/25/2019
;           Princeton University
;           03/21/19
;This code follows the example given at: https://math.mit.edu/~stevenj/18.369/mpb-demo.pdf
;We will use a default lattice size of a = 1um
;The outputted frequencies are in units of c/a, the corresponding vacuum wavelength is thus lambda_0 = a/omega
;w_real = w*2pi*c/a
;lambda_real = 2*pi*c/w_real
;k_real = k*2pi/a
;Define the parameters of the structure

(define-param w 1)              ;Width of the waveguide in units of a (e.g. here 0.28 = 0.28um since a=1um)
(define-param h 0.5)            ;Height of the waveguide
(define-param Y 10)             ;Size of computational cell in Y direction, in units of a
(define-param Z 10)             ;Size of computational cell in Z direction
(define-param eps_wg 12)        ;The permittivity of the waveguide; GaAs in this case
(define-param eps_bkg 1)        ;The permittivity of the background media, vacuum in this case
(define-param eps_sub 5.7)      ;The permittivity of the substrate, Diamond in this case

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



(set-param! resolution 64)                                               ;Define the # of pixels per unit distance (a) in the simulation
;Define the quantities to compute
(set! k-points (interpolate 250 (list (vector3 0 0 0) (vector3 5 0 0)))) ;Calculate k values between k=0 to k=5
(set-param! num-bands 1)                                                 ;Number of freqency bands to compute. In our case we care only about the fundamental mode
(run display-group-velocities)                                           ;We run the simulation with an additional output of the group velocities
