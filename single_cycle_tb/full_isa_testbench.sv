module full_isa_testbench ();

    logic clk, reset;

    top_level dut (clk, reset);

    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // ---- Encoder functions, one per instruction format ----

    function automatic logic [31:0] make_rtype(
        input logic [6:0] funct7, input logic [4:0] rs2, input logic [4:0] rs1,
        input logic [2:0] funct3, input logic [4:0] rd, input logic [6:0] opcode);
        make_rtype = {funct7, rs2, rs1, funct3, rd, opcode};
    endfunction

    function automatic logic [31:0] make_itype(
        input logic [11:0] imm, input logic [4:0] rs1,
        input logic [2:0] funct3, input logic [4:0] rd, input logic [6:0] opcode);
        make_itype = {imm, rs1, funct3, rd, opcode};
    endfunction

    function automatic logic [31:0] make_stype(
        input logic [11:0] imm, input logic [4:0] rs2, input logic [4:0] rs1,
        input logic [2:0] funct3, input logic [6:0] opcode);
        make_stype = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
    endfunction

    function automatic logic [31:0] make_btype(
        input logic signed [12:0] imm, input logic [4:0] rs2, input logic [4:0] rs1,
        input logic [2:0] funct3, input logic [6:0] opcode);
        make_btype = {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
    endfunction

    function automatic logic [31:0] make_utype(
        input logic [19:0] imm, input logic [4:0] rd, input logic [6:0] opcode);
        make_utype = {imm, rd, opcode};
    endfunction

    function automatic logic [31:0] make_jtype(
        input logic signed [20:0] imm, input logic [4:0] rd, input logic [6:0] opcode);
        make_jtype = {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode};
    endfunction

    task automatic load_instr(input int addr, input logic [31:0] instr);
        begin
            dut.instruction_memory.instruction_array[addr]   = instr[7:0];
            dut.instruction_memory.instruction_array[addr+1] = instr[15:8];
            dut.instruction_memory.instruction_array[addr+2] = instr[23:16];
            dut.instruction_memory.instruction_array[addr+3] = instr[31:24];
        end
    endtask

    initial begin
        $dumpfile("sim/full_isa.vcd");
        $dumpvars(0, full_isa_testbench);

        reset = 1;
        #12;

        load_instr(0,  make_utype(20'h10000, 5'd1, 7'b0110111));               // lui x1, 0x10000
        load_instr(4,  make_itype(12'h555, 5'd1, 3'b000, 5'd2, 7'b0010011));    // addi x2, x1, 0x555
        load_instr(8,  make_rtype(7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011)); // add x3, x1, x2
        load_instr(12, make_rtype(7'b0100000, 5'd2, 5'd3, 3'b000, 5'd4, 7'b0110011)); // sub x4, x3, x2
        load_instr(16, make_stype(12'd0, 5'd4, 5'd0, 3'b010, 7'b0100011));      // sw x4, 0(x0)
        load_instr(20, make_itype(12'd0, 5'd0, 3'b010, 5'd5, 7'b0000011));      // lw x5, 0(x0)
        load_instr(24, make_btype(13'sd8, 5'd5, 5'd4, 3'b000, 7'b1100011));     // beq x4, x5, 8 (taken)
        load_instr(28, make_itype(12'd999, 5'd0, 3'b000, 5'd6, 7'b0010011));    // addi x6, x0, 999 (SKIPPED)
        load_instr(32, make_jtype(21'sd8, 5'd7, 7'b1101111));                   // jal x7, 8
        load_instr(36, make_itype(12'd111, 5'd0, 3'b000, 5'd8, 7'b0010011));    // addi x8, x0, 111 (SKIPPED)
        load_instr(40, make_utype(20'd0, 5'd9, 7'b0010111));                    // auipc x9, 0
        load_instr(44, make_itype(12'd8, 5'd9, 3'b000, 5'd10, 7'b1100111));     // jalr x10, 8(x9)
        load_instr(48, make_itype(12'd123, 5'd0, 3'b000, 5'd11, 7'b0010011));   // addi x11, x0, 123
        load_instr(52, make_btype(13'sd8, 5'd0, 5'd11, 3'b000, 7'b1100011));    // beq x11, x0, 8 (NOT taken)
        load_instr(56, make_itype(12'd456, 5'd0, 3'b000, 5'd12, 7'b0010011));   // addi x12, x0, 456

        #3;
        reset = 0;

        #170;  // generous margin past all 15 instructions

        $display("x1  = %h (expect 10000000)", dut.reg_file.gen_regs[1].x.q);
        $display("x2  = %h (expect 10000555)", dut.reg_file.gen_regs[2].x.q);
        $display("x3  = %h (expect 20000555)", dut.reg_file.gen_regs[3].x.q);
        $display("x4  = %h (expect 10000000)", dut.reg_file.gen_regs[4].x.q);
        $display("x5  = %h (expect 10000000)", dut.reg_file.gen_regs[5].x.q);
        $display("x6  = %h (expect 00000000, skipped by taken beq)", dut.reg_file.gen_regs[6].x.q);
        $display("x7  = %h (expect 00000024, jal return addr)", dut.reg_file.gen_regs[7].x.q);
        $display("x8  = %h (expect 00000000, skipped by jal)", dut.reg_file.gen_regs[8].x.q);
        $display("x9  = %h (expect 00000028, auipc)", dut.reg_file.gen_regs[9].x.q);
        $display("x10 = %h (expect 00000030, jalr return addr)", dut.reg_file.gen_regs[10].x.q);
        $display("x11 = %h (expect 0000007b, confirms jalr landed correctly)", dut.reg_file.gen_regs[11].x.q);
        $display("x12 = %h (expect 000001c8, confirms not-taken beq fell through)", dut.reg_file.gen_regs[12].x.q);

        $finish;
    end

endmodule

// iverilog -g2012 -o sim/full_isa_instruction.vvp rtl/alu.sv rtl/clear_lsb.sv rtl/top_level.sv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv rtl/sign_extension.sv rtl/mux.sv rtl/data_memory.sv tb/full_isa_testbench.sv