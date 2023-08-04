
module tb_testbench;

reg             CLK, RESETB;
reg     [7:0]   WORDIN;
wire    [7:0]   WORDOUT;

mcu c1(
    .clk(CLK),
    .resetb(RESETB),
    .wordin(WORDIN),
    .wordout(WORDOUT)
);

initial begin
    CLK = 1'b0;
    RESETB = 1'b0;
    
    #`FTIME;
    $finish;
end

always begin
    #50 CLK = ~CLK;
end

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_testbench);
end

endmodule