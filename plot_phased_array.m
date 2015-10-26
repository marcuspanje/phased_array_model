%Plotting function for phased array model.
%Maps out a plane orthogonal to speaker surface, and plots 
%cumulative signal amplitude in xy and polar coords

%Input: posX, posY, posZ are vectors of coords of speakers, with 
%origin at board center. 
%posX(i), posY(i), posZ(i), phase(i) refer to one source
%fund_f is the main pwm frequency of the sawtooth wave. The strongest frequency
%theta_peak is the angle of the desired max from the normal
%td is the unit time delay between consecutive cols
%theta_peak and td are calculated outside
%Output S: signal ampl  according to coords,
%S_angle: signal ampl according to angle

function [S, S_angle] = plot_phased_array(posX, posY, posZ, fund_f, delay, theta_peak, td)
%scale of model in mm
xstep = 10; zstep = 10;
v = 340e3;%speed of sound in mm/s
X = -200:xstep:200; 
Z = 0:zstep:1000;
nx = numel(X); nz = numel(Z);
S = zeros(nx, nz);

%polar plot
theta_step = 0.001;
theta = 0:theta_step:2*pi-theta_step;
ntheta = numel(theta);
%values of signal strength along a line from an angle from center
rho = -1*ones(ntheta, nx*nz+1); %make each value -2 to  

%generate signal
Fsig = 100;
Fs = 300000;
t = 0:1/Fs:1;
len = max(size(t));
half_len = round(ceil(len/2));

base_signal = 1.5*cos(2*pi*Fsig*t);

%pulse width modulation
Fswth = fund_f;
t_off = 0;
swth = 2.5*sawtooth(2*pi*Fswth*t) + 2.5;

%pwm(input, sawtooth, high, Vdc, fout, Fs, max_dutycycle)
%Vdc is offset voltage added on to input
Vdc = 2.5;
Xpwm = pwm(base_signal, swth, 5.0, Vdc, Fswth, Fs, 0.99);
figure();
subplot(2, 1, 1);
plot(t, base_signal + Vdc, t, swth, t, Xpwm);
xlabel('t');
ylabel('V');

FX = fft(Xpwm);
FX = abs(FX)/len;
FX = 2*FX(1:half_len);
w = linspace(0, Fs/2, half_len);

subplot(2, 1, 2);
plot(w, FX);
xlabel('f');
ylabel('M');

%measure signals across the y = 0, xz plane
x = 1; z = 1;
for i = X(1) : xstep : X(nx)
    for k = Z(1) : zstep : Z(nz)
        radiuses = sqrt( (posX-i).^2 + (posY).^2 + (posZ-k).^2 ); 
        t = radiuses/v;
        %convert time to discrete indices
        ind = round(t*Fs);
        delay_ind = round(delay*Fs); 

        signals = Xpwm(round(1 + mod(ind - delay_ind, signal_len)));
        S(x, z) = abs(sum(sum(signals)));%sig strength at a point
        
        %compute angle from center and add sig strength to list of 
        %sig strengths from that angle
        angle = mod(2*pi + atan2(k, i), 2*pi); 
        [M, I] = min(abs(theta-angle));

        %NaN values are -1. store values-1 and adjust to 0 later
        %so nnz() can be used to find NaN values.
        curr_index = nnz(rho(I, :) + 1);
        rho(I, curr_index + 1) = S(x, z) - 1; 

        z = z+1;
    end
    x = x+1;
    z = 1;
end

S_normalized = S./max(max(S));

%get mean of sig strength at every angle.
%-1 values are NaN, so +1 and use nnz() to disregard zero values
rho1 = rho + 1;
S_angle = zeros(1, ntheta);

for i = 1:ntheta
    sigs_alng_line = rho1(i, :);
    S_angle(i) = sum(sigs_alng_line)/nnz(sigs_alng_line); 
end

figure('Position', [100 100 1200 500]);
planeplot = subplot(1, 2, 1);
surf(S_normalized);
set(gca, 'Ydir', 'reverse') %make x axis go from L-> R
view(-90, 90);
zhandle = colorbar;

angularplot = subplot(1, 2, 2);
S_angle = S_angle./max(S_angle);
polar(theta, S_angle, '.');
str_title = sprintf('Signal strength map:\n phiPeak = %d deg, td = %.5f ms', theta_peak, td*1000)
title(planeplot, str_title, 'FontSize', 20);

