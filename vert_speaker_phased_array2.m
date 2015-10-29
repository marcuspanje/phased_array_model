%----------------------
%generate signal
%----------------------
Fsig = 1000;
Fs = 300000;
Fswth = 40000;

t = 0:1/Fs:1;
len = max(size(t));
half_len = round(ceil(len/2));

base_signal = 1.5*cos(2*pi*Fsig*t);

%pulse width modulation
t_off = 0;
swth = 2.5*sawtooth(2*pi*Fswth*t) + 2.5;

%pwm(input, sawtooth, high, Vdc, fout, Fs, max_dutycycle)
%Vdc is offset voltage added on to input
Vdc = 2.5;
Xpwm = pwm(base_signal, swth, 5.0, Vdc, Fswth, Fs, 0.99);

%----------------------
%generate speaker matrix of this shape:
%1 2 3 
% 4 5 6
%7 8 9
%center of board is x=0, y=0
%----------------------


%coordinates of X, Y positions from center in mm
diameter = 16;
numx = 8; 
numy = 10;
angle = 15;% in degrees
[posX, posY, posZ, Delay_i] = generate_speaker_matrix(numx, numy, diameter, angle, Fs);

%----------------------
%plot_phased_array
%---------------------
xlen = 5000;
xstep = 50;
zlen = 5000;
zstep = 50;
 
plot_phased_array(posX, posY, posZ, Delay_i, xlen, xstep, zlen, zstep, Xpwm, Fs, angle, td);

