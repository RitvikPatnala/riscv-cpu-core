module data_memory (
    input logic clk, 
    input logic mem_write_en, // Controls Load or Store
    input logic [2:0] funct3,
    input logic [31:0] store_data, 
    input logic [31:0] mem_address, 
    output logic [31:0] load_data
);
    
    logic [7:0] data_mem_array [63:0];

    always_comb begin
        if (!mem_write_en) begin
            case (funct3)
                3'b000: load_data = signed'(data_mem_array[mem_address]); // Load Byte (signed)
                3'b100: load_data = unsigned'(data_mem_array[mem_address]); // Load Byte (unsigned)
                3'b001: load_data = signed'({data_mem_array[mem_address + 1], data_mem_array[mem_address]}); // Load Half Word (signed)
                3'b101: load_data = unsigned'({data_mem_array[mem_address + 1], data_mem_array[mem_address]}); // Load Half Word (unsigned)
                3'b010: load_data = {data_mem_array[mem_address + 3], data_mem_array[mem_address + 2], data_mem_array[mem_address + 1], data_mem_array[mem_address]}; // Load Word 
                default: load_data = 32'bx;
            endcase
        end
        else begin
            load_data = 32'bx;
        end
    end

    always_ff @ (posedge clk) begin
        if (mem_write_en) begin
            case (funct3)
                3'b000: data_mem_array[mem_address] <= store_data[7:0]; // Store Byte
                3'b001: begin // Store Half Word
                    data_mem_array[mem_address] <= store_data[7:0];
                    data_mem_array[mem_address + 1] <= store_data[15:8];
                end
                3'b010: begin // Store Word
                    data_mem_array[mem_address] <= store_data[7:0];
                    data_mem_array[mem_address + 1] <= store_data[15:8];
                    data_mem_array[mem_address + 2] <= store_data[23:16];
                    data_mem_array[mem_address + 3] <= store_data[31:24];
                end
            endcase
        end
    end

endmodule