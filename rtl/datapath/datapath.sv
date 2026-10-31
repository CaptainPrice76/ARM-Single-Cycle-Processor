//DataPath
module datapath(input logic     clk, reset,
                input logic [1:0] RegSrc,
                input logic      RegWrite,
                input logic [1:0] ImmSrc,
                input logic     ALUSrc,
                input logic[1:0] ALUControl,
                input logic     MemtoReg,
                input logic     PCSrc,
                output logic [3:0] ALUFlags,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic[31:0] ALUResult, WriteData,
                input logic [31:0] ReadData);

    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result;
    logic [3:0] RA1, RA2;

    //Next program counter logic
    mux2 #(32)  pcMux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    //PCPLUS4 Adder
    adder #(32) pcAdd4(PC, 32'b100, PCPlus4);
    //PCPLUS8 Adder
    adder #(32) pcAdd8(PCPlus4, 32'b100, PCPlus8);
    //Immediate Extension Logic
    extend  ext(Instr[23:0] , ImmSrc, ExtImm);

    //Register File logic
mux2 #(4) RA1mux(Instr[19:16], 4'b1111, RegSrc[0] , RA1);
mux2 #(4) RA2mux(Instr[3:0] , Instr[15:12] , RegSrc[1] , RA2);
regfile   rf(clk, RegWrite, RA1, RA2, 
            Instr[15:12] , Result, PCPlus8,
            SrcA, WriteData);
mux2 #(32) resMux(ALUResult, ReadData, MemtoReg, Result);

//ALU Logic
mux2 #(32) SrcBmux(WriteData, ExtImm, ALUSrc, SrcB);

//Arithmetic Logic Unit
ALU     alu(SrcA, SrcB,  ALUControl,  ALUResult, ALUFlags);

endmodule
