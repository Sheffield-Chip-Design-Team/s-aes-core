module substitute (
    input  wire [3:0] nibble_in,
    output reg  [3:0] nibble_out
);
    always @(*) begin
        case (nibble_in)
            4'h0: nibble_out = 4'h9;
            4'h1: nibble_out = 4'h4;
            4'h2: nibble_out = 4'hA;
            4'h3: nibble_out = 4'hB;
            4'h4: nibble_out = 4'hD;
            4'h5: nibble_out = 4'h1;
            4'h6: nibble_out = 4'h8;
            4'h7: nibble_out = 4'h5;
            4'h8: nibble_out = 4'h6;
            4'h9: nibble_out = 4'h2;
            4'hA: nibble_out = 4'h0;
            4'hB: nibble_out = 4'h3;
            4'hC: nibble_out = 4'hC;
            4'hD: nibble_out = 4'hE;
            4'hE: nibble_out = 4'hF;
            4'hF: nibble_out = 4'h7;
            default: nibble_out = 4'h0;
        endcase
    end
endmodule
