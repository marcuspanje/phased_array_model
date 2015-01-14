f = 1000; %frequency
lambda = 340/f;
A = 10; %coeff
nx = 100;
ny = 100;
X = linspace(-10, 10, nx);
Y = linspace(-10, 10, ny);
S = zeros(nx, ny);
xstep = X(2)-X(1);
ystep = Y(2)-Y(1);
x = 1;
y = 1;
for i = X(1):xstep:X(nx)
    for j = Y(1):ystep:Y(ny)
        r = sqrt(i^2 + j^2);
        theta = atan(j/i);
        S(x, y) = A*cos(2*pi*r/lambda);
        y = y+1;
    end
    x = x+1;
    y = 1;
end

surf(S);
zhandle = colorbar;
