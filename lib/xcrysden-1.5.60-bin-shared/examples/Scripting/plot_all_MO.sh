#!/bin/sh

# ------------------------------------------------------------------------
#****** ScriptingExamples/plot_all_MO.sh ***
# NAME
# plot_all_MO.sh --- plots all molecular orbitals (MO) in alike manner
#
# USAGE
# ./plot_all_MO.sh
#
# WARNING
# do not execute this script as: xcrysden -s plot_all_MO.sh 
#                                (this will not work)
#
# PURPOSE
# This shell scripts shows how one can plot several (or all) molecular
# orbitals of a given molecule in an automatic fashion, where the
# display parameters for all MOs are the same. 
#
# To construct the script as this one the following steps have to be
# done:
# 1.) the 1st MO has to be displayed in xcrysden in usual way, and
#     when the display is properly set, then save it as: 
#     File->Save State and Structure.
#
# 2.) encapsulate such saved file in s simple shell-script as this one
#
#
# 3.) replace the STRUCTURE-PART of the saved file, and request
#    therein to load a given file instead (see below)
#
#
# 4.) replace all $ characters with \$ in the saved script except for
#     the $ character for the $file variable
#
# 5.) at the end of the saved file add: scripting::printToFile; exit
#
# 6.) exucute the shell-script
#
#
# AUTHOR
# Anton Kokalj
#
# CREATION DATE
# Fri May 13 11:07:01 CEST 2005
#
# SOURCE


# this is the Bourne-chell script

basedir=$XCRYSDEN_TOPDIR/examples/XSF_Files
for file in $basedir/CO_homo.xsf.gz $basedir/CO_lumo.xsf.gz 
do
  
  # here we encapsulate the saved script file (do not forget to replace
  # $ with \$, except for the $file !!!
  
  cat > xcrysden.script <<EOF

# ------------------------------------------------------------------------
# This is the script saved via the XCRYSDEN "File-->Save Current State
# and Structure" menu. This feature saves the currently displayed
# structure. When it will be loaded again it will recall all the
# display parameters, such as orientation, zoom, perspective, ...
#
# Execute this script as: xcrysden --script this_file_name
#
# File created by tone on localhost.localdomain
# File creation date: Fri May 13 11:03:51 CEST 2005    
# ------------------------------------------------------------------------


# ======================================================================== #
#                                                                          #
#                      STRUCTURE-PART OF THE FILE                          #
#                                                                          #
# ======================================================================== #

# here we replace all the data with the following    

::scripting::open --xsf $file

# ======================================================================== #
#                                                                          #
#                        STATE-PART OF THE FILE                            #
#                                                                          #
# ======================================================================== #

    

# ------------------------------------------------------------------------
# definition of xcMisc array
# ------------------------------------------------------------------------

array set xcMisc {}

# ------------------------------------------------------------------------
# display "waiting" toplevel and watch-cursor
# ------------------------------------------------------------------------

set wait_window [DisplayUpdateWidget "Reconstructing" "Reconstructing the structure and display parameters. Please wait"]
SetWatchCursor
set xcCursor(dont_update) 1

# ------------------------------------------------------------------------
# size of the main window fonts
# ------------------------------------------------------------------------

wm geometry . 780x720

# ------------------------------------------------------------------------
# BEGIN: create fonts
# ------------------------------------------------------------------------

saveState:fontCreate font1 -family {nimbus sans l} -size 12 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font10 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font2 -family helvetica -size 10 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font11 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font3 -family helvetica -size 14 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font12 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font13 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font4 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font14 -family {nimbus mono l} -size 12 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font5 -family {nimbus sans l} -size 12 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font15 -family {nimbus mono l} -size 20 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font6 -family helvetica -size 10 -weight normal -slant roman -underline 0 -overstrike 0
saveState:fontCreate font16 -family {nimbus sans l} -size 7 -weight bold -slant roman -underline 1 -overstrike 0
saveState:fontCreate font7 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font17 -family {nimbus sans l} -size 7 -weight bold -slant roman -underline 1 -overstrike 0
saveState:fontCreate font8 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0
saveState:fontCreate font18 -family {nimbus sans l} -size 20 -weight bold -slant roman -underline 1 -overstrike 0
saveState:fontCreate font9 -family {nimbus sans l} -size 12 -weight bold -slant roman -underline 0 -overstrike 0

# ------------------------------------------------------------------------
# END: create fonts
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# BEGIN: take care of display-mode
# ------------------------------------------------------------------------

set translationStep 0.05
set rotstep 10
set light On
Lighting On
array set mode2D   {PL Off SF Off WF Off BS1 Off PB Off BS2 Off}
array set mode3D   {space Off sticks On pipe On balls On}
array set dispmode {mode3D_name PB mode3D Preset mode3D_f2_packinfo {-in .ctrl.c.f.fr3 -anchor center -expand 1 -fill both -ipadx 0 -ipady 0 -padx 0 -pady 0 -side top} style 3D mode3D_ModeFrame .ctrl.c.f.fr3.2.a0}
saveState:displayMode
set style3D(draw)  solid; Style3D draw solid
set style3D(shade) smooth; Style3D shade smooth
set viewer(rot_zoom_button_mode) Click-and-hold; Viewer:rotZoomButtonMode

# ------------------------------------------------------------------------
# END: take care of display-mode
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# Number of Units Drawn
# ------------------------------------------------------------------------

set nxdir 1
set nydir 1
set nzdir 1

# ------------------------------------------------------------------------
# BEGIN: Atomic-Labels/Fonts
# ------------------------------------------------------------------------

array set atomLabel {atomFont {} globalFont {} atomFont.brightColor {1.0 1.0 1.0} globalFont.brightColor {1.0 1.0 1.0} atomFont.do_display 1 atomFont.label {} globalFont.do_display 1 atomFont.darkColor {0.0 0.0 0.0} atomFont.id {} globalFont.darkColor {0.0 0.0 0.0} fontBrowser {Simple Font Browser}}
set t [ModAtomLabels]
.mesa xc_setfont  {}  {1.0 1.0 1.0}  {0.0 0.0 0.0}
ModAtomLabels:advancedCheckButton default
ModAtomLabels:advancedCheckButton custom
ModAtomLabels:advancedCloseUpdate dummy update
CancelProc \$t

# ------------------------------------------------------------------------
# END: Atomic-Labels/Fonts
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# BEGIN: Various colors
# ------------------------------------------------------------------------

xc_newvalue .mesa 8 0 0.770000 1.000000 0.420000
xc_newvalue .mesa 8 1 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 2 0.950000 0.950000 0.950000
xc_newvalue .mesa 8 3 0.950000 0.950000 0.950000
xc_newvalue .mesa 8 4 0.707900 0.707900 0.707900
xc_newvalue .mesa 8 5 0.707900 0.707900 0.707900
xc_newvalue .mesa 8 6 0.950000 0.950000 0.000000
xc_newvalue .mesa 8 7 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 8 0.700000 0.000000 0.000000
xc_newvalue .mesa 8 9 0.834500 0.950000 0.950000
xc_newvalue .mesa 8 10 0.950000 0.950000 0.950000
xc_newvalue .mesa 8 11 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 12 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 13 0.950000 0.000000 0.950000
xc_newvalue .mesa 8 14 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 15 0.950000 0.950000 0.000000
xc_newvalue .mesa 8 16 0.950000 0.950000 0.450000
xc_newvalue .mesa 8 17 0.300000 0.300000 0.950000
xc_newvalue .mesa 8 18 0.950000 0.950000 0.950000
xc_newvalue .mesa 8 19 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 20 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 21 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 22 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 23 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 24 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 25 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 26 0.950000 0.000000 0.000000
xc_newvalue .mesa 8 27 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 28 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 29 0.644500 0.804700 0.856900
xc_newvalue .mesa 8 30 0.950000 0.000000 0.950000
xc_newvalue .mesa 8 31 0.950000 0.000000 0.950000
xc_newvalue .mesa 8 32 0.950000 0.000000 0.950000
xc_newvalue .mesa 8 33 0.950000 0.950000 0.000000
xc_newvalue .mesa 8 34 0.950000 0.950000 0.000000
xc_newvalue .mesa 8 35 0.950000 0.000000 0.000000
xc_newvalue .mesa 8 36 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 37 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 38 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 39 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 40 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 41 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 42 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 43 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 44 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 45 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 46 1.000000 1.000000 1.000000
xc_newvalue .mesa 8 47 1.000000 1.000000 1.000000
xc_newvalue .mesa 8 48 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 49 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 50 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 51 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 52 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 53 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 54 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 55 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 56 0.000000 0.950000 0.950000
xc_newvalue .mesa 8 57 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 58 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 59 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 60 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 61 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 62 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 63 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 64 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 65 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 66 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 67 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 68 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 69 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 70 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 71 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 72 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 73 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 74 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 75 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 76 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 77 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 78 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 79 1.000000 0.850000 0.000000
xc_newvalue .mesa 8 80 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 81 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 82 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 83 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 84 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 85 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 86 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 87 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 88 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 89 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 90 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 91 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 92 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 93 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 94 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 95 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 96 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 97 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 98 0.750000 0.750000 0.750000
xc_newvalue .mesa 8 99 0.931400 0.875500 0.801000
xc_newvalue .mesa 8 100 0.931400 0.875500 0.801000
xc_newvalue .mesa 26 1.000000 1.000000 1.000000 1.0
xc_newvalue .mesa 17 0.880000 1.000000 0.670000

# ------------------------------------------------------------------------
# END: Various colors
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# BEGIN: Atomic radii
# ------------------------------------------------------------------------

xc_newvalue .mesa 4 0 0.532000
xc_newvalue .mesa 4 1 0.532000
xc_newvalue .mesa 4 2 0.532000
xc_newvalue .mesa 4 3 1.722000
xc_newvalue .mesa 4 4 1.246000
xc_newvalue .mesa 4 5 1.274000
xc_newvalue .mesa 4 6 1.078000
xc_newvalue .mesa 4 7 1.050000
xc_newvalue .mesa 4 8 1.022000
xc_newvalue .mesa 4 9 0.994000
xc_newvalue .mesa 4 10 2.240000
xc_newvalue .mesa 4 11 2.240000
xc_newvalue .mesa 4 12 1.960000
xc_newvalue .mesa 4 13 1.750000
xc_newvalue .mesa 4 14 1.450000
xc_newvalue .mesa 4 15 1.400000
xc_newvalue .mesa 4 16 1.456000
xc_newvalue .mesa 4 17 1.140000
xc_newvalue .mesa 4 18 2.660000
xc_newvalue .mesa 4 19 2.982000
xc_newvalue .mesa 4 20 2.436000
xc_newvalue .mesa 4 21 2.240000
xc_newvalue .mesa 4 22 1.960000
xc_newvalue .mesa 4 23 1.890000
xc_newvalue .mesa 4 24 1.960000
xc_newvalue .mesa 4 25 1.960000
xc_newvalue .mesa 4 26 1.960000
xc_newvalue .mesa 4 27 1.890000
xc_newvalue .mesa 4 28 1.890000
xc_newvalue .mesa 4 29 1.890000
xc_newvalue .mesa 4 30 1.890000
xc_newvalue .mesa 4 31 1.820000
xc_newvalue .mesa 4 32 1.750000
xc_newvalue .mesa 4 33 1.610000
xc_newvalue .mesa 4 34 1.610000
xc_newvalue .mesa 4 35 1.596000
xc_newvalue .mesa 4 36 2.800000
xc_newvalue .mesa 4 37 3.080000
xc_newvalue .mesa 4 38 2.800000
xc_newvalue .mesa 4 39 2.590000
xc_newvalue .mesa 4 40 2.170000
xc_newvalue .mesa 4 41 2.030000
xc_newvalue .mesa 4 42 2.030000
xc_newvalue .mesa 4 43 1.890000
xc_newvalue .mesa 4 44 1.820000
xc_newvalue .mesa 4 45 1.890000
xc_newvalue .mesa 4 46 1.960000
xc_newvalue .mesa 4 47 2.240000
xc_newvalue .mesa 4 48 2.170000
xc_newvalue .mesa 4 49 2.170000
xc_newvalue .mesa 4 50 1.974000
xc_newvalue .mesa 4 51 2.030000
xc_newvalue .mesa 4 52 1.960000
xc_newvalue .mesa 4 53 1.960000
xc_newvalue .mesa 4 54 3.542000
xc_newvalue .mesa 4 55 3.640000
xc_newvalue .mesa 4 56 2.800000
xc_newvalue .mesa 4 57 2.450000
xc_newvalue .mesa 4 58 2.170000
xc_newvalue .mesa 4 59 2.170000
xc_newvalue .mesa 4 60 2.170000
xc_newvalue .mesa 4 61 2.170000
xc_newvalue .mesa 4 62 2.170000
xc_newvalue .mesa 4 63 2.170000
xc_newvalue .mesa 4 64 2.170000
xc_newvalue .mesa 4 65 2.170000
xc_newvalue .mesa 4 66 2.170000
xc_newvalue .mesa 4 67 2.170000
xc_newvalue .mesa 4 68 2.170000
xc_newvalue .mesa 4 69 2.170000
xc_newvalue .mesa 4 70 2.170000
xc_newvalue .mesa 4 71 2.170000
xc_newvalue .mesa 4 72 2.170000
xc_newvalue .mesa 4 73 2.030000
xc_newvalue .mesa 4 74 1.890000
xc_newvalue .mesa 4 75 1.890000
xc_newvalue .mesa 4 76 1.820000
xc_newvalue .mesa 4 77 1.890000
xc_newvalue .mesa 4 78 1.890000
xc_newvalue .mesa 4 79 1.890000
xc_newvalue .mesa 4 80 2.100000
xc_newvalue .mesa 4 81 2.660000
xc_newvalue .mesa 4 82 2.520000
xc_newvalue .mesa 4 83 2.240000
xc_newvalue .mesa 4 84 2.170000
xc_newvalue .mesa 4 85 2.170000
xc_newvalue .mesa 4 86 2.170000
xc_newvalue .mesa 4 87 3.920000
xc_newvalue .mesa 4 88 2.016000
xc_newvalue .mesa 4 89 2.730000
xc_newvalue .mesa 4 90 2.170000
xc_newvalue .mesa 4 91 2.170000
xc_newvalue .mesa 4 92 2.170000
xc_newvalue .mesa 4 93 2.170000
xc_newvalue .mesa 4 94 2.170000
xc_newvalue .mesa 4 95 2.170000
xc_newvalue .mesa 4 96 2.170000
xc_newvalue .mesa 4 97 2.170000
xc_newvalue .mesa 4 98 2.170000
xc_newvalue .mesa 4 99 2.170000
xc_newvalue .mesa 4 100 2.170000
xc_newvalue .mesa 10004 0 0.000000
xc_newvalue .mesa 10004 1 0.399000
xc_newvalue .mesa 10004 2 0.399000
xc_newvalue .mesa 10004 3 1.291500
xc_newvalue .mesa 10004 4 0.934500
xc_newvalue .mesa 10004 5 0.955500
xc_newvalue .mesa 10004 6 0.808500
xc_newvalue .mesa 10004 7 0.787500
xc_newvalue .mesa 10004 8 0.766500
xc_newvalue .mesa 10004 9 0.745500
xc_newvalue .mesa 10004 10 1.680000
xc_newvalue .mesa 10004 11 1.680000
xc_newvalue .mesa 10004 12 1.470000
xc_newvalue .mesa 10004 13 1.312500
xc_newvalue .mesa 10004 14 1.450000
xc_newvalue .mesa 10004 15 1.050000
xc_newvalue .mesa 10004 16 1.092000
xc_newvalue .mesa 10004 17 1.140000
xc_newvalue .mesa 10004 18 1.995000
xc_newvalue .mesa 10004 19 2.236500
xc_newvalue .mesa 10004 20 1.827000
xc_newvalue .mesa 10004 21 1.680000
xc_newvalue .mesa 10004 22 1.470000
xc_newvalue .mesa 10004 23 1.417500
xc_newvalue .mesa 10004 24 1.470000
xc_newvalue .mesa 10004 25 1.470000
xc_newvalue .mesa 10004 26 1.470000
xc_newvalue .mesa 10004 27 1.417500
xc_newvalue .mesa 10004 28 1.417500
xc_newvalue .mesa 10004 29 1.417500
xc_newvalue .mesa 10004 30 1.417500
xc_newvalue .mesa 10004 31 1.365000
xc_newvalue .mesa 10004 32 1.312500
xc_newvalue .mesa 10004 33 1.207500
xc_newvalue .mesa 10004 34 1.207500
xc_newvalue .mesa 10004 35 1.197000
xc_newvalue .mesa 10004 36 2.100000
xc_newvalue .mesa 10004 37 2.310000
xc_newvalue .mesa 10004 38 2.100000
xc_newvalue .mesa 10004 39 1.942500
xc_newvalue .mesa 10004 40 1.627500
xc_newvalue .mesa 10004 41 1.522500
xc_newvalue .mesa 10004 42 1.522500
xc_newvalue .mesa 10004 43 1.417500
xc_newvalue .mesa 10004 44 1.365000
xc_newvalue .mesa 10004 45 1.417500
xc_newvalue .mesa 10004 46 1.470000
xc_newvalue .mesa 10004 47 1.680000
xc_newvalue .mesa 10004 48 1.627500
xc_newvalue .mesa 10004 49 1.627500
xc_newvalue .mesa 10004 50 1.480500
xc_newvalue .mesa 10004 51 1.522500
xc_newvalue .mesa 10004 52 1.470000
xc_newvalue .mesa 10004 53 1.470000
xc_newvalue .mesa 10004 54 2.656500
xc_newvalue .mesa 10004 55 2.730000
xc_newvalue .mesa 10004 56 2.100000
xc_newvalue .mesa 10004 57 1.837500
xc_newvalue .mesa 10004 58 1.627500
xc_newvalue .mesa 10004 59 1.627500
xc_newvalue .mesa 10004 60 1.627500
xc_newvalue .mesa 10004 61 1.627500
xc_newvalue .mesa 10004 62 1.627500
xc_newvalue .mesa 10004 63 1.627500
xc_newvalue .mesa 10004 64 1.627500
xc_newvalue .mesa 10004 65 1.627500
xc_newvalue .mesa 10004 66 1.627500
xc_newvalue .mesa 10004 67 1.627500
xc_newvalue .mesa 10004 68 1.627500
xc_newvalue .mesa 10004 69 1.627500
xc_newvalue .mesa 10004 70 1.627500
xc_newvalue .mesa 10004 71 1.627500
xc_newvalue .mesa 10004 72 1.627500
xc_newvalue .mesa 10004 73 1.522500
xc_newvalue .mesa 10004 74 1.417500
xc_newvalue .mesa 10004 75 1.417500
xc_newvalue .mesa 10004 76 1.365000
xc_newvalue .mesa 10004 77 1.417500
xc_newvalue .mesa 10004 78 1.417500
xc_newvalue .mesa 10004 79 1.417500
xc_newvalue .mesa 10004 80 1.575000
xc_newvalue .mesa 10004 81 1.995000
xc_newvalue .mesa 10004 82 1.890000
xc_newvalue .mesa 10004 83 1.680000
xc_newvalue .mesa 10004 84 1.627500
xc_newvalue .mesa 10004 85 1.627500
xc_newvalue .mesa 10004 86 1.627500
xc_newvalue .mesa 10004 87 2.940000
xc_newvalue .mesa 10004 88 1.512000
xc_newvalue .mesa 10004 89 2.047500
xc_newvalue .mesa 10004 90 1.627500
xc_newvalue .mesa 10004 91 1.627500
xc_newvalue .mesa 10004 92 1.627500
xc_newvalue .mesa 10004 93 1.627500
xc_newvalue .mesa 10004 94 1.627500
xc_newvalue .mesa 10004 95 1.627500
xc_newvalue .mesa 10004 96 1.627500
xc_newvalue .mesa 10004 97 1.627500
xc_newvalue .mesa 10004 98 1.627500
xc_newvalue .mesa 10004 99 1.627500
xc_newvalue .mesa 10004 100 1.627500

# ------------------------------------------------------------------------
# END: Atomic radii
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# Various parameters
# ------------------------------------------------------------------------

xc_newvalue .mesa 13 1.050000
xc_newvalue .mesa 5 1.400000
xc_newvalue .mesa 6 0.400000
xc_newvalue .mesa 7 0.600000
xc_newvalue .mesa 9 1.000000
xc_newvalue .mesa 10 1.000000
xc_newvalue .mesa 18 1.000000
xc_newvalue .mesa 10010 1.000000
xc_newvalue .mesa 10009 1.000000
xc_newvalue .mesa 11 6.000000
xc_newvalue .mesa 19 0.100000
xc_newvalue .mesa 24 15.000000
xc_newvalue .mesa 28 3.000000
xc_newvalue .mesa 29 2.500000
xc_newvalue .mesa 10029 1.000000
xc_newvalue .mesa 23 0.000000 0.000000 0.000000 1.000000

# ------------------------------------------------------------------------
# Various displays (i.e. checkbuttons of DISPLAY menu)
# ------------------------------------------------------------------------

array set check {pseudoDens 0 perspective 0 labels 1 depthcuing 0 crds 0 wigner 0 antialias 0 Hbonds 0 forces 0 frames 0 unibond 0 perpective 0}
CrdSist
AtomLabels
CrysFrames
Unibond
forceVectors .mesa
WignerSeitz
Perspective

# ------------------------------------------------------------------------
# Various displays (i.e. radiobuttons DISPLAY menu)
# ------------------------------------------------------------------------

array set radio {space {SpaceFill based on covalent radii} .mesa,bg #000000 cellmode conv frames rods unitrep cell hexamode parapipedal ball {Balls based on covalent radii}}
xc_newvalue .mesa 2
xc_newvalue .mesa 0

# ------------------------------------------------------------------------
# load appropriate color-scheme
# ------------------------------------------------------------------------

array set colSh {slab_dir -z slabrange_min 0.00 slabrange_max 1.00 scheme atomic slab_colbas monochrome dist_r 1.0 dist_coltyp combined dist_alpha 0.65 dist_x 0.0 slab_fractional 1 slab_coltyp combined dist_y 0.0 dist_z 0.0 slab_alpha 0.65 dist_colbas monochrome}
ColorSchemeUpdate .mesa

# ------------------------------------------------------------------------
# BEGIN: scalar field (controur or isosurface) settings
# ------------------------------------------------------------------------

array set DG {envar0,0 1.0 ident,0 3D_ORBITAL_#007 cb0,0 1 r0 .dg.1.c.f0.r0 YSpace 15 yspace 5 c0,0 .dg.1.c.sf0_0.r l0,0 .dg.1.c.sf0_0.l2 n_block 1 e0,0 .dg.1.c.sf0_0.e bw 407 blockFont font16 bh 49 type,0 3D n_subblock,0 1 subident,0,0 DATAGRID_3D_G98CUBE ystart 206 radio 0}
DataGridOK
array set isoControl {1,current_slide 1 isoline_color monocolor datagridDim 3 3,cpl_thermoFont {} 1,cpl_thermoNTics 6 2,cpl_thermoNTics 6 3,cpl_thermoNTics 6 3,2Dnisoline 15 cpl_thermoNTics 6 3,anim_step 1 3,cpl_basis MONOCHROME 1,isoline_monocolor #ffffff 1,isoline_width 2 2,cpl_thermoFont {} 3,cpl_thermoFmt %+8.4f 2,2Dlowvalue -0.1 2,current_text_slide {Current slide:  7 / 25} 1,cpl_transparency 0 3,colorplane 0 blend_button .iso.fb1.f.right.f5.b3 3,isoline_color monocolor cbfn_apply_to_all 0 1,cpl_thermoFont {} 2,cpl_function LINEAR current_slide 1 revert_button1 .iso.fb1.f.right.f5.b12 1,2Dnisoline 15 revert_button2 .iso.fb1.f.right.f5.b10a 2Dlowvalue_entry .iso.fb2.f1.1.mf.r.f3.1.entry1 2,cpl_transparency 0 2Dnisoline_entry .iso.fb2.f1.1.mf.r.f5.1.entry1 2,isoline_monocolor #000000 1,2Dhighvalue 0.417066 cpl_basis BLUE-WHITE-RED anim_step 1 1,isoline 0 2,isoline 1 3,2Dhighvalue 0.417066 3,isoline 0 2,cpl_thermoFmt %+8.4f 2,colorplane_lighting 0 isoline_width 3 1,cpl_thermoLabel { Scale:   ? n(r)} 2,cpl_thermoLabel { Scale:   ? n(r)} isoline 1 3,cpl_thermoLabel { Scale:   ? n(r)} colorplane_lighting 0 cpl_thermoTplw 0 1,colorplane 0 cpl_thermoLabel { Scale:   ? n(r)} 3,cpl_transparency 0 2,isoline_color monocolor 2Dnisoline 11 3,current_slide 1 3,cpl_thermoTplw 0 max_allowed_2Dnisoline 100 3,2Dlowvalue -0.736872 cpl_function LINEAR anim_apply_to_all 0 1,anim_step 1 1,cpl_basis MONOCHROME 3,current_text_slide {Current slide:  1 / 33} 3,nslide 33 colorplane 1 cpl_transparency 0 3,isoline_monocolor #ffffff 3,isoline_width 2 1,cpl_function LINEAR 1,cpl_thermoFmt %+8.4f 2Disolinewidth_entry .iso.fb2.f1.1.mf.i.3.f1.1.entry1 2,cpl_thermoTplw 0 smooth_button .iso.fb1.f.right.f5.b2a 2,2Dnisoline 11 2,nslide 25 1,isoline_color monocolor disp_apply_to_all 0 plane 2 1,isoline_stipple {no stipple} 3Dinterpl_degree 1 2,isoline_stipple {no stipple} 2,current_slide 13 1,cpl_thermoTplw 0 3,isoline_stipple {no stipple} 1,2Dlowvalue -0.736872 isoline_stipple {no stipple} 2Dhighvalue_entry .iso.fb2.f1.1.mf.r.f4.1.entry1 1,current_text_slide {Current slide:  1 / 25} 1,nslide 25 2,colorplane 1 2,anim_step 1 2,cpl_basis BLUE-WHITE-RED 1,cpl_thermometer 0 2,isoline_width 3 2,cpl_thermometer 0 3,cpl_thermometer 0 2,2Dhighvalue 0.1 1,colorplane_lighting 0 bmc .iso.fb2.f1.1.mf.i.1.b color_button .iso.fb1.f.right.f5.b2 cpl_thermometer 0 isoline_monocolor #000000 isosurf 1 3,colorplane_lighting 0 3,cpl_function LINEAR 2Dhighvalue 0.1 cpl_thermoFmt %+8.4f cpl_thermoFont {} 2Dlowvalue -0.1 current_text_slide {Current slide:  13 / 25}}
array set prop {datagridDim 0 type_of_run RHF pm_isolevel 1 isolevel 0.1}
array set isosurf {type_of_isosurf wire 3Dinterpl_degree 1 isovalue_entry .iso.fb1.f.left.f1.f3.1.entry1 1,2Dexpand_X 1 transparency off rangevalue 1.1539379999999999 1,2Dexpand_Y 1 1,2Dexpand none res_type angstroms 3,2Dexpand_X 1 1,2Dexpand_Z 1 twoside_lighting off 3,2Dexpand_Y 1 3,2Dexpand none 3,2Dexpand_Z 1 3Dinterpl_degree_old 1 space_sel whole_cell expand_X 1 expand_Y 1 expand none expand_Z 1 minvalue -0.736872 mb_angs/bohr Angstroms old_twoside_lighting off spin {} 2,2Dexpand_X 1 maxvalue 0.417066 2,2Dexpand_Y 1 2,2Dexpand none Y_Sel centered 2,2Dexpand_Z 1 2Dexpand_X 1 shade_model smooth Z_Sel centered 2Dexpand_Y 1 2Dexpand none 2Dexpand_Z 1}
UpdateIsosurf
array set DataGrid {launch_command IsoControl dim 3D first_time exists}

# ------------------------------------------------------------------------
# END: scalar field (controur or isosurface) settings
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
# rotation matrix and zooming factor, and translation displacements
# ------------------------------------------------------------------------

xc_rotationmatrix set  1.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00 -1.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  1.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  0.000000000000000e+00  1.000000000000000e+00 
xc_translparam    set  1.300000000000000e+01 -6.000000000000000e+00  1.609286470111767e+00 

# this is used to force the update of display
.mesa cry_toglzoom 0.0

# ------------------------------------------------------------------------
# Anti-Aliasing & Depth-Cuing & PseudoDensity (these are time consuming)
# ------------------------------------------------------------------------

DepthCuing; PseudoDensity; AntiAlias

# ------------------------------------------------------------------------
# reset cursor
# ------------------------------------------------------------------------

set xcCursor(dont_update) 0
ResetCursor
destroy \$wait_window

# now print the MO
update
after idle { scripting::printToFile }
exit
EOF
# end of embedded xcrysden.script

# now we load the just created xcrysden.script into xcrysden
xcrysden -s xcrysden.script
done

#****
# ------------------------------------------------------------------------
