f = 40000; %frequency = 40 kHz
lambda = 1000*340/f; %wavelength in mm;
theta = 0;%angle in degrees
%coordinates of X, Y positions from center in mm
numx = 2; numy = 2; %no of speaker elements along xyplane
posX = [-3 3];
posY = [0 0];
posZ = [0 0];
v = 340;% sound speed in m/s
a = posX(2) - posX(1)
td = a*sind(theta)/(1000*v)%unit time delay
delay = [td 0];

plot_phased_array(posX, posY, posZ, delay, theta, td);
