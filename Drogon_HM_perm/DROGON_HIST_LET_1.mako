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
INCLUDE
 '../include/runspec/drogon.tabdims' / -- exported by rms
-- TABDIMS
-- NTSFUN  NTPVT  NSSFUN  NPPVT  NTFIP  NRPVT   ...  
--    180      2      200     24     6      20    /

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
 

PERMX
% for i in range(0, len(permx)):
% if permx[i] < 20:
${"%.3f" %(np.exp(permx[i]))}
% else:
${"%.3f" %(np.exp(20))}
% endif
% endfor
/

COPY
 'PERMX'  'PERMY'  /
 'PERMX'  'PERMZ' /
/
 
INCLUDE
 '../include/grid/drogon.multnum' / --exported by rms

INCLUDE
 '../include/grid/drogon.multregt' / --from ert template

-- =============================================================================
EDIT
-- =============================================================================

INCLUDE
 '../include/edit/drogon.trans' / --exported by rms


-- =============================================================================
PROPS
-- =============================================================================

FILLEPS

INCLUDE                                
 '../include/props/drogon.sattab' / --exported by rms


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
--'../include/regions/drogon.satnum' / --exported by rms
-- INCLUDE
-- '../drogon12x5x3.satnum' /



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

