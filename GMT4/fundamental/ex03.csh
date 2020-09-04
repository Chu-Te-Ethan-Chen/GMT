#!/bin/csh
set figure = ex03.ps

# lower left
psbasemap -R118/123/21/27 -JX3i/2i -Ba1f0.5g1:."basemap 1": -K -P -X0.8i > $figure

#lower right
psbasemap -R118/123/21/27 -JX3i -Ba2f1:x:/a1:y:WSne:."basemap 2": -K -O -X4.2i >> $figure

#upper right
psbasemap -R118/123/21/27 -JX3i -Ba1f1WS:."basemap 3": -K -O -Y4.5i >> $figure

#upper left
psbasemap -R118/123/21/27 -JM3i -Ba1f1:."basemap 4": -O -X-4.2i >> $figure

gs $figure
