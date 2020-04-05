@echo off
rem GUSEK TIPs - CicleBatch
rem Luiz Bettoni, 08/2012

rem set the path to your gusek folder
set GUSEKPATH="C:\gusek"

rem if exist previous output file, just kill it
del output.csv

rem a loop with k% going from 2 to 5, with step 1
for /l %%k in (2,1,5) do (

	rem just chit-chating:
	echo solving %%k...

	rem creating a temporary dat file with n parameter
	echo data; param n:=%%k; end; > tmp.dat

	rem now running glpk! 
	rem please note that you need to set the correct path to glpsol.exe (gusek folder)
	"%GUSEKPATH%\glpsol.exe" --cuts -m "buildings.mod" -d "buildings.dat" -d "tmp.dat"
)

rem remove temporary files and variables
del tmp.dat
set GUSEKPATH=
