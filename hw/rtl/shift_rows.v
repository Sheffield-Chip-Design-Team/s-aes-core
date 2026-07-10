module shift_rows (
  input  wire [15:0] data_in,
  output wire [15:0] data_out
);
    assign data_out[15:12] = data_in[15:12];
    assign data_out[11: 8] = data_in[ 3: 0];
    assign data_out[ 7: 4] = data_in[ 7: 4];
    assign data_out[ 3: 0] = data_in[11: 8];
endmodule
