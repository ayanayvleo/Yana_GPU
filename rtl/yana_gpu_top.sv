`timescale 1ns/1ps

module yana_gpu_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        load_en,
    input  logic [2:0]  load_addr,
    input  logic [2:0]  load_byte_index,
    input  logic [7:0]  load_byte_data,
    input  logic        execute,
    input  logic        opcode,
    input  logic [2:0]  src_addr_a,
    input  logic [2:0]  src_addr_b,
    input  logic [2:0]  dst_addr,
    input  logic [2:0]  inspect_addr,
    input  logic [1:0]  inspect_lane,
    output logic [15:0] inspect_result,
    output logic        done
);
    logic [63:0] register_a;
    logic [63:0] register_b;
    logic [63:0] inspect_data;
    logic [63:0] alu_result;
    logic        alu_valid;

    vector_register_file register_file (
        .clk(clk), .rst_n(rst_n),
        .load_en(load_en), .load_addr(load_addr),
        .load_byte_index(load_byte_index), .load_byte_data(load_byte_data),
        .result_write_en(execute), .result_write_addr(dst_addr),
        .result_write_data(alu_result),
        .read_addr_a(src_addr_a), .read_addr_b(src_addr_b),
        .inspect_addr(inspect_addr),
        .read_data_a(register_a), .read_data_b(register_b),
        .inspect_data(inspect_data)
    );

    simd_alu #(.LANES(4), .DATA_WIDTH(8), .RESULT_WIDTH(16)) compute_engine (
        .valid_in(execute), .opcode(opcode),
        .vector_a(register_a[31:0]), .vector_b(register_b[31:0]),
        .valid_out(alu_valid), .vector_result(alu_result)
    );

    assign inspect_result = inspect_data[inspect_lane*16 +: 16];

    always_ff @(posedge clk) begin
        if (!rst_n)
            done <= 1'b0;
        else
            done <= alu_valid;
    end
endmodule
