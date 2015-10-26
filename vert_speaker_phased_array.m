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

%theta is desired degree of beam from normal
theta = 30;
td = (posX(2)-posX(1))*sind(theta)/(1000*340); 
%td = 10.851E-6;
delay1 = [0 2*td 4*td 6*td 8*td];
delay2 = [td 3*td 5*td 7*td 9*td];
delay = [delay1;delay2;delay1;delay2];
delay = [delay;delay];
 
plot_phased_array(posX, posY, posZ, f, delay, theta, td);
