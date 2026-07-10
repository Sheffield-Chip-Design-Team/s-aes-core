module s_aes_top (
    input wire a,
    input wire b,
    output wire c
);
    // simple xor i love singapore
    assign c = a ^ b;

endmodule
