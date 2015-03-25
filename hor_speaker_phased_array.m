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
phi = 1.75*pi;

%create time delay matrix 
theta = 30;
td = (posX(2)-posX(1))*sind(theta)/(1000*340); 
delay1 = [0 2*td 4*td 6*td 8*td];
delay2 = [td 3*td 5*td 7*td 9*td];
delay = [delay1;delay2;delay1;delay2];
delay = [delay;delay];
 
plot_phased_array(posX, posY, posZ, delay, theta, td);
