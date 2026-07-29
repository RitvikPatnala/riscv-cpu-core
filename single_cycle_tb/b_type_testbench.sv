module b_type_testbench ();
    

    logic clk, reset;
    top_level dut (clk, reset);

    localparam bit [31:0] beq = 32'h00208863; // beq x1, x2, 16
    localparam bit [31:0] bne = 32'h00209863; // bne x1, x2, 16

    localparam bit [31:0] blt = 32'h0041C863; // blt x3, x4, 16
    localparam bit [31:0] bge = 32'h0041D863; // bge x3, x4, 16
    localparam bit [31:0] bltu = 32'h0041E863; // bltu x3, x4, 16
    localparam bit [31:0] bgeu = 32'h0041F863; // bgeu x3, x4, 16

    // Generate Clock
    always begin
        clk = 1; #5; clk = 0; #5;
    end

    // Loads a 32-bit instruction into instruction memory, little-endian
    task automatic load_instr(input int addr, input logic [31:0] instr);
        begin
            dut.instruction_memory.instruction_array[addr]   = instr[7:0];
            dut.instruction_memory.instruction_array[addr+1] = instr[15:8];
            dut.instruction_memory.instruction_array[addr+2] = instr[23:16];
            dut.instruction_memory.instruction_array[addr+3] = instr[31:24];
        end
    endtask

    initial begin
        $dumpfile("sim/b_type_testbench.vcd");
        $dumpvars(0, b_type_testbench);

        // ---------- Case 1: BEQ x1, x2, 16 ---------- pc_next = 16
        reset = 1;
        #12;
        dut.reg_file.gen_regs[1].x.q = 32'd5;
        dut.reg_file.gen_regs[2].x.q = 32'd5;
        load_instr(0, beq);
        #3; reset = 0;
        #10;
        $display("Case 1 BEQ  (expect pc_next=16): pc_next=%0d", dut.pc_next);
        
        // ---------- Case 2: BNE x1, x2, 16 ---------- pc_next = 4
        reset = 1;
        #12;
        dut.reg_file.gen_regs[1].x.q = 32'd5;
        dut.reg_file.gen_regs[2].x.q = 32'd5;
        load_instr(0, bne);
        #3; reset = 0;
        #10;
        $display("Case 2 BNE  (expect pc_next=4):  pc_next=%0d", dut.pc_next);

        // ---------- Case 3: BLT x3, x4, 16 ---------- pc_next = 16
        reset = 1;
        #12;
        dut.reg_file.gen_regs[3].x.q = 32'hFFFFFFFF;
        dut.reg_file.gen_regs[4].x.q = 32'd1;
        load_instr(0, blt);
        #3; reset = 0;
        #10;
        $display("Case 3 BLT  (expect pc_next=16): pc_next=%0d", dut.pc_next);

        // ---------- Case 4: BGE x3, x4, 16 ---------- pc_next = 4
        reset = 1;
        #12;
        dut.reg_file.gen_regs[3].x.q = 32'hFFFFFFFF;
        dut.reg_file.gen_regs[4].x.q = 32'd1;
        load_instr(0, bge);
        #3; reset = 0;
        #10;
        $display("Case 4 BGE  (expect pc_next=4):  pc_next=%0d", dut.pc_next);

        // ---------- Case 5: BLTU x3, x4, 16 ---------- pc_next = 4
        reset = 1;
        #12;
        dut.reg_file.gen_regs[3].x.q = 32'hFFFFFFFF;
        dut.reg_file.gen_regs[4].x.q = 32'd1;
        load_instr(0, bltu);
        #3; reset = 0;
        #10;
        $display("Case 5 BLTU  (expect pc_next=4):  pc_next=%0d", dut.pc_next);

        // ---------- Case 6: BGEU x3, x4, 16 ---------- pc_next = 16
        reset = 1;
        #12;
        dut.reg_file.gen_regs[3].x.q = 32'hFFFFFFFF;
        dut.reg_file.gen_regs[4].x.q = 32'd1;
        load_instr(0, bgeu);
        #3; reset = 0;
        #10;
        $display("Case 6 BGEU  (expect pc_next=16):  pc_next=%0d", dut.pc_next);

        $finish;

    end

endmodule

//iverilog -g2012 -o sim/b_type_testbench.vvp rtl/alu.sv rtl/top_level.sv rtl/control.sv rtl/instruction_memory.sv rtl/pc.sv rtl/register_file.sv rtl/register.sv rtl/sign_extension.sv rtl/mux.sv rtl/data_memory.sv tb/b_type_testbench.sv