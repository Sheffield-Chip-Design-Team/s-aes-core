
module expand_key(
  input  wire [15:0] key_in,
  output reg  [15:0] key_out
);

wire [7:0] b0 = key_in[15:8];
wire [7:0] b1 = key_in[7:0];

wire [7:0] b2 = b0 ^ g(b1);
wire [7:0] b3 = b2 ^ b1;

assign key_out = {b2, b3};

endmodule
