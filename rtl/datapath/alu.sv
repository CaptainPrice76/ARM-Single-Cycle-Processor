module ALU (input logic [31:0] a,b,
            input logic[1:0] ALUControl,
            output logic [31:0] Result,
            output logic[3:0] ALUFlags);
        
    logic neg,zero,carry,overflow;
    logic [31:0] binvert;
    logic[32:0] sum;

    assign binvert = ALUControl[0] ? ~b : b;
    assign sum = a + binvert + ALUControl[0];


    always_comb
    case(ALUControl[1:0])
        2'b00: Result = sum;
        2'b01: Result = sum;
        2'b10: Result = a & b;
        2'b11: Result = a | b;
        default: Result = 32'bx;
    endcase

    assign neg = Result[31];
    assign zero = (Result == 32'b0);
    assign carry = sum[32] & (ALUControl[1] == 1'b0);
    assign overflow = (ALUControl[1] == 1'b0) &
                        ~(a[31] ^ b[31] ^ ALUControl[0]) &
                        (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule