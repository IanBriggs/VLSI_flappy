#######################################################
#  Power Planning Command script Erik Brunvand, 2013) #
#                                                     #
# This sub-script works with top.tcl and EDI 13 (F13) #
#                                                     #
# This script builds the vdd and gnd networks based   #
# on the parameters in the calling script (top.tcl).  #
#                                                     #
#######################################################
puts "-------------Power Planning----------------"
puts "-------Making power rings------------------"
#
# set the globalNetConnect parameters for power and ground
globalNetConnect $powernet -type pgpin -pin $powernet -all
globalNetConnect $groundnet -type pgpin -pin $groundnet -all
globalNetConnect $powernet -type tiehi
globalNetConnect $groundnet -type tielo

#
# Make power and ground rings - $pwidth microns wide 
# with $pspace spacing between them and centered in the channel 
set sprCreateIeRingNets {}
set sprCreateIeRingLayers {}
set sprCreateIeRingWidth 1.0
set sprCreateIeRingSpacing 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
setAddRingMode -stacked_via_top_layer metal3
setAddRingMode -stacked_via_bottom_layer metal1
addRing -skip_via_on_wire_shape Noshape \
        -skip_via_on_pin Standardcell \
        -center 1 \
        -type core_rings \
        -jog_distance $pspace \
        -threshold $pspace \
        -nets {vdd! gnd!} \
        -follow core \
        -layer {bottom metal1 top metal1 right metal2 left metal2} \
        -width $pwidth \
        -spacing $pspace \
        -offset $pspace

puts "------making power stripes-----------------"
#
# Make Power Stripes. This step is optional. If you keep it 
# in remember to check the stripe spacing 
# (set-to-set-distance = $sspace) and stripe offset 
# (xleft-offset = $soffset)) 
set sprCreateIeStripeNets {}
set sprCreateIeStripeLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeSpacing 2.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -stacked_via_top_layer metal3
setAddStripeMode -stacked_via_bottom_layer metal1
addStripe -skip_via_on_wire_shape Noshape \
          -block_ring_top_layer_limit metal3 \
          -max_same_layer_jog_length 3.0 \
          -snap_wire_center_to_grid Grid \
          -padcore_ring_bottom_layer_limit metal1 \
          -set_to_set_distance $sspace \
          -skip_via_on_pin Standardcell \
          -padcore_ring_top_layer_limit metal3 \
          -spacing $pspace \
          -xleft_offset $soffset \
          -merge_stripes_value 1.5 \
          -layer metal2 \
          -block_ring_bottom_layer_limit metal1 \
          -width $swidth \
          -nets {vdd! gnd! } 

# Use the special-router to route the vdd! and gnd! nets
sroute -connect { blockPin padPin padRing corePin floatingStripe } \
       -layerChangeRange { metal1 metal3 } \
       -blockPinTarget { nearestTarget } \
       -padPinPortConnect { allPort oneGeom } \
       -padPinTarget { nearestTarget } \
       -corePinTarget { firstAfterRowEnd } \
       -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } \
       -allowJogging 1 \
       -crossoverViaLayerRange { metal1 metal3 } \
       -nets { vdd! gnd! } \
       -allowLayerChange 1 \
       -blockPin useLef \
       -targetViaLayerRange { metal1 metal3 }

# Save the design so far
saveDesign ${BASENAME}_pplan.enc
puts "-------------Power Planning done---------"
