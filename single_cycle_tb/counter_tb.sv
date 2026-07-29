`timescale 1ns/1ps

module counter_tb;
    logic clk;
    logic rst;
    logic [3:0] count;

    // Instantiate the module under test
    counter dut (
        .clk(clk),
        .rst(rst),
        .count(count)
    );

    // Clock generation: toggle every 5ns -> 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Waveform dump setup for Surfer/GTKWave-style viewers
        $dumpfile("sim/counter.vcd");
        $dumpvars(0, counter_tb);

        // Test sequence
        rst = 1;
        @(posedge clk);
        @(posedge clk);
        rst = 0;

        repeat (20) @(posedge clk);

        $display("Final count value: %0d", count);
        $finish;
    end
endmodule