%parameters
%units in mm, s
fclk = 50E6; %fpga freq
vs = 340E3; % speed of sound in air
d = 5.588; %spacing between consecutive columns
angles = linspace(2, 30, 8);
t_ud = d * sind(angles / vs);
sr_ud = round(t_ud * fclk);
neg_angles = fliplr(angles);
neg_sr_ud = fliplr(sr_ud);

fid = fopen('delay_code.v', 'w+');
fprintf(fid, '//delay code for negative angles\n\n');

%genereate delay code for negative angles
for i = 1:8
  fprintf(fid, '//delay for angle -%d\n', neg_angles(i));
  for j = 0:19
    ind = 8500 - j * neg_sr_ud(i);
    fprintf(fid, 'signal[%d] <= delay_w[%d];\n', j, ind);
  end
  fprintf(fid, '\n');
end 

fprintf(fid, '\n//delay code for positive angles\n\n');
for i = 1:8
  fprintf(fid, '//delay for angle %d\n', angles(i));
  for j = 0:19
    ind = j * sr_ud(i);
    fprintf(fid, 'signal[%d] <= delay_w[%d];\n', j, ind);
  end
  fprintf(fid, '\n');
end 

