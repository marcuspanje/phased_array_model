%Plotting function for phased array model.
%Maps out a plane orthogonal to speaker surface, and plots 
%cumulative signal amplitude in xy and polar coords

%Input: posX, posY, posZ are vectors of coords of speakers, with 
%origin at board center. 
%posX(i), posY(i), posZ(i), phase(i) refer to one source
%theta_peak is the angle of the desired max from the normal
%td is the unit time delay between consecutive cols
%theta_peak and td are calculated outside
%Output S: signal ampl  according to coords,
%S_angle: signal ampl according to angle

function [S, S_angle] = plot_phased_array(posX, posY, posZ, delay, theta_peak, td)
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

%measure signals across the y = 0, xz plane
x = 1; z = 1;
for i = X(1) : xstep : X(nx)
    for k = Z(1) : zstep : Z(nz)
        radiuses = sqrt( (posX-i).^2 + (posY).^2 + (posZ-k).^2 ); 
        t = radiuses/v;
        signals = cos(2*pi*40000*(t-delay));
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

