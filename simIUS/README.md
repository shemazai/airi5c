Simulation setup for behavioural/postsyn/postpr simulation using 
incisive (might be usefull for non-ASIC flows as well?)

The program files to be run are created using 
objdump on the executables compiled by Eclipse/GCC.

The format doesn't quite match what can be read by 
the verilog readmemh-commands, so we use a small 
converter tool "convert.c / convert" to do text 
manipulation. Same can maybe be done using unix 
tools, ...

The original program images are in the "hexfiles" 
folder, the converted are in the "memfiles" folder. 

The testbenches load the program files from the 
memfiles folder.

