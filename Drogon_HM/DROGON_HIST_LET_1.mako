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

-- Options for equilibration
EQLOPTS
 'THPRES'  /

-- Dimensions and options for tracers
-- 2 water tracers
TRACERS
 1*  2 /

-- Grid dimension
INCLUDE
  '../include/runspec/drogon.dimens' / -- exported by rms

-- Table dimensions
--INCLUDE
--  '../include/runspec/drogon.tabdims' / -- exported by rms
TABDIMS
-- NTSFUN  NTPVT  NSSFUN  NPPVT  NTFIP  NRPVT   ...  
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

--FMTOUT
--FMTIN

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
 '../include/grid/drogon.grid' / --exported by rms

INCLUDE
 '../include/grid/drogon.faults' / --exported by rms

INCLUDE
 '../include/grid/drogon.poro' / --exported by rms
 
INCLUDE
 '../include/grid/drogon.perm' / --exported by rms
 
INCLUDE
 '../include/grid/drogon.multnum' / --exported by rms

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
 '../include/edit/drogon.trans' / --exported by rms


-- =============================================================================
PROPS
-- =============================================================================

FILLEPS

--INCLUDE                                
-- '../include/props/drogon.sattab' / --exported by rms

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
 '../include/props/drogon.swatinit' / --exported by rms

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
 '../include/regions/drogon.eqlnum' / --exported by rms

INCLUDE
 '../include/regions/drogon.fipnum' / --exported by rms

INCLUDE
 '../include/regions/drogon.fipzon' / --exported by rms

--INCLUDE
-- '../include/regions/drogon.satnum' / --exported by rms
INCLUDE
'../drogon12x5x3.satnum' /



INCLUDE
 '../include/regions/drogon.pvtnum' / --exported by rms


-- =============================================================================
SOLUTION
-- =============================================================================
  
INCLUDE                                
 '../include/solution/drogon.equil' / --exported by rms   
INCLUDE
 '../include/solution/drogon.rxvd' / --!! manually created (7 equil regions)
 
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

SUMTHIN
 1 /

INCLUDE
 '../include/summary/drogon.summary' /


-- =============================================================================
SCHEDULE
-- =============================================================================

INCLUDE
 '../include/schedule/drogon_hist.sch' / -- exported by rms

