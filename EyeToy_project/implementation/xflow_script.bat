@ECHO OFF
@REM ###########################################
@REM # Script file to run the flow 
@REM # 
@REM ###########################################
@REM #
@REM # Command line for ngdbuild
@REM #
ngdbuild -p xc6slx16csg324-3 -nt timestamp -bm eyetoy.bmm "C:/temp/implementation/eyetoy.ngc" -uc eyetoy.ucf eyetoy.ngd 

@REM #
@REM # Command line for map
@REM #
map -o eyetoy_map.ncd -w -pr b -ol high -timing -detail eyetoy.ngd eyetoy.pcf 

@REM #
@REM # Command line for par
@REM #
par -w -ol high eyetoy_map.ncd eyetoy.ncd eyetoy.pcf 

@REM #
@REM # Command line for post_par_trce
@REM #
trce -e 3 -xml eyetoy.twx eyetoy.ncd eyetoy.pcf 

