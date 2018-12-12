database -open simout -shm 
probe -create raifes_qspi_if_tb -depth all -all -all -shm -database simout
run
exit
