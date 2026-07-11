`include "hw/rtl/substitute.v"
`include "hw/rtl/shift_rows.v"
`include "hw/rtl/mix_columns.v"

module s_aes_top (
    input wire clk,            // clock pulse
    input wire rst_n,          // reset when low
    input wire start,          // signal to start
    input wire encrypt,        // 1 = encrypt, 0 = decrypt
    input wire [15:0] data_in,
    input wire [15:0] key,
    output reg [15:0] data_out,
    output reg done // high when data_out is valid
);
    // NOTE: I think if you wanted to area-optimise you can combine the shift and
    // substitution steps, will validate when full tb is set up
    
    // get the two extra round keys

    // first AddRoundKey just uses plain key
    wire [15:0] data_xor;
    assign data_xor = data_in ^ key;
    wire [15:0] rk1, rk2;
    expand_key (.key_in(key), .rk1(rk1), .rk2(rk2));


    wire [15:0] sub0_result; // result of the first s-box
    // by doing it nibble by nibble they each get their own line in the
    // waveform, useful for validation & tb
    substitute sbox00 (.nibble_in(data_xor[15:12]), .nibble_out(sub0_result[15:12]));
    substitute sbox01 (.nibble_in(data_xor[11: 8]), .nibble_out(sub0_result[11: 8]));
    substitute sbox02 (.nibble_in(data_xor[ 7: 4]), .nibble_out(sub0_result[ 7: 4]));
    substitute sbox03 (.nibble_in(data_xor[ 3: 0]), .nibble_out(sub0_result[ 3: 0]));
    

    // shift rows (swap last two nibbles of each byte)
    wire [15:0] shift0_result;
    shift_rows shift0 (.data_in(sub0_result), .data_out(shift0_result));

    wire [15:0] mix_columns0_result;
    mix_columns mix0 (.data_in(shift0_result), .data_out(mix_columns0_result));

    wire [15:0] round1_result;
    assign round1_result = mix_columns0_result ^ rk1;


    // round 2
    wire [15:0] sub1_result;
    substitute sbox10 (.nibble_in(data_xor[15:12]), .nibble_out(sub1_result[15:12]));
    substitute sbox11 (.nibble_in(data_xor[11: 8]), .nibble_out(sub1_result[11: 8]));
    substitute sbox12 (.nibble_in(data_xor[ 7: 4]), .nibble_out(sub1_result[ 7: 4]));
    substitute sbox13 (.nibble_in(data_xor[ 3: 0]), .nibble_out(sub1_result[ 3: 0]));

    wire [15:0] shift1_result;
    shift_rows shift1 (.data_in(sub1_result), .data_out(shift1_result));
    wire [15:0] round2_result;
    assign round2_result = shift1_result ^ rk2;


    always @(posedge clk) begin
        data_out = round2_result;
        done = 1;
    end



endmodule
