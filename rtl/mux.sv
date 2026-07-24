module mux (
    input logic [31:0] input_1, 
    input logic [31:0] input_2, 
    input logic mux_select, 
    output logic [31:0] mux_output
);
    
    always_comb begin
        if (mux_select == 0) begin
            mux_output = input_1;
        end
        else begin
            mux_output = input_2;
        end
    end

endmodule