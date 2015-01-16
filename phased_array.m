f = 40000; %frequency
lambda = 340/f;
A = 10; %coeff
nx = 100;
ny = 100;
X = linspace(-2, 2, nx);
Y = linspace(-2, 2, ny);
S = zeros(nx, ny);
xstep = X(2)-X(1);
ystep = Y(2)-Y(1);

%speaker positions
x0 = 0.5; y0 = 0;
x1 = -0.5; y1 = 0;
x2 = 0; y2 = 0;
d0 = pi/4;
d1 = 0;
d2 = -pi/4;
%polar plot
thetas = 0:0.01:2*pi;
nthetas = numel(thetas);
r = zeros(nthetas, 1);

%counters
x = 1; y = 1;

for i = X(1):xstep:X(nx)
    for j = Y(1):ystep:Y(ny)
        r0 = sqrt((i-x0)^2 + (j-y0)^2);
        r1 = sqrt((i-x1)^2 + (j-y1)^2);
        r2 = sqrt((i-x2)^2 + (j-y2)^2);
        S(x, y) = A*cos(2*pi*r0/lambda + d0) + A*cos(2*pi*r1/lambda + d1) + A*cos(2*pi*r2/lambda + d2);

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
