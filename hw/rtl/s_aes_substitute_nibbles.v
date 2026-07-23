module substitute_nibbles(
    input [15:0] data_in,
    output [15:0] data_out
);

    wire [3:0] nibble0 = data_in[3:0];
    wire [3:0] nibble1 = data_in[7:4];
    wire [3:0] nibble2 = data_in[11:8];
    wire [3:0] nibble3 = data_in[15:12];
    
    wire [3:0] new_nibble0, new_nibble1, new_nibble2, new_nibble3;
    
    sbox sbox0 (.nibble_in(nibble0), .nibble_out(new_nibble0));
    sbox sbox1 (.nibble_in(nibble1), .nibble_out(new_nibble1));
    sbox sbox2 (.nibble_in(nibble2), .nibble_out(new_nibble2));
    sbox sbox3 (.nibble_in(nibble3), .nibble_out(new_nibble3));
    
    assign data_out = {new_nibble3, new_nibble2, new_nibble1, new_nibble0};

endmodule
