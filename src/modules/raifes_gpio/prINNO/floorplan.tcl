set HEIGHT 500
set WIDTH 410

create_floorplan -flip s -die_size $WIDTH $HEIGHT 17 17 17 17 
read_io_file  -no_die_size_adjust ./raifes_dtm.io

set_db add_rings_stacked_via_top_layer MTL2
set_db add_rings_stacked_via_bottom_layer MTL1 

create_pg_pin -on_die -net vddd!
create_pg_pin -on_die -net gndd!

add_rings -nets {vddd! gndd!} \
-layer {top MTL1 bottom MTL1 left MTL2 right MTL2} \
-offset 2 \
-spacing 2 \
-width 5 \
-jog_distance 0.72 \
-threshold 0.72


connect_global_net vddd! -type pg_pin -pin_base_name vddd! -all 
connect_global_net gndd! -type pg_pin -pin_base_name gndd! -all 

connect_global_net vddd! -type tie_hi -all 
connect_global_net gndd! -type tie_lo -all 
commit_global_net_rules

 
