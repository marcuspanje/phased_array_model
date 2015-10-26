%----------------------
%generate speaker matrix
%----------------------

%coordinates of X, Y positions from center in mm
numx = 5; numy = 8;
X1 = linspace(-40.5, 31.5, numx);
X2 = linspace(-31.5, 40.5, numx);
posX = [X1; X2; X1; X2; X1; X2; X1; X2];

Y1 = transpose(linspace(-59.5, 59.5, numy));
posY = [Y1 Y1 Y1 Y1 Y1];
posZ = zeros(numy, numx);

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
%figure();
%subplot(2, 1, 1);
%plot(t, base_signal + Vdc, t, swth, t, Xpwm);
%xlabel('t');
%ylabel('V');

%FX = fft(Xpwm);
%FX = abs(FX)/len;
%FX = 2*FX(1:half_len);
%w = linspace(0, Fs/2, half_len);

%subplot(2, 1, 2);
%plot(w, FX);
%xlabel('f');
%ylabel('M');

%----------------------
%generate delay matrix
%----------------------

%theta is desired degree of beam from normal
theta = 15;
td = (posX(2)-posX(1))*sind(theta)/(1000*340); 

%td = 10.851E-6;
delay1 = [0 2*td 4*td 6*td 8*td];
delay2 = [td 3*td 5*td 7*td 9*td];
delay = [delay1;delay2;delay1;delay2];
delay = [delay;delay];

%convert to discrete units
Delay_i = delay * Fs;

%----------------------
%plot_phased_array
%---------------------
xlen = 400;
xstep = 10;
zlen = 1000;
zstep = 10;
 
plot_phased_array(posX, posY, posZ, Delay_i, xlen, xstep, zlen, zstep, Xpwm, Fs, theta, td);

