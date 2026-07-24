module instruction_memory_testbench ();
    
logic [31:0] address, instruction;

instruction_memory dut(address, instruction);

// 2 Instructions:
    // add x1, x2, x3 = 00000000001100010000000010110011 
    // sub x4, x5, x6 = 01000000011000101000001000110011  
initial begin
    $dumpfile("sim/instruction_memory.vcd");
    $dumpvars(0, instruction_memory_testbench);
    
    // Instruction #1: add x1, x2, x3
    dut.instruction_array[0] = 8'b10110011;
    dut.instruction_array[1] = 8'b00000000;
    dut.instruction_array[2] = 8'b00110001;
    dut.instruction_array[3] = 8'b00000000;

    // Instruction #2: sub x4, x5, x6
    dut.instruction_array[4] = 8'b00110011;
    dut.instruction_array[5] = 8'b10000010;
    dut.instruction_array[6] = 8'b01100010;
    dut.instruction_array[7] = 8'b01000000;

    #5;
    address = 0;
    #10;
    address = 4;
    #10;
    address = 8;
    #5;

end

endmodule