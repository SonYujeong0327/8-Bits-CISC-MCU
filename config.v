`timescale 1ns/1ps
`define FTIME 5000


// Registers
`define A       2'b00       // Accumulate
`define B       2'b01
`define C       2'b10
`define D       2'b11


// OPCODE starts with:
// 01 : using internal registers    (1-byte)
`define MOV     6'b010000   // Move
`define ADD     6'b010001   // Add
`define SUB     6'b010010   // Subtract
`define ANA     6'b010011   // And Accumulate
`define ORA     6'b010100   // Or Accumulate
`define INR     6'b010101   // Increment
`define DCR     6'b010110   // Decrement

// 10 : immediate instructions      (2-bytes)
`define MVI     6'b100111   // Move Immediate
`define ADI     6'b101000   // Add Immediate
`define SUI     6'b101001   // Subtract Immediate
`define ANI     6'b101010   // And Immediate
`define ORI     6'b101011   // OR Immediate

// 11 : using memory datas          (3-bytes)
`define LDA     8'b11000000 // Load Accumulate 
`define STA     8'b11000100 // Store Accumulate
`define BR      8'b11001000 // Branch
`define BNZ     6'b110011   // Branch if not Zero

// 00 : HALT      
`define HLT     8'b00111111
