module full_instruction_testbench ();

    logic clk, reset;

    top_level dut (clk, reset);

    // Generate Clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    initial begin
        $dumpfile("sim/full_instruction.vcd");
        $dumpvars(0, full_instruction_testbench);

        reset = 1;

        #12;

        dut.reg_file.gen_regs[2].x.q = 32'hAAAAAAAA;
        dut.reg_file.gen_regs[3].x.q = 32'h11111111;

        // Instruction 0: add x1, x2, x3
        dut.instruction_memory.instruction_array[0] = 8'hB3;
        dut.instruction_memory.instruction_array[1] = 8'h00;
        dut.instruction_memory.instruction_array[2] = 8'h31;
        dut.instruction_memory.instruction_array[3] = 8'h00;

        // Instruction 4: addi x4, x1, -1
        dut.instruction_memory.instruction_array[4] = 8'h13;
        dut.instruction_memory.instruction_array[5] = 8'h82;
        dut.instruction_memory.instruction_array[6] = 8'hF0;
        dut.instruction_memory.instruction_array[7] = 8'hFF;

        // Instruction 8: sw x4, 0(x0)
        dut.instruction_memory.instruction_array[8]  = 8'h23;
        dut.instruction_memory.instruction_array[9]  = 8'h20;
        dut.instruction_memory.instruction_array[10] = 8'h40;
        dut.instruction_memory.instruction_array[11] = 8'h00;

        // Instruction 12: lw x5, 0(x0)
        dut.instruction_memory.instruction_array[12] = 8'h83;
        dut.instruction_memory.instruction_array[13] = 8'h22;
        dut.instruction_memory.instruction_array[14] = 8'h00;
        dut.instruction_memory.instruction_array[15] = 8'h00;

        // Deassert reset with clear separation from the next edge (t=20)
        #3;
        reset = 0;

        #50;

        $display("x1 = %h (expect BBBBBBBB)", dut.reg_file.gen_regs[1].x.q);
        $display("x4 = %h (expect BBBBBBBA)", dut.reg_file.gen_regs[4].x.q);
        $display("x5 = %h (expect BBBBBBBA)", dut.reg_file.gen_regs[5].x.q);
        $display("mem[0..3] = %h (expect BBBBBBBA)", dut.data_memory.data_mem_array[0]);

        $finish;
    end

endmodule

// iverilog -g2012 -o sim/full_instruction.vvp rtl/alu.sv rtl/top_level.sv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv rtl/sign_extension.sv rtl/mux.sv rtl/data_memory.sv tb/full_instruction_testbench.sv