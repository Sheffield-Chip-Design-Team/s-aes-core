module s_aes_top (
    input wire a,
    input wire b,
    output wire c
);
    // simple xor 
    assign c = a ^ b;

endmodule
