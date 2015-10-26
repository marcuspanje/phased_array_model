plot_phased_array.m

Plotting function for phased array model.
Maps out a plane orthogonal to speaker surface, and plots 
cumulative signal amplitude in xy and polar coords

Input: posX, posY, posZ are vectors of coords of speakers, with 
origin at board center. 
posX(i), posY(i), posZ(i), phase(i) refer to one source
fund_f is the main pwm frequency of the sawtooth wave. The strongest frequency
theta_peak is the angle of the desired max from the normal
td is the unit time delay between consecutive cols
theta_peak and td are calculated outside
Output S: signal ampl  according to coords,
S_angle: signal ampl according to angle


