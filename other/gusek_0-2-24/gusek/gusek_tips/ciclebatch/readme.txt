# GUSEK TIPs - CicleBatch
# Luiz Bettoni, 08/2012


This sample show how to execute GLPK to solve various models in loop.

To quickly run this sample:
	1. Open ciclebatch.bat in GUSEK
		1.5. Be sure to update the gusek path variable
	2. Press GO button
	3. See sample results in output.csv


As you can see, GUSEK can interpret and handle .bat files.
Here we run a batch file from Gusek, calling glpsol.exe to solve the model with different values for the "n" parameter using a for loop.
The additional data file "tmp.dat" is recreated with the new "n" value before each execution.
The model print simple sample results to "output.csv" on every run, so all results are in a sigle file.


