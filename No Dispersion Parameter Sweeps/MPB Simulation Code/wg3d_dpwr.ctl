;Simulation of a 3D GaAs waveguide on a Diamond substrate
;Author:    Alex Abulnaga
;           Modified by Sacha on the 03/25/2019
;           Princeton University
;           03/21/19
;This code follows the example given at: https://math.mit.edu/~stevenj/18.369/mpb-demo.pdf
;We will use a default lattice size of a = 1um
;The outputted frequencies are in units of c/a, the corresponding vacuum wavelength is thus lambda_0 = a/omega
;w_real = w*2pi*c/a
;w_mpb = a/L
;lambda_real = 2*pi*c/w_real
;k_real = k*2pi/a
;Define the parameters of the structure

(define-param eps_hi 12)        ;Define the GaAs permittivity to be approximately the average between 946nm and 1550nm
(define-param eps_lo 1)         ;By default, surrounding media is air, but we will later change this to SiO2
(define-param eps_dia 5.7)      ;Diamond permittivity
(define-param eps_sin 4)        ;SiN permittivity (~2.00^2)
(define-param w 0.28)           ;Width of the waveguide in units of a
(define-param h 0.24)          	;Height of the waveguide
(define-param d 0.025)          ;gap between waveguide and second block
(define-param w2 0.025)         ;Width of the second block
(define-param l 0.012)          ;Thickness of the SiN layer in units of a
(define-param omega 1)          ;w_telecom = 0.64516129032 , w_siv = 1.05708245243
(define-param kguess 1)			;ktel = 1, ksiv = 3
(define-param kmin 0)			;kmin_tel = 0, kmin_siv = 1.5
(define-param kmax 2)           ;kmax_tel = 3, kmax_siv = 4.5   
(define-param Y 10)             ;Size of computational cell in Y direction, in units of a
(define-param Z 10)             ;Size of computational cell in Z direction

;Define the geometric lattice and the waveguide 
;Waveguide direction in x
;We set no-size in both X as there is no variation in this directions
;We are thus left with a 2D problem (cross-section                                  

(set! geometry-lattice (make lattice (size no-size Y Z)))
(set! default-material (make dielectric (epsilon eps_lo)))          ;Define the surrounding media
(set! geometry
    (list	(make block
			(center 0 0 (- (- 0 (/ h 2)) (/ Z 6)))
			(size infinity Y (/ Z 3))       
			(material (make dielectric (epsilon eps_dia))))    ;Diamond dielectric
		(make block
			(center 0 0 0)
			(size infinity w h)                         		;Block stretching infinitely far in x
			(material (make dielectric (epsilon eps_hi))))))   	;Define waveguide to be made from GaAs



(set-param! resolution 128)      ;Define # of pixels per unit distance (a)

(find-k NO-PARITY omega 1 1 (vector3 1 0 0) 0.0001 kguess kmin kmax output-dpwr)