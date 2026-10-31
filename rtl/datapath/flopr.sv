//reset-register
module flopr #(parameter Width=32)(input logic clk, reset,
            input logic  [Width-1:0] d,
            output logic [Width-1:0] q);

    always_ff @(posedge clk, posedge reset)
    if (reset) q<=0;
    else q<=d;

endmodule

// Resettable register with write enable (used for condition flags).
module flopenr #(parameter Width=32) (
    input logic clk, reset, en,
    input logic [Width-1:0] d,
    output logic [Width-1:0] q
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset) q <= '0;
        else if (en) q <= d;
    end
endmodule
