#Plotting function for phased array model
`plot_phased_array`
Maps out a plane orthogonal to speaker surface, and plots 
cumulative signal amplitude in xy and polar coords

Inputs: 
*`posX, posY, posZ` are coords of speakers, with 
origin at board center. 

posX(i), posY(i), posZ(i), phase(i) refer to one source

*`Delay_i` is the Delay matrix of each transducer, in time indices that correlate to the sampling frequency `Fs`
The delays are interleaved as follows:
0 2 4 
 1 3 5
0 2 4
 1 4 5

*`xlen` is the length of the xaxis of the model in mm 
*`xstep` is the sampling frequency for the xaxis
same for `zlen`, `zstep`

*`sig` is the signal 
*`Fs` is the sampling frequency of the signal

*`theta_label` is the angle between normal and sound beam
*`td` is the time delay between each speaker column
*`td` and `theta_label` are just used to label the plot
