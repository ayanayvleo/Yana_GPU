`timescale 1ns/1ps

module tb_yana_gpu_top;
    logic clk = 0;
    logic rst_n, load_en, execute, opcode, done;
    logic [2:0] load_addr, load_byte_index;
    logic [7:0] load_byte_data;
    logic [2:0] src_addr_a, src_addr_b, dst_addr, inspect_addr;
    logic [1:0] inspect_lane;
    logic [15:0] inspect_result;

    yana_gpu_top dut (.*);
    always #5 clk = ~clk;

    task automatic load_vector(input logic [2:0] address,
                               input logic [31:0] data);
        integer byte_number;
        begin
            for (byte_number = 0; byte_number < 4; byte_number = byte_number + 1) begin
                @(negedge clk);
                load_en = 1'b1;
                load_addr = address;
                load_byte_index = byte_number;
                load_byte_data = data[byte_number*8 +: 8];
            end
            @(negedge clk);
            load_en = 1'b0;
        end
    endtask

    task automatic execute_and_check(
        input logic operation,
        input logic [2:0] destination,
        input logic [63:0] expected,
        input string name
    );
        integer lane;
        begin
            @(negedge clk);
            opcode = operation;
            dst_addr = destination;
            execute = 1'b1;
            @(negedge clk);
            execute = 1'b0;
            inspect_addr = destination;

            for (lane = 0; lane < 4; lane = lane + 1) begin
                inspect_lane = lane;
                #1;
                if (inspect_result !== expected[lane*16 +: 16]) begin
                    $error("%s lane %0d FAILED", name, lane);
                    $fatal;
                end
            end
            $display("PASS: %s stored in vector register %0d", name, destination);
        end
    endtask

    initial begin
        rst_n = 0; load_en = 0; execute = 0; opcode = 0;
        load_addr = 0; load_byte_index = 0; load_byte_data = 0;
        src_addr_a = 1; src_addr_b = 2; dst_addr = 0;
        inspect_addr = 0; inspect_lane = 0;

        repeat (2) @(negedge clk);
        rst_n = 1;

        load_vector(3'd1, {8'd4,8'd3,8'd2,8'd1});
        load_vector(3'd2, {8'd8,8'd7,8'd6,8'd5});

        execute_and_check(1'b0, 3'd3, {16'd12,16'd10,16'd8,16'd6}, "register ADD");
        execute_and_check(1'b1, 3'd4, {16'd32,16'd21,16'd12,16'd5}, "register MULTIPLY");

        $display("YanaGPU milestone 2 passed: register file + compact I/O!");
        $finish;
    end
endmodule
