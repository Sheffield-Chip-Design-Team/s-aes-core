module s_aes_top (
    input wire a,
    input wire b,
    output wire c
);
    // Ralph
    assign c = a ^ b;

endmodule
