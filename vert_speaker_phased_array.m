f = 40000; %frequency = 40 kHz
lambda = 1000*340/f; %wavelength in mm;

%coordinates of X, Y positions from center in mm
numx = 5; numy = 8;
X1 = linspace(-40.5, 31.5, numx);
X2 = linspace(-31.5, 40.5, numx);
posX = [X1; X2; X1; X2; X1; X2; X1; X2];

Y1 = transpose(linspace(-59.5, 59.5, numy));
posY = [Y1 Y1 Y1 Y1 Y1];
posZ = zeros(numy, numx);
phi = pi;

%create phase matrix
phase1 = [0 2*phi 4*phi 6*phi 8*phi];
phase2 = [phi 3*phi 5*phi 7*phi 9*phi];
phase = [phase1;phase2;phase1;phase2];
phase = [phase;phase];
 
plot_phased_array(posX, posY, posZ, phase, lambda);
