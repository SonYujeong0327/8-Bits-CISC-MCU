
module mcu (
    input           clk,
    input           resetb,
    input   [7:0]   wordin,
    output  [7:0]   wordout
);


// temporary registers
reg     [7:0]   rW; 
reg     [7:0]   rZ;

// main registers
reg     [7:0]   R   [0:3];
reg     [15:0]  PC; 

// data bus
reg     [7:0]   current;

// control bus
reg             pcb;
reg             opb;


// MEMORY
wire    [15:0]  address;
assign address = PC;
assign dataout = mem[address];

always @ (*)
    if (~opb)
        current <= dataout;
    else
        current <= current;

reg     [7:0]   mem     [0:65535];          // ~64kB memory available
wire    [7:0]   datain;
wire    [7:0]   dataout;

assign wordout = mem[16'h5000];             // memory mapped I/O
always @ (*)
    mem[16'h5005] <= wordin;

always @ (negedge resetb)
    if(~resetb)     // Test program here
        begin
            mem[16'h2000] <= {`MVI, `A};
            mem[16'h2001] <= 8'h05;
            mem[16'h2002] <= {`DCR, `A};
            mem[16'h2003] <= {`BNZ, `A};
            mem[16'h2004] <= 8'h02;
            mem[16'h2005] <= 8'h20;
            mem[16'h2006] <= `HLT;


            mem[16'h5000] <= 0;
        end




// Test register data
wire    [7:0]   acc;
wire    [7:0]   b;
wire    [7:0]   c;
wire    [7:0]   d;
wire    [7:0]   test;

assign acc = R[0];
assign b = R[1];
assign c = R[2];
assign d = R[3];
assign test = mem[16'h3000];


// initialize registers, buses
always @ (negedge resetb)
    if (~resetb)
        begin
            PC <= 16'h2000;
            pcb <= 0;
            opb <= 0;
        end
        
always @ (negedge resetb)
    if (~resetb)
    begin
        rW <= 0;
        rZ <= 0;
        R[0] <= 0;
        R[1] <= 0;
        R[2] <= 0;
        R[3] <= 0;
    end


// instruction decoder
always @ (posedge clk)
    if (~opb)
        if (current[7:6] == 2'b01)                  
            case (current[5:2])                     // MOV
                4'h0 :    
                    case (current[1:0])
                        2'b01 : begin
                            R[1] <= R[0];
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[2] <= R[0];
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[3] <= R[0];
                            PC = PC + 1;
                        end
                    endcase
                4'h1 :                              // ADD
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] + R[0];
                            PC = PC + 1;
                        end
                        2'b01 : begin
                            R[0] <= R[0] + R[1];
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[0] <= R[0] + R[2];
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[0] <= R[0] + R[3];
                            PC = PC + 1;
                        end
                    endcase
                4'h2 :                              // SUB
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] - R[0];
                            PC = PC + 1;
                        end
                        2'b01 : begin
                            R[0] <= R[0] - R[1];
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[0] <= R[0] - R[2];
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[0] <= R[0] - R[3];
                            PC = PC + 1;
                        end
                    endcase
                4'h3 :                              // ANA
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] & R[0];
                            PC = PC + 1;
                        end
                        2'b01 : begin
                            R[1] <= R[0] & R[1];
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[0] <= R[0] & R[2];
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[0] <= R[0] & R[3];
                            PC = PC + 1;
                        end
                    endcase
                4'h4 :                              // ORA
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] | R[0];
                            PC = PC + 1;
                        end
                        2'b01 : begin
                            R[0] <= R[0] | R[1];
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[0] <= R[0] | R[2];
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[0] <= R[0] | R[3];
                            PC = PC + 1;
                        end
                    endcase
                4'h5 :                              // INR
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] + 1;
                            PC = PC + 1;
                        end
                        2'b01 : begin
                            R[1] <= R[1] + 1;
                            PC = PC + 1;
                        end
                        2'b10 : begin
                            R[2] <= R[2] + 1;
                            PC = PC + 1;
                        end
                        2'b11 : begin
                            R[3] <= R[3] + 1;
                            PC = PC + 1;
                        end
                    endcase
                4'h6 :                              // DCR
                    case (current[1:0])
                        2'b00 : begin
                            R[0] <= R[0] - 1;
                            PC <= PC + 1;
                        end
                        2'b01 : begin
                            R[1] <= R[1] - 1;
                            PC <= PC + 1;
                        end
                        2'b10 : begin
                            R[2] <= R[2] - 1;
                            PC <= PC + 1;
                        end
                        2'b11 : begin
                            R[3] <= R[3] - 1;
                            PC <= PC + 1;
                        end
                    endcase
            endcase

        else if (current[7:6] == 2'b10)
            case (current[5:2])
                4'h7 : begin                        // MVI
                    R[current[1:0]] <= mem[PC + 1];
                    PC = PC + 2;
                end
                4'h8 : begin                        // ADI
                    R[0] <= R[0] + mem[PC + 1];
                    PC = PC + 2;
                end
                4'h9 : begin                        // SUI
                    R[0] <= R[0] - mem[PC + 1];
                    PC = PC + 2;
                end
                4'hA : begin                        // ANI
                    R[0] <= R[0] & mem[PC + 1];
                    PC = PC + 2;
                end
                4'hB : begin                        // ORI
                    R[0] <= R[0] | mem[PC + 1];
                    PC = PC + 2;
                end
            endcase
        
        else if (current[7:6] == 2'b00)             // HLT
            if (current[5] == 1'b1)
                pcb <= 1;
    
    
    
always @ (posedge clk)   
    if (opb)
        if (current[7:6] == 2'b11)
            case (current[5:2])
                4'h0 : begin                        // LDA         
                    rZ <= mem[PC + 1];
                    rW <= mem[PC + 2];
                    PC = PC + 1;   
                end
                4'h1 : begin                        // STA
                    rZ <= mem[PC + 1];
                    rW <= mem[PC + 2];
                    PC = PC + 1;
                end
                4'h2 : begin                        // BR
                    rZ <= mem[PC + 1];
                    rW <= mem[PC + 2];
                    PC = PC + 1;
                end
                4'h3 : begin                        // BNZ
                    rZ <= mem[PC + 1];
                    rW <= mem[PC + 2];
                    PC = PC + 1;
                end
            endcase
                

always @ (negedge clk)
    if (current[7:6] == 2'b11)
        if (~opb)
            opb <= 1;
        else
            begin
                case (current[5:2])
                    4'h0 : begin                      
                        R[0] <= mem[{rW, rZ}];
                        PC = PC + 2;
                    end
                    4'h1 : begin                      
                        mem[{rW, rZ}] <= R[0];
                        PC = PC + 2;
                    end
                    4'h2 : PC <= {rW, rZ};
                    4'h3 :
                        case (current[1:0])
                            00 : begin
                                if (R[0] == 0)
                                    PC <= PC + 2;
                                else
                                    PC <= {rW, rZ};
                            end
                            01 : begin
                                if (R[1] == 0)
                                    PC <= PC + 2;
                                else
                                    PC <= {rW, rZ};
                            end
                            10 : begin
                                if (R[2] == 0)
                                    PC <= PC + 2;
                                else
                                    PC <= {rW, rZ};
                            end
                            11 : begin
                                if (R[3] == 0)
                                    PC <= PC + 2;
                                else
                                    PC <= {rW, rZ};
                            end
                        endcase
                endcase
                opb = 0;
            end
    else
        opb <= opb;

endmodule