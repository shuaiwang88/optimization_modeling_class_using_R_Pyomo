# GUSEK TIPs - MyBatch
# Luiz Bettoni, 11/2009


This sample show how to execute some script after GLPK finish the solve.

To quickly run this sample:
	1. Open bulidings.mod in GUSEK
	2. Press GO button


Q: How to specify a post-processing script (like a shell script ) that will be run once Gusek is done solving? As an example of why this is useful: let's say that you wanted to automatically ftp the results of your solve to a remote server every time you do a solve.
(Question by Yaron Kretchmer - thanks!)

A: Gusek was made like a fork of the SciTE editor dedicated to GLPK.
So, you can use SciTE native resources, like edit/include menus to run
external tools or custom scripts. Let's see what happened when you run
this sample:

The file mybatch.bat is called just after GLPK finish to solve the model. Who 
do this magic? The SciTE.properties file (know as Local Options file). Open it
and see. The settings in this file overrides global settings for models in the
same folder. In this file it adds a line (the last) to the "go" command (just
for gmpl files) - compare with the same command in gmpl.properties on GUSEK 
folder. Its a bit confuse (our GMPL model call a BATCH script as configured 
in a LUA script on GUSEK local configuration file), but you can learn more in
SciTE site (http://www.scintilla.org/SciTEFAQ.html#ToolsMenu). See more options
files under Options menu (ok, its obvious, sorry).


Notes:

I. The model is just a simple model, it has no effect on batch call. Don't 
trust me? Rename SciTE.properties (in this folder) to foo.txt, restart GUSEK
and try again.
But you can use GMPL to generate dynamic batch files too, echoing commands in
post-processing (like below), and call them after solve.
	param myfile symbolic := "test.bat";
	printf "echo off\n" > myfile;
	printf "echo Hello, there!\n" >> myfile;
	printf "pause\n" >> myfile;
	end;

II. Note that GUSEK can interpret and handle .bat files too. Seriously. Open 
mybatch.bat file in GUSEK and press GO to see.
You can also run custom batch files from Gusek, calling glpsol.exe to solve your
model, and then performing another tasks, like this:
	glpsol.exe --cuts -m "test.mod"
	call mybatch.bat
	delete *.tmp
The batch output will be show in the Gusek output pane.

III. GUSEK can run LUA script files natively if you don't like windows batch.

IV. You can read and edit .txt files (like this) in GUSEK too. Are you impressed
now, humn? =)

