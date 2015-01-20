f = 40000; %frequency = 40 kHz
lambda = 340/f; %wavelength;

%nx = 5; ny = 8;
%coordinates of X, Y positions from center in mm
%X1 = linspace(-40.5, 31.5, nx);
%X2 = linspace(-31.5, 40.5, nx);
%posX = [X1; X2; X1; X2; X1; X2; X1; X2];

%Y1 = transpose(linspace(-59.5, 59.5, ny));
%posY = [Y1 Y1 Y1 Y1 Y1];
%posZ = zeros(ny, nx);

%simple values first:
numx = 2; numy = 2; %no of speaker elements along xyplane
posX = [2 -2];
posY = [0 0];
posZ = [0 0];

%scale of model in mm
X = -200:10:200; 
Z = 0:10:1000;
nx = numel(X); nz = numel(Z);
S = zeros(nx, nz);

%polar plot
pi2 = 2*pi;
theta = 0:0.01:pi2;
%values of signal strength along a line from an angle from center
rho = zeros(numel(theta), 100);

%measure signals across the y = 0, xz plane
x = 1; z = 1;
for i = X(1): X(2)-X(1) : X(nx)
    for k = Z(1): Z(2)-Z(1) : Z(nz)
        radiuses = sqrt( (posX-i).^2 + (posY).^2 + (posZ-k).^2 ); 
        signals = cos(2*pi*radiuses/lambda); %assume no phase now
        S(x, z) = sum(signals);
        
        %compute angle from center and add sig strength to list of 
        %sig strengths from that angle
        angle = mod(pi2 + atan2(k, i), pi2); 
        [M, I] = min(abs(theta-angle));
        nonzeroelms_cnt = nnz(rho(I, :));
        rho(I, nonzeroelms_cnt + 1) = S(x, z);

        z = z+1;
    end
    x = x+1;
    z = 1;
end

figure;
surf(abs(S));
zhandle = colorbar;

%get mean of sig strength at every angle and normalize
%to get mean of each row, get mean of transpose
rho = mean(rho.');rho = rho/max(rho);
figure;
polar(theta, rho);


