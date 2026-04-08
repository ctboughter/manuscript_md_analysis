# So this is a lightly edited version of the script
# Taken from VMD - CTB 05/26/22

###############################################################
# sasa.tcl                                                    #
# DESCRIPTION:                                                #
#    This script is quick and easy to provide procedure       #
# for computing the Solvent Accessible Surface Area (SASA)    #
# of Protein and allows Users to select regions of protein.   #
#   AUTHORS:                                                  #
#	Sajad Falsafi (sajad.falsafi@yahoo.com)               #
#       Zahra Karimi                                          #
#       3 Sep 2011                                           #
###############################################################

# The numbers here are

puts "File:"
set direc [gets stdin]
# Navigate to wherever your source data is
cd ../$direc/RAE1_37_1/

# Make sure you have your PDB and DCDs in the same directory
mol load pdb step3_input.pdb
# Ensure that the max number (31 in this example) matches the number of your Dyns
for {set i 1} {$i < 31} {incr i} {mol addfile dyn$i.dcd waitfor all}

##################################################################
# HERE IS WHERE WE HAVE DIFFERENT SELECTIONS FOR DIFFERENT MOLECULES
###################################################################

##################################################################
# RAE1
###################################################################
# Interior pocket only
set sel [atomselect top "segname PROA and resid 5 7 9 24 26 31 33 34 54 57 60 61 65 68 72 76 92 94 96 110 112 114 118 120 122 136 139 143 149 153 156 169 164 167"]

##################################################################
# CD1d
###################################################################
# Interior pocket only
set sel [atomselect top "segname PROA and resid 12 14 16 26 28 30 38 40 47 58 63 66 69 70 73 76 77 80 81 88 90 96 98 100 114 116 118 123 124 131 140 141 144 148 151 153 154 157 158 161 162 165 166 169 173"]

##################################################################
# UFA
###################################################################
# Interior pocket only
set sel [atomselect top "segname PROA and resid 10 12 14 28 30 32 38 62 65 66 69 73 77 81 84 85 88 95 97 99 111 113 115 121 123 125 128 130 132 135 137 139 140 142 143 146 147 153 154 156 157 160 161 164 168 172"]

# Lastly, do the actual calculation
# Make sure you are changing the name of the data output!

set protein [atomselect top "protein"]
set n [molinfo top get numframes]
set output [open "SASA_rae1.dat" w]
# sasa calculation loop
for {set i 0} {$i < $n} {incr i} {
	molinfo top set frame $i
	set sasa [measure sasa 1.4 $protein -restrict $sel]
	puts "\t \t progress: $i/$n"
	puts $output "$sasa"
}
puts "\t \t progress: $n/$n"
puts "Done."
puts "output file: SASA_rae1.dat"
close $output
