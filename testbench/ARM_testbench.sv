

`timescale 1ns/1ps

module testbench();
    //port declarations
    logic clk;
    logic reset;
    logic [31:0] WriteData, ALUResult;
    logic MemWrite;

    //instance of top level processor module
    top dut(clk, reset, WriteData, ALUResult, MemWrite);
    

    //initializing test
    initial
        begin
            $dumpfile("processor.vcd");
            $dumpvars(0,testbench);

            reset <= 1;
            #22;
            reset <= 0;
        end
    
    //generating clock to get sequential tests
    always
        begin
            clk <= 1;
            #5;
            clk <= 0;
            #5;
        end

//check that 7 gets written to address 0x64

always @(negedge clk)
begin
    if(MemWrite)
    begin
        if(ALUResult === 100 && WriteData === 7)
        begin
            $display("Simulation Succeeded");
            $stop;
        end
        else if (ALUResult != 96)
        begin
            $display("Simulation Failed");
        end
    end
end
endmodule