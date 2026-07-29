module clear_lsb (
    input logic [31:0] alu_result, 
    output logic [31:0] jalr_target
);

    assign jalr_target = alu_result & ~1;
    
endmodule