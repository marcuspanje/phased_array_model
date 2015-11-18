%parameters
%units in mm, s
fclk = 50E6; %fpga freq
vs = 340E3; % speed of sound in air
d = 5.588; %spacing between consecutive columns
delay = 0:19; %20 columns
angle = 30; %beam angle in degrees from normal
t_ud = d * sind(angle) / vs %unit delay
nsr_ud = round(t_ud * fclk); %unit delay in #shift registers
delay_sr = (0:19) * nsr_ud
