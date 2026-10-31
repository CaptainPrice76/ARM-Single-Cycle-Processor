//module to connect processor, Instruction memory and data memory
module top(input logic clk,reset,
            output logic [31:0] WriteData, ALUResult,
            output logic        MemWrite);

    logic [31:0] PC, Instr, ReadData;

    //Instance of ARM Processor Core main module
    arm processor(clk, reset, PC, Instr, MemWrite, ALUResult, WriteData, ReadData); 

    //Instance of Instruction Memory ROM
    Imem imem(PC, Instr);

    //Data Memory RAM instance
    Dmem dmem(clk, MemWrite, ALUResult, WriteData, ReadData);

endmodule


//Instruction Memory Module
module Imem(input logic [31:0] a,
            output logic [31:0] rd);
        
    logic [31:0] RAM[0:63]; // 32-bit word size, each entry being 32 bits wide(4 bits),  depth(number of words) being 64

    initial 
        begin
            for (integer i=0; i < 64; i++)
                RAM[i] = 32'b0;

            //Loading machine code instructions 
            $readmemh("program/memfile.dat", RAM);
        
        end
    
    assign rd = RAM[a[31:2]]; 
endmodule



//Data Memory Module
module Dmem(input logic clk, WE,
            input logic [31:0] a, WD,
            output logic [31:0] rd);
        
    logic [31:0] RAM[0:63];

    assign rd = RAM[a[31:2]];

    always_ff @(posedge clk)
        
        if(WE) RAM[a[31:2]] <= WD;

endmodule 