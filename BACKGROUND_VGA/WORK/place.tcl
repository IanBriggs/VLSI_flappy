#######################################################
# Cell Placement Command script (Erik Brunvand, 2013) #
#                                                     #
# This sub-script works with top.tcl and EDI 13 (F13) #
#                                                     #
# This script places the standard cells. Note that    #
# this script places standard cells only, not blocks  #
# or other macros. If you have large macro blocks to  #
# place you should do that by hand. See Chapter 13 in #
# the CAD book for details.                           #
#######################################################

puts "----------Placing Cells-----------"
# Let the tool know we're in a 600nm process
# But, the largest process it cares about is 250nm... 
# Everything larger than 250nm is treated the same. 
setDesignMode -process 250

# Place the standard cells
setPlaceMode -timingDriven true \
             -reorderScan true \
             -congEffort medium \
             -doCongOpt false \
             -modulePlan true \
             -fp false

# Only turn the optimizations on if needed (by uncommenting
# the following line). We'll do  more optimization later
# NOTE that PrePlaceOpt in PlaceDesign will remove buffers
# on feed-through signals in the netlist. This causes 
# problems for other parts of the flow because it may result
# in "assign" statements in the final palced and routed 
# netlist! So, we turn it off here... 
placeDesign -inPlaceOpt -noPrePlaceOpt
setDrawView place

# Now run the first optimization step - pre-CTS 
# (Clock Tree Synthesis). This is in-place optimization. 
setOptMode -fixCap true -fixTran true -fixFanoutLoad false

# do the optimization and timing. Save the results in the 
# reports directory. 
optDesign -preCTS -drv
timeDesign -reportOnly -slackReports \
          -outDir ${BASENAME}_reports/preCTSOptTimingReports

# Save the design so far
saveDesign ${BASENAME}_placed.enc
puts "-------------Done Placing Cells-----"

