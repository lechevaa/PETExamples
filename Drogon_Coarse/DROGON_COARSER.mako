<%!
import numpy as np
%>

-- This reservoir simulation deck is made available under the Open Database
-- License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in
-- individual contents of the database are licensed under the Database Contents
-- License: http://opendatacommons.org/licenses/dbcl/1.0/

-- Copyright (C) 2022 Equinor

--==============================================================================
--		Synthetic reservoir simulation model Drogon (2020)
--==============================================================================

-- The Drogon model - the successor of the Reek model
-- Used in a FMU set up
-- Grid input data generated from RMS project 


-- =============================================================================
RUNSPEC
-- =============================================================================

-- Simulation run title
TITLE
 Drogon synthetic reservoir model

-- Simulation run start
START
 1 JAN 2018 /

-- Fluid phases present
OIL
GAS
WATER
DISGAS
VAPOIL

-- Measurement unit used
METRIC

DIMENS
12 19 31   /

-- Options for equilibration
EQLOPTS
 'THPRES'  /

CPR
/

-- Dimensions and options for tracers
-- 2 water tracers
TRACERS
 1*  2 /

TABDIMS
-- NTSFUN  NTPVT  NSSFUN  NPPVT  NTFIP  NRPVT   
    180      2      200     24     6      20    /

-- Dimension of equilibration tables
INCLUDE
  '../include/runspec/drogon.eqldims' / -- exported by rms

-- Regions dimension data
INCLUDE
  '../include/runspec/drogon.regdims' / -- exported by rms

-- x-,y-,z- and multnum regions
INCLUDE
  '../include/runspec/drogon.gridopts' / -- exported by rms

-- Dimensions for fault data
FAULTDIM
 500 /

-- Well dimension data
-- nwmaxz: max wells in the model
-- ncwmax: max connections per well
-- ngmaxz: max groups in the model
-- nwgmax: max wells in any one group
WELLDIMS
-- nwmaxz  ncwmax  ngmaxz  nwgmax
   20       100     10       20 /

-- Dimensions for multi-segment wells
-- nswlmx: max multi-segment wells in the model
-- nsegmx: max segments per well
-- nlbrmx: max branches per multi-segment well
WSEGDIMS
-- nswlmx  nsegmx  nlbrmx
   3       150      100 /


-- Input and output files format
UNIFIN
--UNIFOUT

-- Disables the initial index file output
NOINSPEC

-- Disables the restart index file output
NORSSPEC


-- print and stop limits
-- -----------print------------  -----------stop--------------------
-- mes  com  war  prb  err  bug  mes  com   war     prb    err  bug  
MESSAGES
   1*   1*   1*   1000 10   1*   1*    1*  1000000 7000    0   /


-- =============================================================================
GRID
-- =============================================================================
NOECHO

NEWTRAN

GRIDFILE
 0 1 /

INIT

--Generates connections across pinched-out layers
PINCH
 3*  ALL  /

INCLUDE
 '../include/coarse/DROGON_COARSER.GRDECL' /

INCLUDE
 '../include/coarse/actnum.inc' /

INCLUDE
 '../include/coarse/fault.inc' / 

INCLUDE
 '../include/coarse/poro.inc' /

--INCLUDE
-- '../include/coarse/ntg.inc' /
 
INCLUDE
'../include/coarse/PERMX.inc' /

INCLUDE
'../include/coarse/PERMY.inc' /

INCLUDE
'../include/coarse/PERMZ.inc' /
 
INCLUDE
 '../include/coarse/multnum.inc' /

INCLUDE
 '../include/grid/drogon.multregt' / --from ert template


MULTREGT
--REGIONS    MULTIPLIER         DIRECTION
-- Tran mult between Valysar and Therys
${" 1   2      {0}   'Z'   /".format(pow(10.0,mltregt[0]))}
-- Tran mult between Valysar and Volon 
${" 1   3      {0}   'Z'   /".format(pow(10.0,mltregt[1]))}
-- Tran mult between Therys and Volon 
${" 2   3      {0}    'Z'   /".format(pow(10.0,mltregt[2]))} 
/

MULTFLT
${" F1 {0} /".format(pow(10.0,fltmlt[0]))}
${" F2 {0} /".format(pow(10.0,fltmlt[1]))}
${" F3 {0} /".format(pow(10.0,fltmlt[2]))}
${" F4 {0} /".format(pow(10.0,fltmlt[3]))}
${" F5 {0} /".format(pow(10.0,fltmlt[4]))}
${" F6 {0} /".format(pow(10.0,fltmlt[5]))}
/
-- =============================================================================
EDIT
-- =============================================================================

INCLUDE
 '../include/coarse/trans.inc' /

INCLUDE
 '../include/coarse/porv.inc' /
-- =============================================================================
PROPS
-- =============================================================================

FILLEPS

--INCLUDE
-- '/include/props/drogon.sattab' / --exported by rms


SWOFLET
-- Swco    Swcr    Lw      Ew      Tw      Krtw ||  Sorw    Sowcr   Lo      Eo      To      Krto  ||  L       E       T       Pcir    Pct
-- Table 1
--  0.021   0.021   1.927   5.667   2.214   0.995    0.000   0.000   4.970   2.286   1.115   1.002    6.714 391.550   1.246   9.956   0.002  /
% for i in range(15):
${"  0.021  0.021 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 6.714 391.550   1.246   9.956   0.002 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 2
--  0.118   0.118   1.846   6.347   2.408   0.995    0.000   0.000   5.136   2.282   1.107   1.002    4.468  43.215   1.123   9.943   0.010  /
% for i in range(15,30):
${"  0.118  0.118 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 4.468  43.215   1.123   9.943   0.010 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 3
--  0.021   0.021   1.926   5.673   2.215   0.995    0.000   0.000   4.971   2.286   1.114   1.002    6.615 371.221   1.242   9.956   0.002  /
% for i in range(30,45):
${"  0.021  0.021 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 6.615 371.221   1.242   9.956   0.002 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 4
--  0.223   0.223   1.743   7.396   2.686   0.995    0.000   0.000   5.361   2.298   1.100   1.002    3.755  35.880   1.123   9.942   0.017  /
% for i in range(45,60):
${"  0.223  0.223 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 3.755  35.880   1.123   9.942   0.017 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 5
--  0.601   0.601   1.179  21.790   5.670   0.995    0.000   0.000   7.508   2.865   1.100   0.999    1.786   7.927   1.079   9.940   0.191  /
% for i in range(60,75):
${"  0.601  0.601 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 1.786   7.927   1.079   9.940   0.191 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 6
--  0.648   0.648   1.100  29.055   6.905   0.995    0.000   0.000   8.323   3.093   1.100   0.999    1.517   6.080   1.068   9.943   0.343  /
% for i in range(75,90):
${"  0.648  0.648 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 1.517   6.080   1.068   9.943   0.343 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 7
--  0.021   0.021   1.881   4.830   1.100   0.995    0.000   0.000   4.970   2.286   1.115   1.002    6.714 391.550   1.246   9.956   0.002  /
% for i in range(90,105):
${"  0.021  0.021 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 6.714 391.550   1.246   9.956   0.002 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 8
--  0.118   0.118   2.013   4.158   1.100   0.995    0.000   0.000   5.136   2.282   1.107   1.002    4.468  43.215   1.123   9.943   0.010  /
% for i in range(105,120):
${"  0.118  0.118 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 4.468  43.215   1.123   9.943   0.010 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 9
--  0.021   0.021   1.881   4.826   1.100   0.995    0.000   0.000   4.971   2.286   1.114   1.002    6.615 371.221   1.242   9.956   0.002  /
% for i in range(120,135):
${"  0.021  0.021 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 6.615 371.221   1.242   9.956   0.002 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 10
--  0.223   0.223   2.165   3.424   1.100   0.995    0.000   0.000   5.361   2.298   1.100   1.002    3.755  35.880   1.123   9.942   0.017  /
% for i in range(135,150):
${"  0.223  0.223 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 3.755  35.880   1.123   9.942   0.017 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 11
--  0.601   0.601   2.486   1.019   1.100   0.995    0.000   0.000   7.508   2.865   1.100   0.999    1.786   7.927   1.079   9.940   0.191  /
% for i in range(150,165):
${"  0.601  0.601 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 1.786   7.927   1.079   9.940   0.191 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
-- Table 12
--  0.648   0.648   2.396   0.804   1.100   0.995    0.000   0.000   8.323   3.093   1.100   0.999    1.517   6.080   1.068   9.943   0.343  /
% for i in range(165,180):
${"  0.648  0.648 {0} {1} {2} {3} 0.000  0.000 {4} {5} {6} {7} 1.517   6.080   1.068   9.943   0.343 /".format(max(1.1,lw[i]) , pow(10.0,ew[i]) , max(1.1,tw[i]) , max(0.1,min(1.5,krw[i])) , max(1.1,lo[i]) , pow(10.0,eo[i]) , max(1.1,to[i]) , max(0.1,min(1.5,krow[i])))}
% endfor
SGOFLET
-- Sgl     Sgcr    Lw      Ew      Tw      Krtg ||  Sorg    Sogcr   Lo      Eo      To      Krtog ||  L       E       T       Pcir    Pct
-- Table 1
--  0.000   0.000   2.368   2.065   1.604   1.005    0.000   0.000   4.255   2.438   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(15):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 2
--  0.000   0.000   2.335   2.224   1.713   1.005    0.000   0.000   4.333   2.463   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(15,30):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 3
--  0.000   0.000   2.366   2.068   1.606   1.005    0.000   0.000   4.255   2.438   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(30,45):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 4
--  0.000   0.000   2.273   2.528   1.885   1.005    0.000   0.000   4.443   2.497   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(45,60):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 5
--  0.000   0.000   1.863   8.108   3.709   1.005    0.000   0.000   5.550   2.787   1.100   0.999    1.000   1.000   1.000   0.000   0.000  /
% for i in range(60,75):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 6
--  0.000   0.000   1.578  15.942   4.623   1.005    0.000   0.000   5.969   2.842   1.100   0.999    1.000   1.000   1.000   0.000   0.000  /
% for i in range(75,90):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 7
--  0.000   0.000   2.368   2.065   1.604   1.005    0.000   0.000   4.255   2.438   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(90,105):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 8
--  0.000   0.000   2.335   2.224   1.713   1.005    0.000   0.000   4.333   2.463   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(105,120):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 9
--  0.000   0.000   2.366   2.068   1.606   1.005    0.000   0.000   4.255   2.438   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(120,135):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 10
--  0.000   0.000   2.273   2.528   1.885   1.005    0.000   0.000   4.443   2.497   1.100   0.995    1.000   1.000   1.000   0.000   0.000  /
% for i in range(135,150):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 11
--  0.000   0.000   1.863   8.108   3.709   1.005    0.000   0.000   5.550   2.787   1.100   0.999    1.000   1.000   1.000   0.000   0.000  /
% for i in range(150,165):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor
-- Table 12
--  0.000   0.000   1.578  15.942   4.623   1.005    0.000   0.000   5.969   2.842   1.100   0.999    1.000   1.000   1.000   0.000   0.000  /
% for i in range(165,180):
${"  0.0  0.0 {0} {1} {2} {3}  0.0  0.000 {4} {5} {6} {7}  1.0  1.0  1.0  0.0   0.0 /".format(max(1.1,lg[i]) , pow(10.0,eg[i]) , max(1.1,tg[i]) , max(0.1,min(1.5,krg[i])) , max(1.1,log[i]) , pow(10.0,eog[i]) , max(1.1,tog[i]) , max(0.1,min(1.5,krog[i])))}
% endfor


INCLUDE
 '../include/coarse/swatinit.inc' /

INCLUDE
 '../include/props/drogon.pvt' /

-- Set up tracers
TRACER
 WT1  WAT 'g' /
 WT2  WAT 'g' /
/

EXTRAPMS
  4 /

-- =============================================================================
REGIONS
-- =============================================================================

INCLUDE
 '../include/coarse/eqlnum.inc' /

INCLUDE
 '../include/coarse/fipnum.inc' /

INCLUDE
 '../include/coarse/fipzon.inc' /

INCLUDE
 '../include/coarse/satnum.inc' /


--INCLUDE
-- '../drogon12x5x3.satnum' /
 
INCLUDE
 '../include/coarse/pvtnum.inc' /


-- =============================================================================
SOLUTION
-- =============================================================================
  
--INCLUDE                                
-- '../include/solution/drogon.equil' / --exported by rms   
--INCLUDE
-- '../include/solution/drogon.rxvd' / --!! manually created (7 equil regions)

INCLUDE
 '../include/coarse/init.inc' /
 
INCLUDE                                
 '../include/solution/drogon.thpres' / --exported by rms    

-- Initial tracer concentration vs depth for tracer WT1
TVDPFWT1
 1000  0.0 
 2500  0.0 /   

-- Initial tracer concentration vs depth for tracer WT2
TVDPFWT2
 1000  0.0 
 2500  0.0 /   

RPTSOL
 RESTART=2  FIP=2  'THPRES'  'FIPRESV' /

-- ALLPROPS --> fluid densities, viscosities , reciprocal formation volume factors and phase relative permeabilities
-- NORST=1  --> output for visualization only 
RPTRST
 ALLPROPS RVSAT RSSAT PBPD  NORST=1 RFIP RPORV /


-- =============================================================================
SUMMARY
-- =============================================================================

--RPTONLY

INCLUDE
 '../include/summary/drogon.summary' /


-- =============================================================================
SCHEDULE
-- =============================================================================

-- This reservoir simulation deck is made available under the Open Database
-- License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in
-- individual contents of the database are licensed under the Database Contents
-- License: http://opendatacommons.org/licenses/dbcl/1.0/

-- Copyright (C) 2022 Equinor

--INCLUDE
-- '../include/coarse/schedule.SCH' /

-- This reservoir simulation deck is made available under the Open Database
-- License: http://opendatacommons.org/licenses/odbl/1.0/. Any rights in
-- individual contents of the database are licensed under the Database Contents
-- License: http://opendatacommons.org/licenses/dbcl/1.0/

-- Copyright (C) 2022 Equinor

-- ==================================================================================================
-- 
-- Exported by user eza from RMS12.1 at 2022-05-26 13:21:29
-- 
-- ==================================================================================================

-- Date: 1 JAN 2018

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'R_A2' 'RFT'      6    9 1643.93762   OIL         1*    1*  SHUT    NO    1*    1* /
 'R_A3' 'RFT'      7    11  1604.4718   OIL         1*    1*  SHUT    NO    1*    1* /
 'R_A4' 'RFT'      8    14  1628.1826   OIL         1*    1*  SHUT    NO    1*    1* /
 'R_A5' 'RFT'      8    6 1682.35291   OIL         1*    1*  SHUT    NO    1*    1* /
 'R_A6' 'RFT'      5    12 1693.90759   OIL         1*    1*  SHUT    NO    1*    1* /
/


COMPORD
 'R_A2'  INPUT /
 'R_A3'  INPUT /
 'R_A4'  INPUT /
 'R_A5'  INPUT /
 'R_A6'  INPUT /
/

GRUPTREE
  'OP'      'FIELD' /
  'RFT'     'FIELD' /
  'WI'      'FIELD' /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'R_A2'    6    9    1    1  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    2    2  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    3    3  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    4    4  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    5    5  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    6    6  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    7    7  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    8    8  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    9    9  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    10    10  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    11    11  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    12    12  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    13    13  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    14    14  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    15    15  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    16    16  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    17    17  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    9    18    18  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    19    19  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    27    27  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    28    28  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    29    29  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    30    30  OPEN    2*     0.2413 3* Z /
 'R_A2'    6    8    31    31  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    1    1  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    2    2  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    3    3  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    4    4  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    5    5  OPEN    2*     0.2413 3* Z /
 'R_A3'    7    11    6    6  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    6    6  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    7    7  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    8    8  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    9    9  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    10    10  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    11    11  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    12    12  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    13    13  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    14    14  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    15    15  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    16    16  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    27    27  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    28    28  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    29    29  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    30    30  OPEN    2*     0.2413 3* Z /
 'R_A3'    8    11    31    31  OPEN    2*     0.2413 3* Z /
---------------------------------------------------------------------------------------------------------------
 'R_A4'    8    14    1    1  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    1    1  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    2    2  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    3    3  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    8    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    3    3  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    4    4  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    3    3  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    3    3  OPEN    2*     0.2413 3* X /
 'R_A4'    9    14    2    2  OPEN    2*     0.2413 3* X /
 'R_A4'    9    13    2    2  OPEN    2*     0.2413 3* X /
 'R_A4'    9    13    30    30  OPEN    2*    0.2413 3* X /
 'R_A4'    9    13    30    30  OPEN    2*     0.2413 3* X /
 'R_A4'    10    13    30    30  OPEN    2*    0.2413 3* X /
 'R_A4'    10    13    30    30  OPEN    2*     0.2413 3* X /
 'R_A4'    10    13    30    30  OPEN    2*     0.2413 3* X /
---------------------------------------------------------------------------------------------------------------
 'R_A5'    8    6    1    1  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    2    2  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    3    3  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    4    4  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    5    5  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    6    6  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    7    7  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    8    8  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    9    9  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    10    10  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    11    11  OPEN    2*    0.2413 3* Z /
 'R_A5'    8    6    12    12  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    13    13  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    14    14  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    15    15  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    16    16  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    17    17  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    18    18  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    19    19  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    27    27  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    28    28  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    29    29  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    30    30  OPEN    2*     0.2413 3* Z /
 'R_A5'    8    6    31    31  OPEN    2*     0.2413 3* Z /
---------------------------------------------------------------------------------------------------------------
 'R_A6'    5    12    1    1  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    2    2  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    3    3  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    4    4  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    5    5  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    6    6  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    7    7  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    8    8  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    9    9  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    10    10  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    11    11  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    12    12  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    13    13  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    14    14  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    15    15  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    16    16  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    17    17  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    18    18  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    27    27  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    28    28  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    29    29  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    30    30  OPEN    2*     0.2413 3* Z /
 'R_A6'    5    12    31    31  OPEN    2*     0.2413 3* Z /
---------------------------------------------------------------------------------------------------------------
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'R_A2'  SHUT  ORAT          0         1*         1*    1*         1*         1*         1* /
 'R_A3'  SHUT  ORAT          0         1*         1*    1*         1*         1*         1* /
 'R_A4'  SHUT  ORAT          0         1*         1*    1*         1*         1*         1* /
 'R_A5'  SHUT  ORAT          0         1*         1*    1*         1*         1*         1* /
 'R_A6'  SHUT  ORAT          0         1*         1*    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A2'   YES    NO    NO /
 'R_A3'   YES    NO    NO /
 'R_A4'   YES    NO    NO /
 'R_A5'   YES    NO    NO /
 'R_A6'   YES    NO    NO /
/

TUNING
-- TSINIT       TSMAXZ     TSMINZ     TSMCHP     TSFMAX     TSFMIN     TSFCNV     TFDIFF     THRUPT     TMAXWC
          1         30         1*         1*         1*         1*         1*         1*         1*          1 /
-- TRGTTE       TRGCNV     TRGMBE     TRGLCV     XXXTTE     XXXCNV     XXXMBE     XXXLCV     XXXWFL
         1*         1*         1*         1*         1*         1*         1*         1*         1* /
-- NEWTMX       NEWTMN     LITMAX     LITMIN     MXWSIT     MXWPIT
         12          1         50          1         50         50 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 5 JAN 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A1'   'OP'       8    9 1595.91846   OIL         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A1'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A1'      8    9     1     1  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     2     2  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     3     3  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     4     4  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     5     5  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     7     7  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     8     8  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9     9     9  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    10    10  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    11    11  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    12    12  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    13    13  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    14    14  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    15    15  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    16    16  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    27    27  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    28    28  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    29    29  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    30    30  OPEN    2* 0.2413 1* 5 1*  Z /
 'A1'      8    9    31    31  OPEN    2* 0.2413 1* 5 1*  Z /
---------------------------------------------------------------------------------------------------------------
/

WPIMULT
${" A1 {0} /".format(pow(10.0,wpimult[0]))}
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV  3999.9895 0.01046396   563278.5    1*         1*         1*         1* /
/

WELTARG
 'A1'  BHP  50 /
/

DATES
 1 FEB 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01173127  562930.75    1*         1*         1*         1* /
/

DATES
 1 MAR 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01194996 559445.875    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A2'   YES    NO    NO /
/

DATES
 10 MAR 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A2'   'OP'       6    9 1643.93762   OIL         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A2'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A2'      6    9     1     1  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     2     2  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     3     3  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     4     4  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     5     5  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     7     7  OPEN    2* 0.2413 1* 5 1*  Z /
 'A2'      6    9     8     8  OPEN    2* 0.2413 1* 5 1*  Z /
---------------------------------------------------------------------------------------------------------------
/

WPIMULT
${" A2 {0} /".format(pow(10.0,wpimult[1]))}
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01190207 555478.938    1*         1*         1*         1* /
 'A2'    OPEN  RESV 3998.90845 1.09144855 557876.625    1*         1*         1*         1* /
/

WELTARG
 'A2'  BHP  50 /
/

DATES
 30 MAR 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01198202   552904.5    1*         1*         1*         1* /
 'A2'    OPEN  RESV 3998.86108 1.13892972   549982.5    1*         1*         1*         1* /
/

DATES
 1 APR 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98779 0.01214723 550678.438    1*         1*         1*         1* /
 'A2'    OPEN  RESV  3998.8457 1.15427291     541520    1*         1*         1*         1* /
/

DATES
 28 APR 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98779 0.01225858 549805.688    1*         1*         1*         1* /
 'A2'    OPEN  RESV 3998.81396 1.18605173 552031.063    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A5'   YES    NO    NO /
/

DATES
 1 MAY 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98779  0.0122888 548860.438    1*         1*         1*         1* /
 'A2'    OPEN  RESV 3998.03076 1.96926403 564362.813    1*         1*         1*         1* /
/

DATES
 8 MAY 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A5'   'WI'       8    6    1682.71 WATER         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A5'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A5'      8    6     1     1  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     2     2  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     3     3  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     4     4  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     5     5  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     7     7  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     8     8  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6     9     9  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    10    10  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    11    11  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    12    12  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    13    13  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    14    14  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    15    15  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    16    16  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    17    17  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    18    18  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    19    19  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    27    27  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    28    28  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    29    29  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    30    30  OPEN    2* 0.2413 1* 5 1*  Z /
 'A5'      8    6    31    31  OPEN    2* 0.2413 1* 5 1*  Z /
---------------------------------------------------------------------------------------------------------------
/

WPIMULT
${" A5 {0} /".format(pow(10.0,wpimult[4]))}
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98779 0.01216489 548021.313    1*         1*         1*         1* /
 'A2'    OPEN  RESV 3252.84009  133.61795 473783.719    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
/

DATES
 1 JUN 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01204866     548309    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2367.14575 266.190521 363896.875    1*         1*         1*         1* /
/

DATES
 2 JUN 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01201871  548413.25    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2320.37622 288.573303 360967.719    1*         1*         1*         1* /
/

DATES
 8 JUN 2018 /
/

-- 25kg over 1 day with rate 8000 Sm3/d
WTRACER
-- 55_33-A-5
 A5  WT1  3.125 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01199211 548500.938    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2289.13623 308.386627 359407.906    1*         1*         1*         1* /
/

DATES
 9 JUN 2018 /
/

WTRACER
-- 55_33-A-5
 A5  WT1  0.0 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01192498  548690.75    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2214.33887  361.36554 352996.844    1*         1*         1*         1* /
/

DATES
 22 JUN 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01183807 548896.313    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2094.41846 432.391632 337377.563    1*         1*         1*         1* /
/

DATES
 30 JUN 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01180832 548954.438    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2048.48755 455.179474 330013.531    1*         1*         1*         1* /
/

RPTSCHED
  FIP=2 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 1 JLY 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01179739 548974.875    1*         1*         1*         1* /
 'A2'    OPEN  RESV 2031.80225 462.899078 327175.094    1*         1*         1*         1* /
/

RPTSCHED
  FIP=0 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 3 JLY 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01175203 549050.188    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1972.14526  489.42215 316306.188    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A3'   YES    NO    NO /
/

DATES
 13 JLY 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A3'   'OP'       7    11  1604.4718   OIL         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A3'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A3'      7    11     1     1  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      7    11     2     2  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      7    11     3     3  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      7    11     4     4  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      7    11     5     5  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      7    11     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11     7     7  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11     8     8  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11     9     9  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    10    10  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    11    11  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    12    12  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    13    13  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    14    14  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    15    15  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    16    16  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    27    27  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    28    28  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    29    29  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    30    30  OPEN    2* 0.2413 1* 5 1*  Z /
 'A3'      8    11    31    31  OPEN    2* 0.2413 1* 5 1*  Z /
---------------------------------------------------------------------------------------------------------------
/

WPIMULT
${" A3 {0} /".format(pow(10.0,wpimult[2]))}
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828  0.0116675 549117.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1868.56238  528.61499 297787.156    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.31543 0.68449342 538145.313    1*         1*         1*         1* /
/

WELTARG
 'A3'  BHP  50 /
/

DATES
 1 AUG 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01158203   548983.5    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1755.96851 566.594543 276263.594    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.25903 0.74095553 643722.688    1*         1*         1*         1* /
/

DATES
 25 AUG 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01153841  548822.75    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1700.40942 585.502686 265439.063    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.18701 0.81295449  792995.25    1*         1*         1*         1* /
/

DATES
 1 SEP 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01152227 548699.563    1*         1*         1*         1* /
 'A2'    OPEN  RESV  1673.7832 592.851868 260747.391    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.14185 0.85803682 906019.438    1*         1*         1*         1* /
/

DATES
 12 SEP 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853  0.0115139  548602.25    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1657.58813 596.955322 258068.734    1*         1*         1*         1* /
 'A3'    OPEN  RESV  3999.1123  0.8875308 968189.875    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A4'   YES    NO    NO /
/

DATES
 14 SEP 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01150873 548504.688    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1645.29175 599.732788   255998.5    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.09644 0.90362561 997838.625    1*         1*         1*         1* /
/

DATES
 22 SEP 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A4'   'OP'       8    14 1628.54517   OIL         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A4'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A4'      8    14     1     1  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     1     1  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     2     2  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     3     3  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      8    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     3     3  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     4     4  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     3     3  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     3     3  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    14     2     2  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    13     2     2  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    13    30    30  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      9    13    30    30  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      10    13    30    30  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      10    13    30    30  OPEN    2* 0.2413 1* 5 1*  X /
 'A4'      10    13    30    30  OPEN    2* 0.2413 1* 5 1*  X /
---------------------------------------------------------------------------------------------------------------
/

WELSEGS
--WELL        TDEP       CLEN        VOL  TYPE DROPT MPMOD
 'A4'   1628.54517    2249.68         1*   ABS   HF-    HO /
--SEGS  SEGE BRNCH  SEGJ       CLEN       NDEP       TDIA      ROUGH
     2     2     1     1 2266.41718 1628.89416       0.15    0.00065 /
     3     3     1     2 2312.66912 1629.74062       0.15    0.00065 /
     4     4     1     3 2374.33947 1630.66162       0.15    0.00065 /
     5     5     1     4  2412.5156 1631.20416       0.15    0.00065 /
     6     6     1     5 2459.61176 1631.93379       0.15    0.00065 /
     7     7     1     6 2542.10079 1633.61401       0.15    0.00065 /
     8     8     1     7 2617.29221 1635.56556       0.15    0.00065 /
     9     9     1     8 2693.67418  1637.5024       0.15    0.00065 /
    10    10     1     9 2742.54341 1638.39823       0.15    0.00065 /
    11    11     1    10 2762.39897 1638.64712       0.15    0.00065 /
    12    12     1    11 2844.89461   1639.265       0.15    0.00065 /
    13    13     1    12 2940.68421   1640.047       0.15    0.00065 /
    14    14     1    13 2977.09135 1640.43178       0.15    0.00065 /
    15    15     1    14 3032.45726 1641.08719       0.15    0.00065 /
    16    16     1    15 3164.48871 1643.04043       0.15    0.00065 /
    17    17     1    16 3253.63816 1644.85492       0.15    0.00065 /
    18    18     1    17 3350.58672 1647.42276       0.15    0.00065 /
    19    19     1    18 3488.20062 1652.74152       0.15    0.00065 /
    20    20     1    19 3556.54315 1655.93819       0.15    0.00065 /
    21    21     1    20     3578.5 1656.98743       0.15    0.00065 /
-- ICD segments -----------------------------------------------------
    22    22     2     2 2266.51718 1628.89416       0.15    0.00065 /
    23    23     3     3 2312.76912 1629.74062       0.15    0.00065 /
    24    24     4     4 2374.43947 1630.66162       0.15    0.00065 /
    25    25     5     5  2412.6156 1631.20416       0.15    0.00065 /
    26    26     6     6 2459.71176 1631.93379       0.15    0.00065 /
    27    27     7     7 2542.20079 1633.61401       0.15    0.00065 /
    28    28     8     9 2693.77418  1637.5024       0.15    0.00065 /
    29    29     9    10 2742.64341 1638.39823       0.15    0.00065 /
    30    30    10    11 2762.49897 1638.64712       0.15    0.00065 /
    31    31    11    12 2844.99461   1639.265       0.15    0.00065 /
    32    32    12    13 2940.78421   1640.047       0.15    0.00065 /
    33    33    13    14 2977.19135 1640.43178       0.15    0.00065 /
    34    34    14    15 3032.55726 1641.08719       0.15    0.00065 /
    35    35    15    16 3164.58871 1643.04043       0.15    0.00065 /
    36    36    16    17 3253.73816 1644.85492       0.15    0.00065 /
    37    37    17    18 3350.68672 1647.42276       0.15    0.00065 /
    38    38    18    19 3488.30062 1652.74152       0.15    0.00065 /
    39    39    19    20 3556.64315 1655.93819       0.15    0.00065 /
/

WSEGVALV
--WELL  SEGNO     FCOEFF     FCAREA       PLEN       PDIA     PROUGH      PAREA OP/SH       AMAX
-------------------------------------------------------------------------------------------------
 'A4'      22        0.9 0.00015767          0         1*         1*         1*  OPEN         1* /
 'A4'      23        0.9 0.00021416          0         1*         1*         1*  OPEN         1* /
 'A4'      24        0.9 0.00019698          0         1*         1*         1*  OPEN         1* /
 'A4'      25        0.9 5.7529e-05          0         1*         1*         1*  OPEN         1* /
 'A4'      26        0.9 0.00025645          0         1*         1*         1*  OPEN         1* /
 'A4'      27        0.9 0.00029348          0         1*         1*         1*  OPEN         1* /
 'A4'      28        0.9 0.00050921          0         1*         1*         1*  OPEN         1* /
 'A4'      29        0.9 2.4376e-05          0         1*         1*         1*  OPEN         1* /
 'A4'      30        0.9 0.00010799          0         1*         1*         1*  OPEN         1* /
 'A4'      31        0.9 0.00044198          0         1*         1*         1*  OPEN         1* /
 'A4'      32        0.9 0.00019662          0         1*         1*         1*  OPEN         1* /
 'A4'      33        0.9 4.6094e-05          0         1*         1*         1*  OPEN         1* /
 'A4'      34        0.9 0.00032301          0         1*         1*         1*  OPEN         1* /
 'A4'      35        0.9  0.0005562          0         1*         1*         1*  OPEN         1* /
 'A4'      36        0.9 3.8133e-05          0         1*         1*         1*  OPEN         1* /
 'A4'      37        0.9 0.00060819          0         1*         1*         1*  OPEN         1* /
 'A4'      38        0.9 0.00030924          0         1*         1*         1*  OPEN         1* /
 'A4'      39        0.9 0.00014638          0         1*         1*         1*  OPEN         1* /
-------------------------------------------------------------------------------------------------
/

COMPSEGS
 'A4' /
--   I     J     K BRNCH       MD_S       MD_E   DIR IJK_E       CDEP  CLEN SEGNO
    8    14     1     2 2252.28884 2280.54552    1*    1* 1628.88637    1*    22 /
    8    14     1     2 2233.24329 2252.28884    1*    1* 1628.57307    1*    22 /
    8    14     2     3 2280.54552 2344.79271    1*    1* 1629.70476    1*    23 /
    8    14     3     4 2344.79271 2403.88624    1*    1* 1630.65874    1*    24 /
    8    14     4     5 2403.88624 2421.14496    1*    1* 1631.20514    1*    25 /
    8    14     4     6 2421.14496 2498.07855    1*    1* 1631.98396    1*    26 /
    8    14     4     7 2498.07855 2586.12304    1*    1* 1633.68521    1*    27 /
    9    14     4    8 2586.12304 2648.46138    1*    1* 1636.53921    1*    28 /
    9    14     3     8 2648.46138 2738.88698    1*    1* 1636.62818    1*    28 /
    9    14     4     9 2738.88698 2746.19983    1*    1* 1638.39705    1*    29 /
    9    14     4    10 2746.19983 2778.59811    1*    1*  1638.6287    1*    30 /
    9    14     3    11 2778.59811 2911.19111    1*    1* 1639.28726    1*    31 /
    9    14     3    12 2911.19111 2970.17732    1*    1* 1640.06077    1*    32 /
    9    14     2    13 2970.17732 2984.00538    1*    1* 1640.43245    1*    33 /
    9    13     2    14 2984.00538 3080.90915    1*    1* 1641.11947    1*    34 /
    9    13    30   15 3081.05919 3247.91824    1*    1* 1643.22774    1*    35 /
    9    13    30    16 3247.91824 3259.35808    1*    1* 1644.85593    1*    36 /
    10    13    30   17 3259.35808 3441.81536    1*    1* 1647.85801    1*    37 /
    10    13    30    18 3441.81536 3534.58589    1*    1* 1652.80943    1*    38 /
    10    13    30   19 3534.58589  3578.5004    1*    1* 1655.93922    1*    39 /
/


WPIMULT
${" A4 {0} /".format(pow(10.0,wpimult[3]))}
/


WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01152343 548149.063    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1626.75391 603.420715 252895.531    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.08569 0.91430873 1008678.88    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3998.38892 1.61111939 563054.438    1*         1*         1*         1* /
/

WELTARG
 'A4'  BHP  50 /
/

DATES
 1 OCT 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98853 0.01155542 547511.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1613.70776 605.397339 250939.563    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3999.08179 0.91823024 1017155.94    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.95972  0.0403567 563274.313    1*         1*         1*         1* /
/

DATES
 5 OCT 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01163088 545342.875    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1591.12781 606.189514 247795.703    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3777.78418  4.2843914  951957.75    1*         1*         1*         1* /
 'A4'    OPEN  RESV  3999.9624 0.03755065 560799.938    1*         1*         1*         1* /
/

DATES
 1 NOV 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01170644 543627.375    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1572.55859 604.647705 244998.625    1*         1*         1*         1* /
 'A3'    OPEN  RESV 3045.47925 43.6984138     634619    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96362 0.03634704 556413.813    1*         1*         1*         1* /
/

DATES
 7 NOV 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828  0.0117292 542560.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1566.90198 602.699707 243777.234    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2701.05176 101.172859 513934.938    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96411 0.03595892 553765.375    1*         1*         1*         1* /
/

WRFTPLT
--WELL    RFT   PLT   SEG
 'R_A6'   YES    NO    NO /
/

DATES
 17 NOV 2018 /
/

WELSPECS
--WELL   GROUP  IHEEL JHEEL       DREF PHASE       DRAD INFEQ SIINS XFLOW PRTAB  DENS
 'A6'   'WI'       5    12    1693.99 WATER         1*    1*  SHUT    1*    1*    1* /
/

COMPORD
 'A6'    INPUT /
/

COMPDAT
--WELL      I     J    K1    K2 OP/SH  SATN       TRAN      WBDIA         KH       SKIN DFACT   DIR      PEQVR
---------------------------------------------------------------------------------------------------------------
 'A6'      5    12     1     1  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     2     2  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     3     3  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     4     4  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     5     5  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     6     6  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     7     7  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     8     8  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12     9     9  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    10    10  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    11    11  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    12    12  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    13    13  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    14    14  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    15    15  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    16    16  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    17    17  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    18    18  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    27    27  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    28    28  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    29    29  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    30    30  OPEN    2* 0.2413 1* 5 1*  Z /
 'A6'      5    12    31    31  OPEN    2* 0.2413 1* 5 1*  Z /
---------------------------------------------------------------------------------------------------------------
/

WPIMULT
${" A6 {0} /".format(pow(10.0,wpimult[5]))}
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98828 0.01179661 540130.063    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1565.26575 604.899658 241281.734    1*         1*         1*         1* /
 'A3'    OPEN  RESV  2219.9353 236.568481 387707.531    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96484 0.03527188 549732.188    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A6'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
/

DATES
 1 DEC 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01189484 539077.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1569.52502 609.066956 239856.453    1*         1*         1*         1* /
 'A3'    OPEN  RESV   2057.927 365.239075 331354.938    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96558 0.03441242   547079.5    1*         1*         1*         1* /
/

DATES
 7 DEC 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01191988   538717.5    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1575.09509   611.5578 239684.672    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2047.55322 437.422668 313483.906    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96606 0.03394911 545709.813    1*         1*         1*         1* /
/

DATES
 15 DEC 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01193314 538344.375    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1579.28296 613.164856 239770.344    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2053.37891 479.771881 305594.563    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96606 0.03393355  544903.25    1*         1*         1*         1* /
/

DATES
 17 DEC 2018 /
/

-- 25kg over 1 day with rate 8000 Sm3/d
WTRACER
-- 55_33-A-6
 A6  WT2  3.125 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01193703 538357.188    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1580.43945 613.587463 239824.484    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2055.34253 490.308105 303893.031    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96606 0.03394502 544701.375    1*         1*         1*         1* /
/

DATES
 18 DEC 2018 /
/

WTRACER
-- 55_33-A-6
 A6  WT2  0.0 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804  0.0119545     537822    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1585.92114 615.672913 240243.672    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2043.35376 538.115967 294207.313    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96606 0.03402502   543742.5    1*         1*         1*         1* /
/

DATES
 28 DEC 2018 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804  0.0119719 537098.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV   1590.974 617.852173 240821.938    1*         1*         1*         1* /
 'A3'    OPEN  RESV 2007.26196 583.371704 283031.125    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.96582 0.03413038 542760.063    1*         1*         1*         1* /
/

DATES
 1 JAN 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01201329 535818.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1597.97302 624.054993 242629.469    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1894.48682 699.640198 262325.219    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3999.94653 0.05334856 540320.563    1*         1*         1*         1* /
/

DATES
 1 FEB 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.98804 0.01208858  534385.75    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1599.77429 631.468323 244210.297    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1770.22449  823.12207 244940.281    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3988.39844 11.6017036 536168.125    1*         1*         1*         1* /
/

DATES
 9 FEB 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3999.45435 0.54581445 534102.375    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1596.56909  637.50769 244581.859    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1701.36377 890.289673 237416.234    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3840.16724 159.832825 514144.969    1*         1*         1*         1* /
/

DATES
 1 MAR 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3990.43262 9.56739998 534361.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1591.50525 643.636475 244510.141    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1648.13306 942.891907  232253.25    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3700.73901 299.260986 493920.125    1*         1*         1*         1* /
/

DATES
 9 MAR 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3975.66675 24.3333054 535467.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1586.30164 648.548462 244196.609    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1613.81042 976.811768 229299.531    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3585.63306 414.366852 477575.594    1*         1*         1*         1* /
/

DATES
 22 MAR 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3962.34814 37.6518288 539551.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1579.90356 653.899536 243660.813    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1577.11768  1009.1441 226502.719    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3492.67798 507.322021 464625.813    1*         1*         1*         1* /
/

DATES
 1 APR 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3927.69873 72.3012695  558563.25    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1566.57153 663.982178 242298.438    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1516.32544 1058.49939 223575.719    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3351.13452 648.865417 445306.563    1*         1*         1*         1* /
/

DATES
 1 MAY 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A2'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A3'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A4'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
/

DATES
 4 MAY 2019 /
/

DATES
 5 MAY 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3876.40869 123.591362 566482.563    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1597.29724 687.544739 249163.391    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1522.07056 1152.00049 225040.703    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3193.48315 806.516846 425859.156    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
/

DATES
 24 MAY 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV  3848.2085 151.791382 589391.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1549.68604 684.721924 242150.813    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1449.44714  1136.4281 226563.031    1*         1*         1*         1* /
 'A4'    OPEN  RESV 3120.33276 879.667175 415393.188    1*         1*         1*         1* /
/

DATES
 1 JUN 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3827.82935 172.170761 606056.125    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1533.81604  691.15863 239458.703    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1421.28906 1147.63147 227867.219    1*         1*         1*         1* /
 'A4'    OPEN  RESV  3064.2334 935.766724 411152.906    1*         1*         1*         1* /
/

DATES
 14 JUN 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3804.16333 195.836624 624977.688    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1518.06494 699.196899 237365.031    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1391.61731 1166.80688 226561.578    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2994.20337 1005.79657 403562.406    1*         1*         1*         1* /
/

DATES
 30 JUN 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3792.61279 207.387222 633460.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1511.03613 703.192017 236356.109    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1378.89795 1176.75281 225310.594    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2936.14355 1063.85645 396648.281    1*         1*         1*         1* /
/

RPTSCHED
  FIP=2 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 1 JLY 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3771.18213 228.817932 647367.938    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1498.30872 710.865356 234322.344    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1359.59937 1194.32544  222327.25    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2789.32104 1210.67883 376566.563    1*         1*         1*         1* /
/

RPTSCHED
  FIP=0 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 27 JLY 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3749.53003 250.469894  660348.75    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1485.08545  718.83136 232329.516    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1342.22644 1211.48352 219064.281    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2637.18457 1362.81543 355921.031    1*         1*         1*         1* /
/

DATES
 1 AUG 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3734.11816 265.881836 668258.813    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1475.77759 724.308838 231105.391    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1331.35535 1222.35339 216637.563    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2574.37109 1425.62903 347602.375    1*         1*         1*         1* /
/

DATES
 16 AUG 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3710.44336 289.556641 684989.125    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1464.71655 730.747498 229724.594    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1319.03223 1234.10376 213869.063    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2518.67578 1481.32422 340194.906    1*         1*         1*         1* /
/

DATES
 24 AUG 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3681.52246 318.477539  703226.25    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1458.29785 734.494995 228937.531    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1312.14063 1240.16052 212275.422    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2492.52856 1507.47131 336840.688    1*         1*         1*         1* /
/

DATES
 1 SEP 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3638.32739 361.672699 721560.938    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1452.35522 738.021118 228205.406    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1305.78784 1245.32043 210830.109    1*         1*         1*         1* /
 'A4'    OPEN  RESV   2471.073 1528.92688 334120.563    1*         1*         1*         1* /
/

DATES
 6 SEP 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3510.09155 489.908569   737026.5    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1438.56433 746.250305     226473    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1291.68713 1255.00745 207513.453    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2427.31128  1572.6886 328600.781    1*         1*         1*         1* /
/

DATES
 1 OCT 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3323.31592 676.684204 711349.313    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1418.99524 758.149902 223915.406    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1270.18689 1263.45288 202419.344    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2369.31445 1630.68567 321294.375    1*         1*         1*         1* /
/

DATES
 19 OCT 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV  3234.2373 765.762756 686131.938    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1405.25696 767.045044 222038.656    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1255.01782 1267.71106 198723.328    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2327.72632 1672.27356 315784.563    1*         1*         1*         1* /
/

DATES
 1 NOV 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A2'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A3'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A4'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
/

DATES
 2 NOV 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3172.63916  827.36084 639673.563    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1416.68066 783.946289 223371.891    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1271.66711 1296.96948 195164.063    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2303.01343 1696.98657 312427.031    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
/

DATES
 8 NOV 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3143.18604 856.814026 637083.563    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1399.19897 778.139771 222045.547    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1256.56067 1281.89771 195644.328    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2275.78882 1724.21118 308180.813    1*         1*         1*         1* /
/

DATES
 16 NOV 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3087.55811 912.441833 625077.875    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1385.23218 783.118042 220022.281    1*         1*         1*         1* /
 'A3'    OPEN  RESV   1243.677 1279.53711     194675    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2233.90869 1766.09143 301915.156    1*         1*         1*         1* /
/

DATES
 29 NOV 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 3048.02832 951.971619 614447.563    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1377.62744 787.372498 218735.344    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1237.11365 1280.48987 193865.547    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2206.61792 1793.38196 298490.094    1*         1*         1*         1* /
/

DATES
 1 DEC 2019 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2942.80933 1057.19067 581114.438    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1362.15857 798.075684 216617.672    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1223.29834 1286.81079 191095.203    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2147.23511 1852.76477 290121.719    1*         1*         1*         1* /
/

DATES
 1 JAN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2807.17383 1192.82605     536416    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1345.53455 811.305969 214192.484    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1209.65979 1296.30786 186902.813    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2082.39502 1917.60498   281177.5    1*         1*         1*         1* /
/

DATES
 11 JAN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2721.91187 1278.08826 506267.344    1*         1*         1*         1* /
 'A2'    OPEN  RESV   1334.755 821.127808 212483.375    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1201.00745 1303.75879 183629.844    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2043.38013    1956.62 275790.656    1*         1*         1*         1* /
/

DATES
 31 JAN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2674.17212 1325.82776 488282.219    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1328.47168 827.208435 211493.875    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1195.91907 1308.36646 181668.703    1*         1*         1*         1* /
 'A4'    OPEN  RESV 2021.94714 1978.05286 272838.125    1*         1*         1*         1* /
/

DATES
 1 FEB 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2648.99634 1351.00366 478628.844    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1325.18518 830.657471 210994.344    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1193.24023 1311.08765 180621.656    1*         1*         1*         1* /
 'A4'    OPEN  RESV  2011.3291  1988.6709 271421.344    1*         1*         1*         1* /
/

DATES
 8 FEB 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2593.17627 1406.82385   458543.5    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1318.93018 837.627258 210054.859    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1187.93066 1316.50732 178672.734    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1992.20593 2007.79407 268881.219    1*         1*         1*         1* /
/

DATES
 21 FEB 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2525.94556 1474.05457 435413.625    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1312.76196 845.093811 209114.828    1*         1*         1*         1* /
 'A3'    OPEN  RESV  1182.4718 1322.10791 176763.719    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1974.11804 2025.88196 266450.719    1*         1*         1*         1* /
/

DATES
 1 MAR 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2392.54443 1607.45544 390659.125    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1303.09399 859.976013 207572.094    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1172.33911 1332.95349 173565.016    1*         1*         1*         1* /
 'A4'    OPEN  RESV  1944.0498  2055.9502 262389.313    1*         1*         1*         1* /
/

DATES
 1 APR 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2289.25537 1710.74451 356367.281    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1296.56995 872.941589 206486.094    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1163.89807 1341.91687  171017.25    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1920.26685 2079.73315 259165.734    1*         1*         1*         1* /
/

DATES
 4 APR 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2215.30371 1784.69629     335333    1*         1*         1*         1* /
 'A2'    OPEN  RESV  1294.0177 882.684143 206020.438    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1158.07861 1348.51318 169433.313    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1904.13245 2095.86743 256960.078    1*         1*         1*         1* /
/

DATES
 24 APR 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 2126.27124 1873.72876 311949.875    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1292.67358 894.752686 205741.719    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1151.78809 1356.39575 167820.391    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1886.06848 2113.93164 254509.469    1*         1*         1*         1* /
/

DATES
 1 MAY 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A2'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A3'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
 'A4'    OPEN  RESV          0          0          0    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN          0         1*         1*    1*    4*  RATE /
/

DATES
 2 MAY 2020 /
/

DATES
 5 MAY 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 1762.09607 2237.90405 238855.703    1*         1*         1*         1* /
 'A2'    OPEN  RESV  1359.6792 940.251099 215853.172    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1195.63831 1449.67932 165997.781    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1845.60669 2154.39331 249710.234    1*         1*         1*         1* /
/

WCONINJH
--WELL  PHASE OP/SH       RATE        BHP        THP   VFP         CTL
 'A5'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
 'A6'   WATER  OPEN       8000         1*         1*    1*    4*  RATE /
/

DATES
 15 MAY 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 1880.98889 2119.01099 257948.125    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1318.06689  931.15979  211670.75    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1148.06421 1384.01355 167351.797    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1881.04968 2118.95044 254340.547    1*         1*         1*         1* /
/

DATES
 1 JUN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 1800.71265 2199.28735 239597.391    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1312.44312  984.85498 210726.531    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1115.60596 1381.58081 165085.781    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1846.33459 2153.66528 249336.297    1*         1*         1*         1* /
/

DATES
 27 JUN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV   1722.625   2277.375 224937.641    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1318.88147   1035.495 211451.516    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1100.93286 1387.04382 162808.797    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1824.04443 2175.95557 246256.984    1*         1*         1*         1* /
/

DATES
 30 JUN 2020 /
/

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 1716.85278 2283.14722 223893.953    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1319.60852  1040.1532 211521.656    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1100.02966 1387.47205 162594.109    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1822.49243 2177.50757 246058.859    1*         1*         1*         1* /
/

RPTSCHED
  FIP=2 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES /

DATES
 1 JLY 2020 /
/

--------------
--END
--------------

WCONHIST
--WELL  OP/SH   CTL       ORAT       WRAT       GRAT   VFP        ALQ        THP        BHP
 'A1'    OPEN  RESV 1711.04138  2288.9585 222848.125    1*         1*         1*         1* /
 'A2'    OPEN  RESV 1320.36243 1044.99292 211598.484    1*         1*         1*         1* /
 'A3'    OPEN  RESV 1099.16235 1387.92432 162394.953    1*         1*         1*         1* /
 'A4'    OPEN  RESV 1820.97083  2179.0293 245861.344    1*         1*         1*         1* /
/

RPTSCHED
  FIP=0 WELLS=0 /

RPTRST
 BASIC=2 FLOWS FLORES/
