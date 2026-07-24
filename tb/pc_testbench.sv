module pc_testbench (
);
    
logic clk, reset;
logic [31:0] pc_next, pc;

program_counter dut1 (clk, pc_next, reset, pc);
add_4 dut2 (pc, pc_next);

// Generate Clock
always begin
    clk = 1; #5; clk = 0; #5;
end

initial begin
    $dumpfile("sim/pc.vcd");
    $dumpvars(0, pc_testbench);

    reset = 0;
    #45
    reset = 1;
    #5;
    reset = 0;
    #50;
    $finish;
end

endmodule