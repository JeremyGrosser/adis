#
# Makefile to build ADIS Distribution Version 1.1 binaries
#

.SILENT:

#
# There are two versions of the OS, one which uses the ModSAF CTDB routines
# to retrieve terrain information from ModSAF databases, and one which models
# the terrain as per WGS84 (for those sites which do not have access to
# ModSAF).
#
# Set which version of the OS to build -- either without ModSAF (os_wo_modsaf)
# or with ModSAF (os_w_modsaf)
#

OS_VERSION = os_wo_modsaf
#OS_VERSION = os_w_modsaf

#
# If building an OS using ModSAF, then the path to CTDB library routines
# must be set here.
#
MODSAF_LIB = /usr/modsaf/common/lib/SGI/modsaf

instructions:
	echo ""
	echo "Usage:  make <option>"
	echo ""
	echo "        where <option> is one of:"
	echo ""
	echo "          build        - combines compile and link"
	echo "          compile      - compiles all ADIS source code"
	echo "          link         - links DG, OS, and GUI binaries"
	echo "          clean        - deletes all units from all libraries"
	echo "          distribution - restore directories to distribution state"
	echo "          assumptions  - lists assumptions made by this distribution"
	echo "          poc          - lists points of contact for ADIS"
	echo ""

assumptions:
	echo ""
	echo "The following assumptions are made by this distribution:"
	echo ""
	echo "1)  The directory containing the VADS binaries is in your"
	echo "    PATH."
	echo "2)  The VADS libraries are in /usr/vads/...  If this is not the"
	echo "    case, then the ada.lib files (and the ada.lib.orig) files"
	echo "    in each library will have to be edited to reflect your"
	echo "    site's configuration"
	echo "3)  This Makefile builds an OS which uses the WGS84 model to"
	echo "    determine terrain elevation.  A second version of the OS"
	echo "    is included which interfaces with ModSAF's CTDB libraries"
	echo "    and uses ModSAF's databases to provide more detailed"
	echo "    terrain information.  This version of the OS can be built"
	echo "    by editing this Makefile.  Instructions are included in the"
	echo "    comment lines."
	echo ""

poc:
	echo ""
	echo "Remember, there is no software support available for ADIS, nor"
	echo "are there any warranties expressed or implied with this software."
	echo "Okay, now that the legalese is out of the way, here is a list of"
	echo "points of contact:"
	echo ""
	echo "    ATIP Program Manager"
	echo "      Joan McGarity"
	echo "      mcgaritj@cc.ims.disa.mil"
	echo "      703-604-4620"
	echo ""
	echo "    ADIS Project Manager"
	echo "      Larry Ullom"
	echo "      lullom@dmso.dtic.dla.mil"
	echo "      301-826-7720"
	echo ""
	echo "    ADAIC System Operator"
	echo "      action@ajpo.sei.cmu.edu"
	echo ""

build: compile link

compile:
	cd common;        a.make -v -O0 -f *.ada
	cd dl;            a.make -v -O0 -f *.ada
	cd dg/common;     a.make -v -O0 -f *.ada
	cd dg/client;     a.make -v -O0 -f *.ada
	cd dg/server;     a.make -v -O0 -f *.ada
	cd os/common;     a.make -v -O0 -f *.ada
	cd os/w_modsaf;   a.make -v -O0 -f *.ada
	cd os/wo_modsaf;  a.make -v -O0 -f *.ada
	cd gui/utilities; a.make -v -O0 -f *.ada
	cd gui/xdgs;      a.make -v -O0 -f *.ada
	cd gui/xdgc;      a.make -v -O0 -f *.ada
	cd gui/xos;       a.make -v -O0 -f *.ada

link:
	cd dg/server; a.make -v -O0 -o ../DG_Server DG_Server
	make ${OS_VERSION}
	cd gui/xdgs;  a.make -v -O0 -o ../XDG_Server Main
	cd gui/xdgc;  a.make -v -O0 -o ../XDG_Client Main
	cd gui/xos;   a.make -v -O0 -o ../XOS        Main

os_w_modsaf:
	cd os/w_modsaf; a.make -v -O0 -o ../OS OS -L${MODSAF_LIB} -lctdb

os_wo_modsaf:
	cd os/wo_modsaf; a.make -v -O0 -o ../OS OS

clean:
	cd common;        a.cleanlib
	cd dl;            a.cleanlib
	cd dg/common;     a.cleanlib
	cd dg/client;     a.cleanlib
	cd dg/server;     a.cleanlib
	cd os/common;     a.cleanlib
	cd os/w_modsaf;   a.cleanlib
	cd os/wo_modsaf;  a.cleanlib
	cd gui/utilities; a.cleanlib
	cd gui/xdgs;      a.cleanlib
	cd gui/xdgc;      a.cleanlib
	cd gui/xos;       a.cleanlib

distribution:
	make clean
	cd dg;      if (-f DG_Server) rm DG_Server
	cd os;      if (-f OS) rm OS
	cd gui;     if (-f XDG_Server) rm XDG_Server
	cd gui;     if (-f XDG_Client) rm XDG_Client
	cd gui;     if (-f XOS       ) rm XOS
	cd common;        cp ada.lib.orig ada.lib
	cd dl;            cp ada.lib.orig ada.lib
	cd dg/common;     cp ada.lib.orig ada.lib
	cd dg/client;     cp ada.lib.orig ada.lib
	cd dg/server;     cp ada.lib.orig ada.lib
	cd os/common;     cp ada.lib.orig ada.lib
	cd os/w_modsaf;   cp ada.lib.orig ada.lib
	cd os/wo_modsaf;  cp ada.lib.orig ada.lib
	cd gui/utilities; cp ada.lib.orig ada.lib
	cd gui/xdgs;      cp ada.lib.orig ada.lib
	cd gui/xdgc;      cp ada.lib.orig ada.lib
	cd gui/xos;       cp ada.lib.orig ada.lib

