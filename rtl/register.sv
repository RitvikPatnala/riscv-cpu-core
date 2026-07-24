module register (
    input logic [31:0] d, 
    input logic clk,
    input logic reset, 
    output logic [31:0] q
);
    always_ff @ (posedge clk)
        if (reset) q <= 32'b0;
        else q <= d; 
            
endmodule