`timescale 1ns/1ps

module vector_register_file (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        load_en,
    input  logic [2:0]  load_addr,
    input  logic [2:0]  load_byte_index,
    input  logic [7:0]  load_byte_data,
    input  logic        result_write_en,
    input  logic [2:0]  result_write_addr,
    input  logic [63:0] result_write_data,
    input  logic [2:0]  read_addr_a,
    input  logic [2:0]  read_addr_b,
    input  logic [2:0]  inspect_addr,
    output logic [63:0] read_data_a,
    output logic [63:0] read_data_b,
    output logic [63:0] inspect_data
);
    logic [63:0] registers [0:7];
    integer index;

    assign read_data_a = registers[read_addr_a];
    assign read_data_b = registers[read_addr_b];
    assign inspect_data = registers[inspect_addr];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for (index = 0; index < 8; index = index + 1)
                registers[index] <= '0;
        end else if (result_write_en) begin
            registers[result_write_addr] <= result_write_data;
        end else if (load_en) begin
            registers[load_addr][load_byte_index*8 +: 8] <= load_byte_data;
        end
    end
endmodule
