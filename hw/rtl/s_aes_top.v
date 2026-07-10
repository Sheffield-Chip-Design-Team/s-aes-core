module s_aes_top (
    input wire a,
    input wire b,
    output wire c
);
    // xor (x) 
    assign c = a ^ b;

endmodule
