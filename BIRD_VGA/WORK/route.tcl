#######################################################
# Signal routing   (Erik Brunvand, 2013)              #
#                                                     #
# This sub-script works with top.tcl and EDI 13 (F13) #
#                                                     #
# This script does the actual wire routing for the    #
# macro.                                              #
#######################################################

puts "-----------Routing-----------"
#
# Unfix the clock nets to avoid routing problems.
changeUseClockNetStatus -noFixedNetWires

# Configure NanoRoute to do the final routing...

# Use multi-cut (stacked) vias if possible
setNanoRouteMode -drouteUseMultiCutViaEffort medium

# range of Tdr (timing driving layout) effort is 0-10
# The higher the number, the more EDI tries to reach the 
# specified timing, but this may lead to congestion problems. 
setNanoRouteMode -routeTdrEffort 9

# Some other nanoroute parameters - derived from the Cadence tutorial
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithTimingDriven 1
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven false

# print out all the settings in the log file for future reference
# If you want to play with the router settings, it's helpful to 
# know what they are, and what they're currently set to. 
getNanoRouteMode 

# Do the actual routing with globalDetailRoute
routeDesign -globalDetail

puts "----------Timing design--------------"
# Check timing after routing.
# note that the effort level must be low because we don't have a capTable
setExtractRCMode -engine postRoute
setExtractRCMode -effortLevel low
setAnalysisMode -analysisType onChipVariation
extractRC
timeDesign -postRoute -prefix TimingReports \
    -outDir ${BASENAME}_reports/postroute

puts "---------Post-route optimize---------"
#
# The final optimization step - post-route
setAnalysisMode -cppr both \
                -clockGatingCheck true \
                -timeBorrowing true \
                -useOutputPinCap true \
                -sequentialConstProp false \
                -timingSelfLoopsNoSkew false \
                -enableMultipleDriveNet true \
                -clkSrcPath true \
                -warn true \
                -usefulSkew false \
                -analysisType onChipVariation \
                -log true
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute -drv
timeDesign -postRoute -drvReports -slackReports -pathReports \
         -outDir ${BASENAME}_reports/postrouteOpt 

puts "--------Add Filler Cells---------------"
# Add the filler cells
setFillerMode -quiet
addFiller -cell $fillerCells -prefix ${BASENAME}FILL -markFixed

# ecoRoute is recommended by EDI as a step to follwo filler 
# cell insertion. It likely does nothing for us because we're 
# not using any ECO definitions. But, this keeps it from 
# complaining. 
ecoRoute

# Save the design so far
saveDesign ${BASENAME}_routed.enc
puts "-----------Routing done-------------"
