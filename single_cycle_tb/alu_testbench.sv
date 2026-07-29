module alu_testbench ();
    
    logic [3:0] alu_select; 
    logic [31:0] src1, src2; 
    logic [31:0] alu_result;

    alu dut (alu_select, src1, src2, alu_result);

    initial begin
        $dumpfile("sim/alu.vcd");
        $dumpvars(0, alu_testbench);
        
        src1 = 32'hFFFFFFFF;
        src2 = 32'h00000001;
        #5;
        alu_select = 4'b0000;
        #5; 
        alu_select = 4'b0001;
        #5;
        alu_select = 4'b0010;
        #5;
        alu_select = 4'b0011;
        #5;
        alu_select = 4'b0100;
        #5;
        alu_select = 4'b0101;
        #5;
        alu_select = 4'b0110;
        #5;
        alu_select = 4'b0111;
        #5;
        alu_select = 4'b1000;
        #5;
        alu_select = 4'b1001;
        #5;
        $finish;
    end

endmodule