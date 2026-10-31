/ Decoder
module decoder(input logic [1:0] Op,
                input logic[5:0] funct,
                input logic[3:0] RD,
                output logic [1:0] FlagW,
                output logic    PCS, RegW, MemW,
                output logic    MemtoReg, ALUSrc,
                output logic [1:0] ImmSrc, RegSrc, ALUControl);
            
    logic[9:0] controls;
    logic      Branch, ALUOp;


//Main Decoder
always_comb
    case(Op) //casex to treat don't care values of x(undefined),z(high impedance) as any binary 0 or 1

    2'b00: if(funct[5]) controls = 10'b0001001001; //Data-Processing Immediate, Each bit stands for in the truth table like branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp
           
           else   controls = 10'b0000001001; //Data-Processing Register

    2'b01: if(funct[0])  controls = 10'b0101011000;  //LDR instruction, load instruction from memory and write back to register

            else  controls = 10'b0011010100; //STR instruction to store/load data from register to memory

    2'b10: controls = 10'b1001100010;  //B branch instructions

    default: controls = 10'bx;

    endcase

assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = controls;


//ALU Decoder

always_comb

    if(ALUOp) begin  //Which datapath instruction to execute
        case(funct[4:1])
            4'b0100: ALUControl = 2'b00; //ADD
            4'b0010: ALUControl = 2'b01; //Subtract
            4'b0000: ALUControl = 2'b10; //AND
            4'b1100: ALUControl = 2'b11; //OR
            default: ALUControl = 2'b00; //Undefined
        endcase
    
    //Flag updates if S bit is set. Carry C and overflow V only for arithmetic operations
    /*FLAG W[1] AND AND OR for only updating the N,Z flags, and ADD,SUB for updating all flags including flagW[0] to update carry, overflow */
    FlagW[1] = funct[0];
    FlagW[0] = funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
    end

    else begin
        ALUControl = 2'b00; //ADD for non-datapath instructions
        FlagW  = 2'b00; //donot update flags
    end

    //Program Counter PC logic
    assign PCS = Branch | ((RD == 4'b1111) & RegW);

endmodule