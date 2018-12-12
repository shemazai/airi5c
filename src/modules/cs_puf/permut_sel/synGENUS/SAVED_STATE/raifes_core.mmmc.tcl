#################################################################################
#
# Created by Genus(TM) Synthesis Solution 16.21-s018_1 on Mon Oct 15 14:56:24 +0200 2018
#
#################################################################################

## library_sets
create_library_set -name slow_ss_lib \
    -timing { /sw/ims_db/lib/L035/l035v0v6dc/.lib/synthesis//L035dc.lib }

## timing_condition
create_timing_condition -name slow_ss_timing \
    -opcond c4 \
    -opcond_library l035_db \
    -library_sets { slow_ss_lib }
create_timing_condition -name fast_ff_timing \
    -opcond c1 \
    -opcond_library l035_db \
    -library_sets { slow_ss_lib }
create_timing_condition -name typical_timing \
    -opcond c0 \
    -opcond_library l035_db \
    -library_sets { slow_ss_lib }

## rc_corner
create_rc_corner -name rc_corner_slow \
    -temperature 150.0 \
    -cap_table /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout//L035dc.cap \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}
create_rc_corner -name rc_corner_typ \
    -temperature 25.0 \
    -cap_table /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout//L035dc.cap \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}
create_rc_corner -name rc_corner_fast \
    -temperature -40.0 \
    -cap_table /sw/ims_db/lib/L035/l035v0v6dc/.lib/layout//L035dc.cap \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name slow_ss_delay \
    -early_timing_condition { slow_ss_timing } \
    -late_timing_condition { slow_ss_timing } \
    -early_rc_corner rc_corner_slow \
    -late_rc_corner rc_corner_slow
create_delay_corner -name fast_ff_delay \
    -early_timing_condition { fast_ff_timing } \
    -late_timing_condition { fast_ff_timing } \
    -early_rc_corner rc_corner_fast \
    -late_rc_corner rc_corner_fast
create_delay_corner -name typical_delay \
    -early_timing_condition { typical_timing } \
    -late_timing_condition { typical_timing } \
    -early_rc_corner rc_corner_typ \
    -late_rc_corner rc_corner_typ

## constraint_mode
create_constraint_mode -name timing_constraints \
    -sdc_files { ./SAVED_STATE//raifes_core.timing_constraints.sdc }

## analysis_view
create_analysis_view -name slow_ss \
    -constraint_mode timing_constraints \
    -delay_corner slow_ss_delay
create_analysis_view -name fast_ff \
    -constraint_mode timing_constraints \
    -delay_corner fast_ff_delay
create_analysis_view -name typical \
    -constraint_mode timing_constraints \
    -delay_corner typical_delay

## set_analysis_view
set_analysis_view -setup { slow_ss } \
                  -hold { fast_ff }
