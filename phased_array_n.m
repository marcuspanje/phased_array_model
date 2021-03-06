f = 40000; %frequency = 40 kHz
lambda = 1000*340/f; %wavelength in mm;
sound_speed = 330;

%coordinates of X, Y positions from center in mm
numx = 5; numy = 8;
X1 = linspace(-40.5, 31.5, numx);
X2 = linspace(-31.5, 40.5, numx);
posX = [X1; X2; X1; X2; X1; X2; X1; X2];

Y1 = transpose(linspace(-59.5, 59.5, numy));
posY = [Y1 Y1 Y1 Y1 Y1];
posZ = zeros(numy, numx);
tdu = 0.5;%time delay unit

%create time delay matrix
td1 = [0 2*tdu 4*tdu 6*tdu 8*tdu];
td2 = [tdu 3*tdu 5*tdu 7*tdu 9*tdu];
td = [td1;td2;td1;td2];
td = [td;td];
 
%simple values first:
%numx = 2; numy = 2; %no of speaker elements along xyplane
%posX = [-100];
%posY = [0];
%posZ = [0];
%phase = [0];

%scale of model in mm
xstep = 10; zstep = 10;
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
        t = radiuses/sound_speed;
        signals = cos(2*pi*t + td);
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

figure;
surf(S);
set(gca, 'Ydir', 'reverse') %make x axis go from L-> R
zhandle = colorbar;

%get mean of sig strength at every angle.
%-1 values are NaN, so +1 and use nnz() to disregard zero values
rho1 = rho + 1;
S_angle = zeros(1, ntheta);

for i = 1:ntheta
    sigs_alng_line = rho1(i, :);
    S_angle(i) = sum(sigs_alng_line)/nnz(sigs_alng_line); 
end


figure;
S_angle = S_angle./max(S_angle);
polar(theta, S_angle, '.');


