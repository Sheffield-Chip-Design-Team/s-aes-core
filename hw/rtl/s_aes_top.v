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
    // NOTE: I think if you wanted to area-optimise you can combine the shift and
    // substitution steps, will validate when full tb is set up
    //
    // TODO:
    // - Do MixColumns
    // - Do KeyExpand
    
    wire [15:0] data_xor;
    assign data_xor = data_in ^ key;
    wire [15:0] rk1, rk2;

    expand_key round_key0 (.key_in(key), .key_out(rk1));
    expand_key round_key1 (.key_in(rk1), .key_out(rk2));

    // Steps:
    // 1.1. Substitute
    // 1.2. ShiftRows
    // 1.4. MixColumns
    // 1.5. xor rk1
    // 2.1  Substitute
    // 2.2  ShiftRows
    // 2.3  xor rk2
    // return
    wire [15:0] sub1;
    substitute substitute_1 (.data_in(data_xor), .data_out(sub1));
    wire [15:0] shift1;
    shift_rows shift_1 (.data_in(sub1), .data_out(shift1));
    wire [15:0] mix1;
    mix_columns mix_1 (.data_in(shift1),.data_out(mix1));
    wire [15:0] round1;
    assign round1 = mix1 ^ rk1;

    wire [15:0] sub2;
    substitute substitute_2 (.data_in(data_xor), .data_out(sub2));
    wire [15:0] shift2;
    shift_rows shift_2 (.data_in(sub2), .data_out(shift2));
    wire [15:0] round2;
    assign round2 = shift2 ^ rk2;

    always @(posedge clk) begin
        data_out = round2;
        done = 1;
    end
endmodule
