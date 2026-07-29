module r_type_testbench ();
    
    logic clk, reset;

    top_level dut (clk, reset);

    // Generate Clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    initial begin
        $dumpfile("sim/r_type_top_level.vcd");
        $dumpvars(0, r_type_testbench);

        reset = 1; #11; reset = 0; 

        dut.reg_file.gen_regs[2].x.q = 32'hAAAAAAAA;
        dut.reg_file.gen_regs[3].x.q = 32'h11111111;

        dut.reg_file.gen_regs[5].x.q = 32'hFFFFFFFF;
        dut.reg_file.gen_regs[6].x.q = 32'h22222222;
        
        // Instruction #1: add x1, x2, x3
        dut.instruction_memory.instruction_array[0] = 8'b10110011;
        dut.instruction_memory.instruction_array[1] = 8'b00000000;
        dut.instruction_memory.instruction_array[2] = 8'b00110001;
        dut.instruction_memory.instruction_array[3] = 8'b00000000;

        // Instruction #2: sub x4, x5, x6
        dut.instruction_memory.instruction_array[4] = 8'b00110011;
        dut.instruction_memory.instruction_array[5] = 8'b10000010;
        dut.instruction_memory.instruction_array[6] = 8'b01100010;
        dut.instruction_memory.instruction_array[7] = 8'b01000000; 

        #36;
        reset = 1; #5; reset = 0; #15
        $finish;
    end

endmodule

// rtl/alu.svv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv