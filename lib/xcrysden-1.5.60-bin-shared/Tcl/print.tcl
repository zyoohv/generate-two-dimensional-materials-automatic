#############################################################################
# Author:                                                                   #
# ------                                                                    #
#  Anton Kokalj                                  Email: Tone.Kokalj@ijs.si  #
#  Department of Physical and Organic Chemistry  Phone: x 386 1 477 3523    #
#  Jozef Stefan Institute                          Fax: x 386 1 477 3811    #
#  Jamova 39, SI-1000 Ljubljana                                             #
#  SLOVENIA                                                                 #
#                                                                           #
# Source: $XCRYSDEN_TOPDIR/Tcl/print.tcl
# ------                                                                    #
# Copyright (c) 1996-2003 by Anton Kokalj                                   #
#############################################################################

proc printTogl {{togl .mesa}} {
    global xcMisc system printSetup
    
    set sfile [printTogl_queryFilename]
    if { $sfile == "" } {
	return 0
    }
    
    
    set ext [file extension [file tail $sfile]]
    
    SetWatchCursor
    if { [string toupper $ext] == ".EPS" || \
	     [string toupper $ext] == ".PS" || \
	     [string toupper $ext] == ".PDF" } {  
	printToglEPS $togl $sfile
    } else {	

	printTogl_Antialias begin

	if { [string toupper $ext] == ".PPM" } {
	    $togl cry_dump2ppm $sfile 1 1 1
	} elseif { [string toupper $ext] == ".PGM" } {
	    $togl cry_dump2ppm $sfile 2
	} else {
	    $togl cry_dump2ppm $system(SCRDIR)/tmp.ppm 1

	    if { ! [info exists printSetup(useOptions) ] } {
		# see the printSetup proc
		set printSetup(useOptions) 0
	    }
	    if { ! [info exists xcMisc(ImageMagick.convertOptions)] } {
		set xcMisc(ImageMagick.convertOptions) ""
	    }
	    if { $printSetup(useOptions) } {
		eval xcCatchExecReturn $xcMisc(ImageMagick.convert) $xcMisc(ImageMagick.convertOptions) $system(SCRDIR)/tmp.ppm $sfile
	    } else {
		eval xcCatchExecReturn $xcMisc(ImageMagick.convert) $system(SCRDIR)/tmp.ppm $sfile 
	    }
	}
	
	printTogl_Antialias end
    }
    
    ResetCursor    
}

proc printTogl_queryFilename {} {
    global xcMisc system
    
    set head    [file rootname [file tail $xcMisc(titlefile)]]
    set defext  .eps
    
    #
    # check if we have converting program
    #
    if { [info exists xcMisc(ImageMagick.convert)] } {
	set deffile $head.png
	set defext  .png
	set filetypes {
	    {{PNG}        {.png} }
	    {{JPEG}       {.jpg} }
	    {{EPS}        {.eps} }
	    {{PDF}        {.pdf} }
	    {{GIF}        {.gif} }
	    {{TIFF}       {.tiff}}
	    {{PPM}        {.ppm} }
	    {{PGM}        {.pgm} }
	    {{All Files}  *      }
	}
    } else {	
	set filetypes {
	    {{EPS}        {.eps} }
	    {{PDF}        {.pdf} }
	    {{PPM}        {.ppm} }
	    {{PGM}        {.pgm} }
	    {{All Files}  *      }
	}
	set deffile $head.eps
    }
    
    set sfile [tk_getSaveFile -initialdir $system(PWD) \
		   -title "Print to File" \
		   -defaultextension $defext \
		   -initialfile      $deffile \
		   -filetypes        $filetypes]
    return $sfile
}

proc printTogl_Antialias {mode} {
    global check printSetup
    
    if { $mode == "begin" } {
	if { [info exists printSetup(useAntialias)] } {
	    if { $printSetup(useAntialias) && !$check(antialias) } {
		set printSetup(useAntialias_switch) 1
		puts stderr "printTogl:   Turning ON anti-aliasing ..."
		set check(antialias) 1
		AntiAlias
	    }
	}
    } elseif { $mode == "end" } {
	if { [info exists printSetup(useAntialias_switch)] } {
	    if { $printSetup(useAntialias_switch) } {
		set printSetup(useAntialias_switch) 0
		puts stderr "printTogl:   Turning OFF anti-aliasing ..."
		set check(antialias) 0
		AntiAlias
	    }
	}
    } else {
	ErrorIn printTogl_Antialias \
	    "wrong mode \"$mode\", must be begin or end"
    }
}

proc printWidget {widget} {
    # NOTICE: obsolte command, use dumpWindow proc instead
    global xcMisc system

    set head [file rootname [file tail $xcMisc(titlefile)]]

    set defext  .eps
    #
    # check if we have convert program
    #
    if { [info exists xcMisc(ImageMagick.convert)] } {
	tk_messageBox -message "WARNING:\n\nYou are about to dump the content of a widget.Please make sure that no window obscures the widget to be printed. This is because XCRYSDEN's print is an XWD window dump." -type ok -icon warning


	set deffile $head.jpg
	set defext  .jpg
	set filetypes {
	    {{JPEG}       {.jpg} }
	    {{EPS}        {.eps} }
	    {{PNG}        {.png} }
	    {{GIF}        {.gif} }
	    {{TIFF}       {.tiff}}
	    {{All Files}  *      }
	}
    } else {	
	tk_messageBox -message "WARNING:\n\nIn order to dump an xcMisc(ImageMagick.convert) variables must be defined. Please define it in the \$HOME/.xcrysden/custom-definitions file. The variable should hold the path of the XWD-to-xxx (xxx=PNG,GIF,JPG,...) format. Example:\n\n
set xcMisc(ImageMagick.convert) /usr/bin/convert" -type ok -icon warning

	return
    }

    set sfile [tk_getSaveFile -initialdir $system(PWD) \
		   -title "Print to File" \
		   -defaultextension $defext \
		   -initialfile $deffile \
		   -filetypes $filetypes]
    if { $sfile == {} } {
	return 0
    }
    
    set ext [file extension [file tail $sfile]]

    SetWatchCursor

    #
    # first dump with xwd and then convert to wanted format
    #
    set head [file rootname [file tail $xcMisc(titlefile)]]
    raise $widget
    update
    after 1000
    set id [winfo id $widget]
    puts stderr "PRINTING WINDOW: $id [winfo id .mesa]"
    after idle [list xcCatchExecReturn xwd -id $id -out $system(SCRDIR)/$head.xwd]
    update idletasks
    # convert -gaussian 2x2 -geometry 200%
    # THIS SHOULD be catched !!!
    eval xcCatchExecReturn $xcMisc(ImageMagick.convert) $system(SCRDIR)/$head.xwd $sfile
    ResetCursor    
}


proc printToglEPS {togl file} {
    global light toglEPS

    set t [xcToplevel [WidgetName] "EPS Printing Options" "Print" . 100 100 1]


    set EXT [string toupper [file extension [file tail $file]]]
    if { $EXT == ".PDF" } {
	set toglEPS(format)    PDF
    }
    
    if { ! [info exists toglEPS(format)] } {
	set toglEPS(format)    EPS
    }
    if { ! [info exists toglEPS(pointsize)] } {
	set toglEPS(pointsize) 2.0
    }
    if { ! [info exists toglEPS(linewidth)] } {
	set toglEPS(linewidth) 2.0
    }

    if { $light == "On" } {
	#
	# ligting-ON mode
	#
	set toglEPS(sort)    BSP_SORT
	set toglEPS(EPStype) BITMAP
    } else {
	#
	# ligting-OFF mode
	#
	set toglEPS(sort)    NO_SORT
	set toglEPS(EPStype) VECTORIAL
    }
    
    
    set f1 [frame $t.1]
    set f2 [frame $t.2]
    set f0 [frame $t.0]
    set f3 [frame $t.3]
    pack $f1 $f2 -side top -expand 1 -fill x
    pack $f0 -fill both
    pack $f3 -side bottom -expand 0 -fill x

    set toglEPS(frame2) $f2

    set m  [xcMenuButton $f1 \
		-labeltext    "Type of PostScript:" \
		-labelwidth   19 \
		-textvariable toglEPS(EPStype) \
		-menu {
		    BITMAP    {set toglEPS(EPStype) BITMAP}
		    VECTORIAL {set toglEPS(EPStype) VECTORIAL}
		}]
    pack $m -side top -padx 5 -expand 1 -fill x

    trace variable toglEPS(EPStype) w xcTrace


    set f21 [frame $f2.1]
    set f22 [frame $f2.2]
    set f23 [frame $f2.3]
    set f24 [frame $f2.4]
    pack $f21 $f22 $f23 $f24 -side top -padx 5 -expand 1 -fill x

    # format sort options pointsize linewidth

    set m1 [xcMenuButton $f21 \
		-labeltext "Output format:" \
		-labelwidth 19 \
		-textvariable toglEPS(format) \
		-menu {
		    PS  {set toglEPS(format) PS}
		    EPS {set toglEPS(format) EPS}
		    PDF {set toglEPS(format) PDF}
		    TEX {set toglEPS(format) TEX}
		}]
    set m2 [xcMenuButton $f22 \
		-labeltext  "Sorting:" \
		-labelwidth 19 \
		-textvariable toglEPS(sort) \
		-menu {
		    NO_SORT     {set toglEPS(sort) NO_SORT}
		    SIMPLE_SORT {set toglEPS(sort) SIMPLE_SORT}
		    BSP_SORT    {set toglEPS(sort) BSP_SORT}
		}]

    pack $m1 $m2 -side top -padx 5 -pady 5 -expand 1 -fill x

    Entries $f23 {"Point size:" "Line width:"} {
	toglEPS(pointsize) toglEPS(linewidth)} 5

    label $f23.__l -text "Don't touch below settings,\nunless you know what you are doing !!!" -relief ridge -bd 2
    pack $f23.__l -side top -padx 5 -pady 5 -ipadx 5 -ipady 5 -fill x -expand 0

    label $f24.__l -text "GL2PS Options:"
    pack  $f24.__l -side left

    CheckVarButtons $f24 {
	DRAW_BACKGROUND    
	SIMPLE_LINE_OFFSET 
	SILENT             
	BEST_ROOT          
	OCCLUSION_CULL     
	NO_TEXT            
	LANDSCAPE          
	NO_PS3_SHADING     
	NO_PIXMAP
	NO_BLENDING
    } {
	toglEPS(DRAW_BACKGROUND)
	toglEPS(SIMPLE_LINE_OFFSET) 
	toglEPS(SILENT)             
	toglEPS(BEST_ROOT)          
	toglEPS(OCCLUSION_CULL)     
	toglEPS(NO_TEXT)            
	toglEPS(LANDSCAPE)          
	toglEPS(NO_PS3_SHADING)    
	toglEPS(NO_PIXMAP)          
	toglEPS(NO_BLENDING)        
    } top

    # bottom buttons
    set ok  [button $f3.print -text "Print" -default active \
		-command [list printToglEPS_Print $t $togl $file]]
    set can [button $f3.cancel -text "Cancel" \
		 -command [list CancelProc $t]]
    pack $ok $can -side right -padx 5 -pady 10 -expand 1
}


proc printToglEPS_Print {t togl file} {
    global toglEPS light
    
    set EXT [string toupper [file extension [file tail $file]]]

    if { $toglEPS(EPStype) == "BITMAP" } {
	destroy $t
	if { $EXT == ".PDF" } {
	    set head [file rootname $file]
	    set file $head.eps
	    tk_messageBox -message "WARNING:\n\nCannot print the PDF file. The EPS file will be printed instead:\n$file" -type ok -icon warning
	}
	SetWatchCursor
	set colorEPS 1
	$togl xc_dump2eps $file $colorEPS    	
	ResetCursor
    } else {
	if { $light == "On" } {
	    set ans [tk_messageBox -icon info -message "NOTICE: Printing vectorial PostScript in \"Ligting-On mode\" may take long time, and the PostScript file size can reach up to several 100 MB.\n\nWould you like to continue?" -type yesno]
	    if { $ans == "no" } {		
		return
	    }
	}
	
	destroy $t
	
	set _options GL2PS_NONE
	foreach elem {
	    DRAW_BACKGROUND
	    SIMPLE_LINE_OFFSET 
	    SILENT             
	    BEST_ROOT          
	    OCCLUSION_CULL     
	    NO_TEXT            
	    LANDSCAPE          
	    NO_PS3_SHADING     
	} {
	    if { $toglEPS($elem) == 1 } {
		lappend _options GL2PS_$elem
	    }
	}

	xcDebug -stderr "Executing: $togl cry_gl2psPrintTogl \
	    GL2PS_$toglEPS(format) \
	    GL2PS_$toglEPS(sort) \
	    $_options $toglEPS(pointsize) $toglEPS(linewidth) $file"

	SetWatchCursor
	$togl cry_gl2psPrintTogl \
	    GL2PS_$toglEPS(format) \
	    GL2PS_$toglEPS(sort) \
	    $_options $toglEPS(pointsize) $toglEPS(linewidth) $file
	ResetCursor
    }
}


proc printSetup {} {
    global xcMisc printSetup

    if { ! [info exists xcMisc(ImageMagick.convertOptions)] } {
	set xcMisc(ImageMagick.convertOptions) "-quality 90 -antialias -blur 1x1 -trim -bordercolor white -border 20x20 -bordercolor black -border 3x3"
	#set xcMisc(ImageMagick.convertOptions) "-quality 90 -trim -bordercolor white -border 20x20 -bordercolor black -border 3x3"
    }
    if { ! [info exists printSetup(useAntialias) ] } {
	set printSetup(useAntialias) 0
    }

    if { ! [info exists printSetup(useOptions) ] } {
	set printSetup(useOptions) 0
    }

    set t [xcToplevel .print_setup "Print Setup" "Print Setup" . 0 0 1]

    set f1 [frame $t.1 -relief groove -bd 2]
    set f2 [frame $t.2]
    pack $f1 -side top -expand 1 -fill both -padx 5 -pady 5 -ipadx 5 -ipady 5
    pack $f2 -side top -expand 1 -fill x -padx 5 -pady 5 -ipadx 5 -ipady 5

    set cb0 [checkbutton $f1.__cb0 -text "Use Anti-aliasing" \
		-variable printSetup(useAntialias) \
		-onvalue 1 -offvalue 0 -relief raised -bd 1]
    set cb1 [checkbutton $f1.__cb1 -text "Use command-line options" \
		-variable printSetup(useOptions) \
		-onvalue 1 -offvalue 0 -relief raised -bd 1]
    pack $cb0 $cb1 -side top -fill x -expand 1 -padx 5 -pady 5
	    
    set e1 [FillEntries $f1 {
	"Image conversion PPM to PNG/JPG/GIF program:"
	"Image conversion program command-line options:"
    } {
	xcMisc(ImageMagick.convert)
	xcMisc(ImageMagick.convertOptions)
    } 45 80 top top]

    regsub -- {1.entry1$} $e1 {2.entry2} printSetup(optionEntry)
    
    trace variable printSetup(useOptions) w printSetup:traceOptions
    printSetup:traceOptions printSetup useOptions w
    
    set ok [button $f2.ok -text "OK" -command [list CancelProc $t]]
    pack $ok -side top -expand 1 -ipadx 3 -ipady 3 -padx 5 -pady 5
}


proc printSetup:traceOptions {name1 name2 op} {
    global printSetup
    
    if { $printSetup(useOptions) == 0 } {
	$printSetup(optionEntry) config -relief flat
	$printSetup(optionEntry) config -fg \#666
	xcDisableOne $printSetup(optionEntry)
    } else {
	$printSetup(optionEntry) config -relief sunken
	$printSetup(optionEntry) config -fg \#000000
	xcEnableOne $printSetup(optionEntry)
    }
}
