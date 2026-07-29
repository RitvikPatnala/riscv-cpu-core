module sign_extend (
    input logic [31:0] instruction,
    output logic [31:0] immediate
);
    logic [6:0] opcode;

    localparam bit [6:0] I_TYPE = 7'b0010011;
    localparam bit [6:0] LOAD_TYPE = 7'b0000011;
    localparam bit [6:0] S_TYPE = 7'b0100011;
    localparam bit [6:0] B_TYPE = 7'b1100011;
    localparam bit [6:0] J_TYPE = 7'b1101111;
    localparam bit [6:0] JALR = 7'b1100111;
    localparam bit [6:0] LUI = 7'b0110111;
    localparam bit [6:0] AUIPC = 7'b0010111;

    always_comb begin
        opcode = instruction[6:0];

        if (opcode == I_TYPE | opcode == LOAD_TYPE | opcode == JALR) begin
            immediate = signed'(instruction[31:20]);
        end
        else if (opcode == S_TYPE) begin
            immediate = signed'({instruction[31:25], instruction[11:7]});
        end
        else if (opcode == B_TYPE) begin
            immediate = signed'({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0});
        end
        else if (opcode == J_TYPE) begin
            immediate = signed'({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});
        end
        else if (opcode == LUI | opcode == AUIPC) begin
            immediate = {instruction[31:12], 12'b0};
        end
        else begin
            immediate = 32'b0;
        end
    end
endmodule