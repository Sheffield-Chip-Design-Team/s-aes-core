module s_aes_top (
    input wire a,
    input wire b,
    output wire c
);
    // anchor test module 
    assign c = a ^ b;

endmodule
