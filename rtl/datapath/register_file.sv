//Register file module
module regfile(input logic  clk,
                input logic WE3, //Write enable signal
                input logic [3:0] RA1, RA2, WA3,
                input logic[31:0] WD3, R15,
                output logic[31:0] RD1,RD2);

    logic [31:0] rf[14:0];

    //three ported register file
    //read two ports combinationally
    //write third port on rising edge of clock
    //register 15 read PC+8 instead

    initial
        begin
            for(integer i=0; i<15; i++)
                rf[i] = 32'b0;
        end


    always_ff @(posedge clk)
        if (WE3) rf[WA3] <= WD3;

    assign RD1 = (RA1 == 4'b1111) ? R15 : rf[RA1];
    assign RD2 = (RA2 == 4'b1111) ? R15 : rf[RA2]; 

endmodule
