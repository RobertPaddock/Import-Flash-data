# Import-Flash-data
These scripts use the yt python package to import Flash data into arrays of position vs time vs density/pressure.

The yt fixed resolution buffer is store density/pressure against position for a single timestep. We then loop over all files/timesteps to make an array of consistent dimensions and form for each timestep. These are saved as csv files, with another file listing the timesteps.

These files are a) much smaller than the main data, and b) much more intuitive to read and open in other codes.

I have included a few files:

**Plots_yt**
This script plots the FRB at a single timestep directly. It allows the user to explore the FRB and the different options, and determine the correct center/width that should be used for the import.

**MassFlashImport**
Imports the density data at each timestep, saving them as sequentially numbered csv files. Also saves the timesteps as a seperate file.

**MassFlashImport_Pressure**
As above, but saves the pressure data at each timestep. These two scripts could quite easily be combined into one if desired.

**FlashLoad**
Example script loading this density and pressure data into Matlab. The script does a number of things specific to my simulations (e.g. the plots), but show how this data can be imported to produce plots of density vs postion vs time etc..
