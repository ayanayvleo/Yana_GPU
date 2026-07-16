`timescale 1ns/1ps

module simd_alu #(
    parameter int LANES = 4,
    parameter int DATA_WIDTH = 8,
    parameter int RESULT_WIDTH = 16
) (
    input  logic                         valid_in,
    input  logic                         opcode, // 0 = ADD, 1 = MULTIPLY
    input  logic [LANES*DATA_WIDTH-1:0]  vector_a,
    input  logic [LANES*DATA_WIDTH-1:0]  vector_b,
    output logic                         valid_out,
    output logic [LANES*RESULT_WIDTH-1:0] vector_result
);
    integer lane;
    logic [DATA_WIDTH-1:0] a_lane;
    logic [DATA_WIDTH-1:0] b_lane;

    always_comb begin
        vector_result = '0;
        valid_out = valid_in;

        for (lane = 0; lane < LANES; lane = lane + 1) begin
            a_lane = vector_a[lane*DATA_WIDTH +: DATA_WIDTH];
            b_lane = vector_b[lane*DATA_WIDTH +: DATA_WIDTH];

            if (opcode == 1'b0)
                vector_result[lane*RESULT_WIDTH +: RESULT_WIDTH] = a_lane + b_lane;
            else
                vector_result[lane*RESULT_WIDTH +: RESULT_WIDTH] = a_lane * b_lane;
        end
    end
endmodule
