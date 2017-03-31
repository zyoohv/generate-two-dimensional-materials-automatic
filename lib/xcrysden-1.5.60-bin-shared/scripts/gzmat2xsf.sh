#!/bin/sh
#############################################################################
# Author:                                                                   #
# ------                                                                    #
#  Anton Kokalj                                  Email: Tone.Kokalj@ijs.si  #
#  Department of Physical and Organic Chemistry  Phone: x 386 1 477 3523    #
#  Jozef Stefan Institute                          Fax: x 386 1 477 3811    #
#  Jamova 39, SI-1000 Ljubljana                                             #
#  SLOVENIA                                                                 #
#                                                                           #
# Source: $XCRYSDEN_TOPDIR/scripts/gzmat2xsf.sh
# ------                                                                    #
# Copyright (c) 1996-2003 by Anton Kokalj                                   #
#############################################################################

# set locales to C
LANG=C 
LC_ALL=C
export LANG LC_ALL

BABEL=${BABEL:-babel}

# ------------------------------------------------------------------------
# this is an experimental Gaussian Z-Matrix To XSF converter. Use at
# your own risk.
#
# REQUIRES babel !!!
#
#
# Usage:   g98toxsf.sh G98-output > XSF-file
#        or
#          g98toxsf.sh < G98-output > XSF-file
#
# ------------------------------------------------------------------------


if [ $# -eq 0 ]; then
    input=-
elif [ $# -eq 1 ]; then
    input=$1
else
    echo "
Usage:    g98toxsf.sh G98-output > XSF-file
      or
          g98toxsf.sh < G98-output > XSF-file
"
    exit 1
fi

cat $input | awk '
/^#/ { comdeck=1; }
/\*\*\*\*/ {
 if (after_comment) {
   exit 0;
 }
}
/a*/ { 
 print;
 if ( comdeck==1 && $1 !~ /^#/ ) {
   after_comment=1;
   getline; print;
   getline; print; # this is comment line
   comdeck=0;
 }
}' > gzmat.$$

$BABEL -igzmat  gzmat.$$ -oxyz | awk 'BEGIN {getline; getline; print "ATOMS";}
{ if (toupper($1) != "X") print; }'
rm -f gzmat.$$
exit 0
