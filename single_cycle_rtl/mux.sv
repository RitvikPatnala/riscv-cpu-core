module two_input_mux (
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

module three_input_mux (
    input logic [31:0] input_1, 
    input logic [31:0] input_2,
    input logic [31:0] input_3, 
    input logic [1:0] mux_select, 
    output logic [31:0] mux_output
);

    always_comb begin
        if (mux_select == 2'b00) begin
            mux_output = input_1;
        end
        else if (mux_select == 2'b01) begin
            mux_output = input_2;
        end
        else if (mux_select == 2'b10) begin
            mux_output = input_3;
        end
        else begin
            mux_output = 32'bx;
        end
    end

endmodule

module five_input_mux (
    input logic [31:0] input_1,
    input logic [31:0] input_2,
    input logic [31:0] input_3, 
    input logic [31:0] input_4,
    input logic [31:0] input_5,
    input logic [2:0] mux_select, 
    output logic [31:0] mux_output
);

always_comb begin
    if (mux_select == 3'b000) begin
        mux_output = input_1;
    end
    else if (mux_select == 3'b001) begin
        mux_output = input_2;
    end
    else if (mux_select == 3'b010) begin
        mux_output = input_3;
    end
    else if (mux_select == 3'b011) begin
        mux_output = input_4;
    end
    else if (mux_select == 3'b100) begin
        mux_output = input_5;
    end
    else begin
        mux_output = 32'bx;
    end
end
    
endmodule