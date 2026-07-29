module control (
    input logic [31:0] instruction, 
    input logic branch,
    output logic [3:0] alu_select, 
    output logic reg_write_en, 
    output logic mem_write_en,
    output logic alu_src_mux_select,
    output logic [2:0] writeback_mux_select, 
    output logic [1:0] pc_mux_select

);
    
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    
    localparam bit [6:0] R_TYPE = 7'b0110011;
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
       funct3 = instruction[14:12];
       funct7 = instruction[31:25];
       reg_write_en = 0; mem_write_en = 0; alu_src_mux_select = 0; writeback_mux_select = 3'b0; pc_mux_select = 2'b0;
       alu_select = 4'b0;
       
       case (opcode)
        R_TYPE: begin // R-Type Instructions
            reg_write_en = 1;
            alu_src_mux_select = 0;
            writeback_mux_select = 3'b001;
            case (funct3)
                // ADD or SUB
                3'b000: begin
                    if (funct7 == 7'b0) begin
                        alu_select = 4'b0000;
                    end
                    else begin
                        alu_select = 4'b0001;
                    end
                end 
                // AND
                3'b111: alu_select = 4'b0010;
                // OR
                3'b110: alu_select = 4'b0011;
                // XOR
                3'b100: alu_select = 4'b0100;
                // SLL
                3'b001: alu_select = 4'b0101;
                // SRL or SRA
                3'b101: begin
                    if (funct7 == 7'b0) begin
                        alu_select = 4'b0110; // srl
                    end
                    else begin
                        alu_select = 4'b0111; // sra
                    end
                end
                // SLT
                3'b010: alu_select = 4'b1000;
                // SLTU
                3'b011: alu_select = 4'b1001;
            endcase
        end
        I_TYPE: begin // I-Type Instructions
            reg_write_en = 1;
            alu_src_mux_select = 1;
            writeback_mux_select = 3'b001;
            case (funct3)
                3'b000: alu_select = 4'b0000; // addi
                3'b111: alu_select = 4'b0010; // andi
                3'b110: alu_select = 4'b0011; // ori
                3'b100: alu_select = 4'b0100; // xori
                3'b010: alu_select = 4'b1000; // slti
                3'b011: alu_select = 4'b1001; // sltiu
                3'b001: alu_select = 4'b0101; // slli
                3'b101: begin
                    if (instruction[30] == 0) begin
                        alu_select = 4'b0110; // srli
                    end
                    else begin
                        alu_select = 4'b0111; // srai
                    end
                end
            endcase
        end
        LOAD_TYPE: begin // Load Instructions
            reg_write_en = 1;
            alu_src_mux_select = 1;
            alu_select = 4'b0000;
            mem_write_en = 0;
            writeback_mux_select = 3'b000;
        end
        S_TYPE: begin // Store Instructions
            reg_write_en = 0;
            alu_src_mux_select = 1;
            alu_select = 4'b0000;
            mem_write_en = 1;
        end
        B_TYPE: begin // Branch Instructions -- pc_mux_select, alu_select, alu_src_mux_select
            alu_src_mux_select = 0;
            case (funct3)
                3'b000: begin // BEQ: Equal
                    alu_select = 4'b1010;
                    if (branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end 
                3'b001: begin // BNE: Not Equal
                    alu_select = 4'b1010;
                    if (!branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end 
                3'b100: begin // BLT: Less than (signed)
                    alu_select = 4'b1000;
                    if (branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end
                3'b101: begin // BGE: Greater Than or Equal (signed)
                    alu_select = 4'b1000;
                    if (!branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end
                3'b110: begin // BLTU: Less Than (unsigned)
                    alu_select = 4'b1001;
                    if (branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end
                3'b111: begin // BGEU: Greater Than or Equal (unsigned)
                    alu_select = 4'b1001;
                    if (!branch) begin
                        pc_mux_select = 2'b01;
                    end
                    else begin
                        pc_mux_select = 2'b00;
                    end
                end
                default: begin
                    pc_mux_select = 2'b00; alu_select = 4'b0;
                end
            endcase
        end
        J_TYPE: begin
            pc_mux_select = 2'b01;
            writeback_mux_select = 3'b010;
            reg_write_en = 1;
        end
        JALR: begin
            reg_write_en = 1;
            alu_src_mux_select = 1;
            alu_select = 4'b0000;
            pc_mux_select = 2'b10;
            writeback_mux_select = 3'b010;
        end
        LUI: begin
            writeback_mux_select = 3'b011;
            reg_write_en = 1;
        end
        AUIPC: begin
            writeback_mux_select = 3'b100;
            reg_write_en = 1;
        end
       endcase
    end

endmodule