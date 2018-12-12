gcc -m64 -fPIC -shared -I/sw/lx_sw/lxcad/ius8.20/tools/include/ -o jtag_vpi.so jtag_vpi.c

ncverilog -64 jtag_vpi.v +access+r -loadvpi ./jtag_vpi:register_check_for_command,register_send_result_to_server,setup_endofcompile_callbacks,setup_finish_callbacks +jtag_vpi_enable=1
