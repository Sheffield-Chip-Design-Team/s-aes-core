module expand_key(
  input  wire [15:0] key_in,
  input  wire        round, // low for round 1, high for round 2
  output wire [15:0] key_out
);

  wire [7:0] b0;
  wire [7:0] b1;
  wire [7:0] b2;
  wire [7:0] b3;

  assign b0 = key_in[15:8];
  assign b1 = key_in[7:0];

  // RotWord
  wire [3:0] rot0 = b1[3:0];
  wire [3:0] rot1 = b1[7:4];

  // SubWord, uses normal S-Box
  wire [3:0] sub0, sub1;
  substitute s0 (.data_in(rot0), .data_out(sub0)); // don't need to include substitute.v because it's included in the top module
  substitute s1 (.data_in(rot1), .data_out(sub1));

  // Round constant
  wire [3:0] rcon = round ? 4'b1000 : 4'b0011;
  wire [7:0] g_out = {sub0 ^ rcon, sub1};

  assign b2 = b0 ^ g_out;
  assign b3 = b2 ^ b1;

  assign key_out = {b2, b3};

endmodule
