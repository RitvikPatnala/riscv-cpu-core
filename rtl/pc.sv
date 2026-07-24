module program_counter (
    input logic clk, 
    input logic [31:0] pc_next,
    input logic reset,
    output logic [31:0] pc
);
    
    always_ff @ (posedge clk) begin
        if (reset) begin
            pc <= 32'b0;
        end
        else begin
            pc <= pc_next;
        end
    end


endmodule

module add_4 (
    input logic [31:0] pc,
    output logic [31:0] pc_add_4
);
    assign pc_add_4 = pc + 32'd4;
    
endmodule

module add_imm (
    input logic [31:0] pc, 
    input logic [31:0] immediate, 
    output logic [31:0] branch_address
);

    assign branch_address = pc + immediate;
    
endmodule