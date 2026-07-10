`include "hw/rtl/substitute.v"

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

    // first AddRoundKey just uses plain key
    wire [15:0] data_xor;
    assign data_xor = data_in ^ key;


    wire [15:0] sub_result; // result of the first s-box
    // by doing it nibble by nibble they each get their own line in the
    // waveform
    substitute sbox0 (.nibble_in(data_xor[15:12]), .nibble_out(sub_result[15:12]));
    substitute sbox1 (.nibble_in(data_xor[11: 8]), .nibble_out(sub_result[11: 8]));
    substitute sbox2 (.nibble_in(data_xor[ 7: 4]), .nibble_out(sub_result[ 7: 4]));
    substitute sbox3 (.nibble_in(data_xor[ 3: 0]), .nibble_out(sub_result[ 3: 0]));

endmodule
