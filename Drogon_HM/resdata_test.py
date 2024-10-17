from resdata.grid import Grid
from resdata.resfile import ResdataFile
from resdata.well import (
    WellInfo,
    WellConnection,
    WellType,
    WellConnectionDirection,
    WellSegment,
)
from resdata.rft.well_trajectory import WellTrajectory

rd_sum = ResdataFile('Crashdump/DROGON_HIST_LET_1.X0030')
grid = Grid('Crashdump/DROGON_HIST_LET_1.EGRID')
WI = WellInfo(grid, rd_sum)
print(WI.allWellNames())

W2 = WI['A4']
well_state = W2[0]
print(well_state.wellType())
global_connections = well_state.globalConnections()

for conn in global_connections:
    i, j, k = conn.ijk()
    print(conn.ijk(), conn.gasRate())
    print(grid.global_index(ijk=conn.ijk()))