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

function [S, S_angle] = plot_phased_array(posX, posY, posZ, Delay_i, xlen, xstep, zlen, zstep, sig, Fs, theta_label, td)

%scale of model in mm

v = 340e3; %speed of sound in mm/s

X = -xlen/2:xstep:xlen/2;
Z = 0:zstep:zlen;
nx = numel(X); 
nz = numel(Z);
S = zeros(nx, nz);

%polar plot
theta_step = 0.001;
Theta = 0:theta_step:2*pi;
ntheta = numel(Theta);

S_angle = zeros(1, ntheta);
Angle_hits = zeros(1, ntheta);

signal_len = max(size(sig));
signal_len_half = round(signal_len/2);

%measure signals across the y = 0, xz plane
x = 1; z = 1;
for i = 1:nx
    for k = 1:nz
        radiuses = sqrt( (posX-X(i)).^2 + (posY).^2 + (posZ-Z(k)).^2 ); 
        t = radiuses/v;

        %convert time to discrete indices
        ind = round(t*Fs);

        signals = sig(signal_len_half - ind - Delay_i);
        S(i, k) = abs(sum(sum(signals)));%sig strength at a point
        
        %compute angle from center, and get index of closest discretized angle.
        %add signal strength at the point to signal strength at that angle.
        %increase Angle_hits at that angle. This will be used to compute the 
        %mean signal strength at an angle, as not every angle will get an equal number of hits
        angle = atan2(Z(k), X(i)); 
        angle_i = mod(1 + round(angle*ntheta/(2*pi)), ntheta);
        S_angle(angle_i) = S_angle(angle_i) + S(i, k);
        Angle_hits(angle_i) = Angle_hits(angle_i) + 1;
    end
end

S_normalized = S./max(max(S));

%get mean of sig strength at every angle.
S_angle = S_angle./Angle_hits;
S_angle_normalized = S_angle./max(S_angle);

figure('Position', [100 100 1200 500]);
planeplot = subplot(1, 2, 1);
surf(S_normalized);
set(gca, 'Ydir', 'reverse') %make x axis go from L-> R
view(-90, 90);
zhandle = colorbar;

angularplot = subplot(1, 2, 2);
polar(Theta, S_angle_normalized, '.');
str_title = sprintf('Signal strength map:\n angle = %d deg, td = %.5f ms', theta_label, td*1000);
title(planeplot, str_title, 'FontSize', 20);

