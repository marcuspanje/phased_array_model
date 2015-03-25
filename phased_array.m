lambda = 340/f;
v = 340;
A = 10; %coeff
nx = 100;
ny = 100;

%model dimensions in meters
X = linspace(-0.5, 0.5, nx);
Z = linspace(0, 1, ny);
S = zeros(nx, ny);
times = zeros(nx, ny);
xstep = X(2)-X(1);
zstep = Z(2)-Z(1);

%sig = &(t, tdelay) 10*cos(2*pi*1000*(t-tdelay));

%speaker positions
x0 = 0.005; y0 = 0; z0 = 0;
x1 = -0.005; y1 = 0; z1 = 0;
px = [x0 x1];
py = [y0 y1];
pz = [z0 z1];
%td = [1.473e-3 0];% time delay in seconds
td = [1.473e-3 0];% time delay in seconds

%polar plot
thetas = 0:0.01:2*pi;
nthetas = numel(thetas);
r = zeros(nthetas, 1);

%counters
x = 1; y = 1;



for i = X(1):xstep:X(nx)
    for k = Z(1):zstep:Z(ny)
        radii = sqrt((i-px).^2 + (py).^2 + (k-pz).^2); 
        t = radii/v;
        S(x, y) = sum(10*cos(2*pi*(t + td)));  

        %polar coordinates
        %atan2 ret negatives angles, mod operations takes care of this
        theta = mod(2*pi + atan2(j, i), 2*pi);
        [M, I] = min(abs(thetas - theta));
        ncols = numel(r(I, :));
        r(I, ncols+1) = abs(S(x, y));

        y = y+1;
    end
    x = x+1;
    y = 1;
end

%mean returns an array of the means of each col.
%to get mean of each row, get mean of transpose of matrix (A.')
r1 = mean(r.'); 
r2 = r1/max(r1);
figure;
polar(thetas, r2);

figure;
surf(abs(S));
zhandle = colorbar;
view(-90, 90);
