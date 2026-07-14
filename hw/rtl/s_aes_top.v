`include "hw/rtl/substitute.v"
`include "hw/rtl/shift_rows.v"
`include "hw/rtl/mix_columns.v"
`include "hw/rtl/expand_key.v"

module s_aes_top (
    input wire clk,            // clock pulse
    input wire rst_n,          // reset when low
    input wire start,          // signal to start
    input wire [15:0] plaintext,
    input wire [15:0] key,
    output reg [15:0] ciphertext,
    output reg done // high when data_out is valid
);
    // TODO: all that's left is the poorly documented g function in expand_key
    wire [15:0] data_xor;
    wire [15:0] rk1, rk2;
    assign data_xor = plaintext ^ key;

    expand_key round_key0 (.key_in(key), .key_out(rk1));
    expand_key round_key1 (.key_in(rk1), .key_out(rk2));

    wire [15:0] sub1;
    wire [15:0] shift1;
    wire [15:0] mix1;
    wire [15:0] round1;
    substitute  substitute_1 (.data_in(data_xor), .data_out(sub1));
    shift_rows  shift_1      (.data_in(sub1),     .data_out(shift1));
    mix_columns mix_1        (.data_in(shift1),   .data_out(mix1));
    assign round1 = mix1 ^ rk1;

    wire [15:0] sub2;
    wire [15:0] shift2;
    wire [15:0] round2;
    substitute substitute_2 (.data_in(round1), .data_out(sub2));
    shift_rows shift_2      (.data_in(sub2),   .data_out(shift2));
    assign round2 = shift2 ^ rk2;

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ciphertext <= 16'h0000;
        done <= 1'b0;
    end else if (start) begin
        ciphertext <= round2;
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
    end
endmodule
