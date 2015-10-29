%----------------------
%generate speaker matrix of this shape:

%1 2 3 
% 4 5 6
%7 8 9

%center of board is x=0, y=0, z=0
%units are in mm
%inputs:
%numx: #rows, numy: #cols
%diameter: diameter of the speaker
%angle: desired angle of soundbeam from normal
%Fs: sampling frequency (to convert cts time to discrete time units)

%outputs:
%posX(i), posY(i), posZ(i) are the coords of speaker in ith position
%Delay_i(i) is the delay in discrete time units of speaker in ith position
%----------------------

function[posX, posY, posZ, Delay_i] = generate_speaker_matrix(numx, numy, diameter, angle, Fs) 
%coordinates of X, Y positions from center in mm
posX = zeros(numx, numy);
posY = zeros(numx, numy);
posZ = zeros(numx, numy);


%symmetry of a row of speakers is different if numX is even or odd,
%and is shifted back and forth each row
X1 = zeros(1, numy);
X2 = zeros(1, numy);
if (mod(numy, 2) == 1) %numx is odd
  halfY = (numy - 1)/2;
  X1 = linspace(-diameter * halfY, diameter * halfY, numy); 
else % numx is even 
  halfY = numy/2;
  X1 = linspace(-diameter * halfY + diameter/2, diameter * halfY - diameter/2, numy);
end

X2 = X1 + diameter/2;
%interleave X1 and X2 for numy rows
for i = 1:numx
  if (mod(i, 2) == 1)
    posX(i, :) = X1;
  else
    posX(i, :) = X2;
  end
end

%vertical cols of speaker form an equilateral triangle:
%1 2 
% 3
%compute h, vertical distance between consecutive speaker rows
%compute y1, which is topmost y coordinate based on numy
h = diameter*sin(pi/3);
y1 = 0;
if (mod(numx, 2) == 1)
  y1 = h*numx/2 - h/2;
else
  y1 = h*(numx-1)/2; 
end

for i = 1:numx
  for j = 1:numy
    posY(i, j) = y1 - h*(i-1);
  end
end

%----------------------
%generate delay matrix
%----------------------

%angle is desired degree of beam from normal
td = (posX(2)-posX(1))*sind(angle)/(1000*340); 
td_i = td * Fs;
Delay_i = zeros(numx, numy);

for i = 1:numx
  for j = 1:numy
    Delay_i(i, j) = (j-1)*td_i;
  end
end
    
