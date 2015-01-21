f = 40000; %frequency = 40 kHz
lambda = 1000*340/f; %wavelength in mm;

%coordinates of X, Y positions from center in mm
numx = 2; numy = 2; %no of speaker elements along xyplane
posX = [-100];
posY = [0];
posZ = [0];
phase = [0];

plot_phased_array(posX, posY, posZ, phase, lambda);
