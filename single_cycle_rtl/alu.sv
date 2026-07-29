module alu (
    input logic [3:0] alu_select, 
    input logic [31:0] src1, src2, 
    output logic [31:0] alu_result
);

    always_comb begin
        case (alu_select)
            4'b0000: alu_result = src1 + src2; // ADD
            4'b0001: alu_result = src1 - src2; // SUB
            4'b0010: alu_result = src1 & src2; // AND
            4'b0011: alu_result = src1 | src2; // OR
            4'b0100: alu_result = src1 ^ src2; // XOR
            4'b0101: alu_result = src1 << src2[4:0]; // sll
            4'b0110: alu_result = src1 >> src2[4:0]; // srl
            4'b0111: alu_result = signed'(src1) >>> signed'(src2[4:0]); // sra
            4'b1000: alu_result = {31'b0, (signed'(src1) < signed'(src2))}; // slt
            4'b1001: alu_result = {31'b0, (unsigned'(src1) < unsigned'(src2))}; // sltu
            4'b1010: alu_result = {31'b0, (src1 == src2)}; // equal
            default: alu_result = 32'b0;
        endcase
    end
    
endmodule