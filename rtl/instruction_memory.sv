module instruction_memory (
    input logic [31:0] address, 
    output logic [31:0] instruction
);
    logic [7:0] instruction_array [63:0];
    
    initial begin
        for (int i = 0; i <= 63; i++) begin
            instruction_array[i] = 8'b0;
        end
    end
    

    assign instruction[7:0] = instruction_array[address];
    assign instruction[15:8] = instruction_array[address + 1];
    assign instruction[23:16] = instruction_array[address + 2];
    assign instruction[31:24] = instruction_array[address + 3];

endmodule   