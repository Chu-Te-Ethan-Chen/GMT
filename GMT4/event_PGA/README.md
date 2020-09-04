GDMS fullseed files testing
1. create a 'catalog.dat' for target events.
2. put fullseed in the 'seed' dir. 
   Make sure that the name of fullseed files shloud be exactly the same
   with the event name in the catalog.dat.
3. use 'extractAndTransfer.csh' to extract sac files & PZ files of the target event
   from the corresponding fullseed.
4. run 'getPgaDistAzi.csh' to create a TSMIP_PGAs_event.txt
5. use 'plotShakemapPGA.gmt' to plot a shakemap. This script will use 'createXYZ4shakemapPGA.csh'
   to find info in the TSMIP_PGAs_event.txt.
6. use 'plotAZ2Dist.gmt' to plot a AZ_Dist_PGA_event.ps.
7. use 'plotHypocentralDist2PGA.gmt' to plot a HypocentralDist2PGA_event.ps

Notes:
1. extracAndTransfer will filter the waveform to specific frequency.
2. catalog.dat will be used in extractAndTransfer.csh and plot.
