%----------------------
%generate signal
%----------------------
Fsig = 1000;
Fs = 300000;
Fswth = 40000;

t = 0:1/Fs:1;
len = max(size(t));
X = sin(2*pi*Fswth*t);

%----------------------
%generate speaker matrix of this shape:
%1 2 3 
% 4 5 6
%7 8 9
%center of board is x=0, y=0
%----------------------


%coordinates of X, Y positions from center in mm
diameter = 10;
numx = 10; 
numy = 20;
angle = 0;% in degrees
[posX, posY, posZ, Delay_i] = generate_speaker_matrix(numx, numy, diameter, angle, Fs);
td = diameter * sind(angle) / 340;

%----------------------
%plot_phased_array
%---------------------
xlen = 5000;
xstep = 50;
zlen = 5000;
zstep = 50;
 
plot_phased_array(posX, posY, posZ, Delay_i, xlen, xstep, zlen, zstep, Xpwm, Fs, angle, td);

