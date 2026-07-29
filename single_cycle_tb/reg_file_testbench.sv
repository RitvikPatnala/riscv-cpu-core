module testbench_register_file ();

    logic clk, write_en, reset; 
    logic [4:0] a1, a2, a3;
    logic [31:0] write_data; 
    logic [31:0] rd1, rd2;

    register_file dut(clk, a1, a2, a3, write_en, write_data, reset, rd1, rd2);

    // Generate Clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    initial begin
        $dumpfile("sim/register_file.vcd");
        $dumpvars(0, testbench_register_file);

        reset = 1; #5; reset = 0; #5;
        
        // Case 1: x[0] --> write; x[1] --> read; x[2] --> read
        // Expected Output: All 3 registers show 0s. 
        a1 = 5'd1; a2 = 5'd2; a3 = 5'd0;
        write_en = 1;
        write_data = 32'hFFFFFFFF;
        #10;
        write_en = 0;
        #5

        // Case 2: x[0] --> read; x[1] --> write; x[2] --> read
        // Expected Output: Registers 0 and 2 show 0s, while register 1 shows all As.  
        a1 = 5'd0; a2 = 5'd2; a3 = 5'd1;
        write_en = 1;
        write_data = 32'hAAAAAAAA;
        #10;
        write_en = 0;
        #10
        
        // Case 3: x[0] --> read; x[1] --> read; x[2] --> write
        // Expected Output: x[0] shows 0s. x[1] shows As, x[2] shows Bs.  
        a1 = 5'd0; a2 = 5'd1; a3 = 5'd2;
        write_en = 1;
        write_data = 32'hBBBBBBBB;
        #10;
        write_en = 0;
        #5
        
        // Case 4: x[0] --> read; x[1] --> read; x[2] --> no write
        // Expected Output: Registers 0 and 2 show 0s, while register 1 shows all As.  
        a1 = 5'd0; a2 = 5'd1; a3 = 5'd2;
        write_data = 32'hCCCCCCCC;
        #5;

        // Case 5: x[0] --> read; x[1] --> read; x[1] --> write
        a1 = 5'd0; a2 = 5'd1; a3 = 5'd1;
        write_en = 1;
        write_data = 32'hCCCCCCCC;
        #10;
        write_en = 0;
        #5;

        reset = 1; #5; reset = 0; #5;
        $finish;

    end

endmodule