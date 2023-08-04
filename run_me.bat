del *.vcd *.vvp
iverilog -o sim.vvp config.v mcu.v tb_testbench.v
vvp sim.vvp
gtkwave ./sim.vcd
pause

:: 첫 줄은 모든 vcd, vvp 확장자 파일 삭제