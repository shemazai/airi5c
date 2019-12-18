Man kann das Projekt über "File>Project>Open" in Vivado öffnen und anschließend Synthetisieren um es im Hardware Manager auf das FPGA-Board zu laden.

Alternativ kann man auch direkt den Hardwaremanager im Vivado-Startmenü aufrufen und eine FPGA-Konfigurationsdatei auf den QSPI-Flash laden, damit nach jedem Neustarten der RISCV auf das FPGA geladen wird.
Über "Tools>Generate Memory Configuration Files" lässt sich eine Konfigurationsdatei erstellen.
