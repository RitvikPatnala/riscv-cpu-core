module top_level (
    input logic clk,
    input logic reset
);
    // Instruction Signals
    logic [31:0] pc, pc_next, pc_add_4, branch_address, instruction; 
    logic [4:0] rs1, rs2, rd;
    logic [2:0] funct3;
    always_comb begin
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        rd = instruction[11:7];
        funct3 = instruction[14:12];
    end

    // Data Signals
    logic [31:0] alu_result, rd1, rd2, immediate, src2;
    logic [31:0] reg_write_data;
    logic [31:0] mem_load_data;
    
    // Control Signals:
    logic [3:0] alu_select;
    logic reg_write_en, mem_write_en, alu_src_mux_select, writeback_mux_select, branch, pc_mux_select;
    assign branch = alu_result[0];

    program_counter program_counter_reg (.*);

    add_4 pc_plus_4 (.*);

    add_imm pc_plus_imm (.*);

    instruction_memory instruction_memory (
        .address(pc), 
        .instruction(instruction)
    );

    control control (.*);

    alu alu (
        .alu_select (alu_select), 
        .src1 (rd1),
        .src2 (src2), 
        .alu_result (alu_result)
    );

    register_file reg_file (
        .clk (clk), 
        .a1 (rs1), 
        .a2 (rs2), 
        .a3 (rd), 
        .write_en (reg_write_en),
        .write_data (reg_write_data),
        .reset (reset),
        .rd1 (rd1),
        .rd2 (rd2)
    );

    mux alu_src_mux (
        .input_1 (rd2), 
        .input_2 (immediate), 
        .mux_select (alu_src_mux_select), 
        .mux_output (src2)
    );

    sign_extend sign_extension (
        .instruction (instruction),
        .immediate (immediate)
    );

    mux writeback_mux (
        .input_1 (mem_load_data),
        .input_2 (alu_result),
        .mux_select (writeback_mux_select),
        .mux_output (reg_write_data)
    );

    mux pc_mux (
        .input_1(pc_add_4),
        .input_2(branch_address), 
        .mux_select(pc_mux_select),
        .mux_output(pc_next)
    );

    data_memory data_memory (
        .clk (clk), 
        .mem_write_en(mem_write_en),
        .funct3(funct3),
        .store_data(rd2),
        .mem_address(alu_result),
        .load_data(mem_load_data)
    );

endmodule