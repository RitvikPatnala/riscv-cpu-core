module register_file (
    input logic clk, 
    input logic [4:0] a1, a2, a3, 
    input logic write_en, 
    input logic [31:0] write_data, 
    input logic reset,
    output logic [31:0] rd1, rd2
);
    logic [31:0] q [31:0];
    logic [31:0] d [31:0];

    generate
        for (genvar i = 0; i <= 31; i++) begin : gen_regs
            register x (
                .d (d[i]), 
                .clk (clk),
                .reset (reset), 
                .q (q[i])
            );
        end
    endgenerate

    always_comb begin
        rd1 = q[a1];
        rd2 = q[a2];

        d[0] = 32'b0;

        for (int i = 1; i <= 31; i++) begin
            if (write_en && i == a3) begin
                d[i] = write_data;
            end
            else begin
                d[i] = q[i];
            end
        end
    end
        
endmodule