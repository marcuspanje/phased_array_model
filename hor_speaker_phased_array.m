f = 40000; %frequency = 40 kHz
lambda = 1000*340/f; %wavelength in mm;

%board dimensions: 175 x 95 mm
%coordinates of X, Y positions from center in mm
numx = 7; numy = 6;

X1 = linspace(-58.5, 49.5, numx);
X2 = linspace(-49.5, 58.5, numx);
posX = [X1; X2; X1; X2; X1; X2];

Y1 = transpose(linspace(-42.5, 42.5, numy)); %col vector
posY = [Y1 Y1 Y1 Y1 Y1 Y1 Y1];

posZ = zeros(numy, numx);
phi = 0;

%create phase matrix
phase1 = [0 2*phi 4*phi 6*phi 8*phi 10*phi 12*phi];
phase2 = [phi 3*phi 5*phi 7*phi 9*phi 11*phi 13*phi];
phase = [phase1;phase2;phase1;phase2;phase1;phase2];
 
plot_phased_array(posY, posX, posZ, phase, lambda);
