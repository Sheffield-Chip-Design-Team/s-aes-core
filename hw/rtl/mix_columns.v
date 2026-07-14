module mix_columns(
  input  wire [15:0] data_in,
  output wire [15:0] data_out
);
    function automatic [3:0] gf_mult;
        input [3:0] in;
        begin
            gf_mult = {
                in[1],
                in[0],
                in[3] ^ in[1],
                in[3] ^ in[2]
            };
        end
    endfunction

    wire [3:0] s0 = data_in[15:12];
    wire [3:0] s1 = data_in[11:8];
    wire [3:0] s2 = data_in[7:4];
    wire [3:0] s3 = data_in[3:0];
    assign data_out = {
        s0 ^ gf_mult(s1),
        gf_mult(s0) ^ s1,
        s2 ^ gf_mult(s3),
        gf_mult(s2) ^ s3
    };
endmodule
