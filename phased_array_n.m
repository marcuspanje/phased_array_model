f = 40000; %frequency = 40 kHz
lambda = 340/f; %wavelength;

nx = 5; ny = 8;
%coordinates of X, Y positions from center in mm
X1 = linspace(-40.5, 31.5, nx);
X2 = linspace(-31.5, 40.5, nx);
posX = [X1; X2; X1; X2; X1; X2; X1; X2];

Y1 = transpose(linspace(-59.5, 59.5, ny));
posY = [Y1 Y1 Y1 Y1 Y1];
posZ = zeros(ny, nx);


%scale of model in mm
X = -200:0.5:200;
Y = -200:0.5:200; 
Z = 0:0.5:1000;
nx = numel(X); ny = numel(Y); nz = numel(Z);
S = zeros(nx, ny, nz);

%for loop counters
x = 1; y = 1; z = 1;
for i = X(1): X(2)-X(1) : X(nx)
    for j = Y(1): Y(2)-Y(1) : Y(ny)
        for k = Z(1): Z(2)-Z(1) : Z(nz)
            radiuses = sqrt( (posX-i).^2 + (posY-j).^2 + (posZ-k).^2 ); 
            signals = cos(2*pi*radiuses/lambda);
            S(x, y, z) = sum(sum(signals));
            z = z+1;
        end
        y = y+1;
        z = 1;
    end
    x = x+1;
    y = 1;
    z = 1;
end

