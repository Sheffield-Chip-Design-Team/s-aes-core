module s_aes_top (
    input wire clk,            // clock pulse
    input wire rst_n,          // reset when low
    input wire start,          // signal to start
    input wire encrypt,        // 1 = encrypt, 0 = decrypt
    input wire [15:0] data_in,
    input wire [15:0] key,
    output reg [15:0] data_out,
    output reg done, // high when data_out is valid
);

endmodule
