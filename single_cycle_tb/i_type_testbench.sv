module i_type_testbench ();

    logic clk, reset;

    top_level dut(clk, reset);

    // Generate Clock
    always begin
        clk = 0; #5; clk = 1; #5;
    end

    initial begin
        $dumpfile("sim/i_type_top_level.vcd");
        $dumpvars(0, i_type_testbench);

        reset = 1; #7; reset = 0; 

        dut.reg_file.gen_regs[1].x.q = 32'hF0F0F0F0;

        // Instruction #1: addi x2, x1, 240 (0F008113)
        dut.instruction_memory.instruction_array[0] = 8'h13;
        dut.instruction_memory.instruction_array[1] = 8'h81;
        dut.instruction_memory.instruction_array[2] = 8'h00;
        dut.instruction_memory.instruction_array[3] = 8'h0F;

        // Instruction #2: andi x3, x1, 240 (0F00F193)
        dut.instruction_memory.instruction_array[4] = 8'h93;
        dut.instruction_memory.instruction_array[5] = 8'hF1;
        dut.instruction_memory.instruction_array[6] = 8'h00;
        dut.instruction_memory.instruction_array[7] = 8'h0F;

        // Instruction #3: ori x4, x1, 240 (0F00E213)
        dut.instruction_memory.instruction_array[8] = 8'h13;
        dut.instruction_memory.instruction_array[9] = 8'hE2;
        dut.instruction_memory.instruction_array[10] = 8'h00;
        dut.instruction_memory.instruction_array[11] = 8'h0F;

        // Instruction #4: xori x5, x1, 240 (0F00C293)
        dut.instruction_memory.instruction_array[12] = 8'h93;
        dut.instruction_memory.instruction_array[13] = 8'hC2;
        dut.instruction_memory.instruction_array[14] = 8'h00;
        dut.instruction_memory.instruction_array[15] = 8'h0F;

        // Instruction #5: slti x6, x1, 240 (0F00A313)
        dut.instruction_memory.instruction_array[16] = 8'h13;
        dut.instruction_memory.instruction_array[17] = 8'hA3;
        dut.instruction_memory.instruction_array[18] = 8'h00;
        dut.instruction_memory.instruction_array[19] = 8'h0F;

        // Instruction #6: sltiu x7, x1, 240 (0F00B393)
        dut.instruction_memory.instruction_array[20] = 8'h93;
        dut.instruction_memory.instruction_array[21] = 8'hB3;
        dut.instruction_memory.instruction_array[22] = 8'h00;
        dut.instruction_memory.instruction_array[23] = 8'h0F;

        // Instruction #7: slli x8, x1, 4 (00409413)
        dut.instruction_memory.instruction_array[24] = 8'h13;
        dut.instruction_memory.instruction_array[25] = 8'h94;
        dut.instruction_memory.instruction_array[26] = 8'h40;
        dut.instruction_memory.instruction_array[27] = 8'h00;

        // Instruction #8: srli x9, x1, 4 (0040D493)
        dut.instruction_memory.instruction_array[28] = 8'h93;
        dut.instruction_memory.instruction_array[29] = 8'hD4;
        dut.instruction_memory.instruction_array[30] = 8'h40;
        dut.instruction_memory.instruction_array[31] = 8'h00;

        // Instruction #9: srai x10, x1, 4 (4040D513)
        dut.instruction_memory.instruction_array[32] = 8'h13;
        dut.instruction_memory.instruction_array[33] = 8'hD5;
        dut.instruction_memory.instruction_array[34] = 8'h40;
        dut.instruction_memory.instruction_array[35] = 8'h40;


        #100;

        $finish;
    end
    
endmodule

// rtl/alu.svv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv rtl/sign_extension.sv rlt/mux.sv
// iverilog -g2012 -o sim/top_level.vvp rtl/alu.sv rtl/top_level.sv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv rtl/sign_extension.sv rtl/mux.sv tb/i_type_testbench.sv