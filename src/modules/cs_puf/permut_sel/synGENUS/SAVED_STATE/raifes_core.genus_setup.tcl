#####################################################################
#
# Genus(TM) Synthesis Solution setup file
# Created by Genus(TM) Synthesis Solution 16.21-s018_1
#   on 10/15/2018 14:56:25
#
# This file can only be run in Genus Common UI mode.
#
#####################################################################


# This script is intended for use with Genus(TM) Synthesis Solution version 16.21-s018_1


# Remove Existing Design
###########################################################
if {[::legacy::find -design design:raifes_core] ne ""} {
  puts "** A design with the same name is already loaded. It will be removed. **"
  delete_obj design:raifes_core
}


# Source INIT Setup file
########################################################
source ./SAVED_STATE/raifes_core.genus_init.tcl
read_metric -id current ./SAVED_STATE/raifes_core.metrics.json

source ./SAVED_STATE/raifes_core.g
puts "\n** Restoration Completed **\n"


# Data Integrity Check
###########################################################
# program version
if {"[string_representation [::legacy::get_attribute program_version /]]" != "16.21-s018_1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden program_version: 16.21-s018_1  current program_version: [string_representation [::legacy::get_attribute program_version /]]"
}
# license
if {"[string_representation [::legacy::get_attribute startup_license /]]" != "Virtuoso_Digital_Implem_XL"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-91] "golden license: Virtuoso_Digital_Implem_XL  current license: [string_representation [::legacy::get_attribute startup_license /]]"
}
# slack
set _slk_ [::legacy::get_attribute slack design:raifes_core]
if {[regexp {^-?[0-9.]+$} $_slk_]} {
  set _slk_ [format %.1f $_slk_]
}
if {$_slk_ != "17.9"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack: 17.9,  current slack: $_slk_"
}
unset _slk_
# multi-mode slack
if {"[string_representation [::legacy::get_attribute slack_by_mode design:raifes_core]]" != "{{mode:raifes_core/slow_ss 17.9}}"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden slack_by_mode: {{mode:raifes_core/slow_ss 17.9}}  current slack_by_mode: [string_representation [::legacy::get_attribute slack_by_mode design:raifes_core]]"
}
# tns
set _tns_ [::legacy::get_attribute tns design:raifes_core]
if {[regexp {^-?[0-9.]+$} $_tns_]} {
  set _tns_ [format %.0f $_tns_]
}
if {$_tns_ != "0"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden tns: 0,  current tns: $_tns_"
}
unset _tns_
# cell area
set _cell_area_ [::legacy::get_attribute cell_area design:raifes_core]
if {[regexp {^-?[0-9.]+$} $_cell_area_]} {
  set _cell_area_ [format %.0f $_cell_area_]
}
if {$_cell_area_ != "1650313"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden cell area: 1650313,  current cell area: $_cell_area_"
}
unset _cell_area_
# net area
set _net_area_ [::legacy::get_attribute net_area design:raifes_core]
if {[regexp {^-?[0-9.]+$} $_net_area_]} {
  set _net_area_ [format %.0f $_net_area_]
}
if {$_net_area_ != "1108789"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden net area: 1108789,  current net area: $_net_area_"
}
unset _net_area_
# scan chain count
if {[llength [::legacy::find design:raifes_core -scan_chain *]] != "1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden # scan chains: 1  current # scan chains: [llength [::legacy::find design:raifes_core -scan_chain *]]"
}
# library domain count
if {[llength [::legacy::find /libraries -library_domain *]] != "1"} {
   mesg_send [::legacy::find -message /messages/PHYS/PHYS-92] "golden # library domains: 1  current # library domains: [llength [::legacy::find /libraries -library_domain *]]"
}
