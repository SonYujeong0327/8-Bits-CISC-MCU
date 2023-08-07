del *.vcd *.vvp
iverilog -o sim.vvp config.v mcu.v tb_testbench.v
vvp sim.vvp
gtkwave ./sim.vcd
pause
