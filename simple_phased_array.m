%----------------------
%generate speaker matrix
%----------------------
%coordinates of X, Y positions from center in mm
numx = 2; numy = 2; %no of speaker elements along xyplane
posX = [-3 3];
posY = [0 0];
posZ = [0 0];

%1 2 3 4 5
% 6 7 8 9 10

%----------------------
%generate signal
%----------------------
Fsig = 40000;
Fs = 300000;
Fswth = 40000;

t = 0:1/Fs:1;
len = max(size(t));
half_len = round(ceil(len/2));

base_signal = 1.5*cos(2*pi*Fsig*t);

%----------------------
%generate delay matrix
%----------------------

%theta is desired degree of beam from normal
theta = 30;
td = (posX(2)-posX(1))*sind(theta)/(1000*340); 
td_i = td*Fs;

Delay_i = [0 td_i];

%----------------------
%plot_phased_array
%---------------------
xlen = 1000;
xstep = 20;
zlen = 2000;
zstep = 20;
 
plot_phased_array(posX, posY, posZ, Delay_i, xlen, xstep, zlen, zstep, base_signal, Fs, theta, td);

