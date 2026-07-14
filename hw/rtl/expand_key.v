
module expand_key(
  input  wire [15:0] key_in,
  output wire [15:0] key_out
);

  function automatic [7:0] g;
      input [7:0] in;
      begin
      end
  endfunction
  wire [7:0] b0; 
  wire [7:0] b1; 
  wire [7:0] b2; 
  wire [7:0] b3; 

  assign b0 = key_in[15:8];
  assign b1 = key_in[7:0];

  assign b2 = b0 ^ g(b1);
  assign b3 = b2 ^ b1;

  assign key_out = {b2, b3};

endmodule
