module s_aes_top (
    input  wire [15:0] in_data,
    input  wire [15:0] key,
    output wire [15:0] out_data
);
    
    // S-Box Substitution Table
    function [3:0] sbox(input [3:0] nib);
        case (nib)
            4'h0: sbox = 4'h9; 4'h1: sbox = 4'h4; 4'h2: sbox = 4'hA; 4'h3: sbox = 4'hB;
            4'h4: sbox = 4'hD; 4'h5: sbox = 4'h1; 4'h6: sbox = 4'h8; 4'h7: sbox = 4'hE;
            4'h8: sbox = 4'h6; 4'h9: sbox = 4'h7; 4'hA: sbox = 4'h3; 4'hB: sbox = 4'h0;
            4'hC: sbox = 4'hF; 4'hD: sbox = 4'hC; 4'hE: sbox = 4'h2; 4'hF: sbox = 4'h5;
        endcase
    endfunction

    // Galois Field GF(2^4) Multiplication by 2 (Irreducible Poly: x^4 + x + 1)
    function [3:0] gf_mult_2(input [3:0] nib);
        gf_mult_2 = (nib[3] == 1'b1) ? ((nib << 1) ^ 4'h3) : (nib << 1);
    endfunction

    // Galois Field GF(2^4) Multiplication by 4
    function [3:0] gf_mult_4(input [3:0] nib);
        gf_mult_4 = gf_mult_2(gf_mult_2(nib));
    endfunction

    // Key Expansion (K0, K1, K2)

    wire [7:0] w0 = key[15:8];
    wire [7:0] w1 = key[7:0];
    
    wire [7:0] w2 = w0 ^ 8'h80 ^ {sbox(w1[3:0]), sbox(w1[7:4])};
    wire [7:0] w3 = w2 ^ w1;
    wire [7:0] w4 = w2 ^ 8'h30 ^ {sbox(w3[3:0]), sbox(w3[7:4])};
    wire [7:0] w5 = w4 ^ w3;

    wire [15:0] k0 = {w0, w1};
    wire [15:0] k1 = {w2, w3};
    wire [15:0] k2 = {w4, w5};

    // Encryption Pipeline
    
    // Initial Round: AddRoundKey (K0)
    wire [15:0] state_r0 = in_data ^ k0;

    // Round 1: SubNibbles -> ShiftRows -> MixColumns -> AddRoundKey (K1)
    wire [3:0] r1_sub0 = sbox(state_r0[15:12]);
    wire [3:0] r1_sub1 = sbox(state_r0[11:8]);
    wire [3:0] r1_sub2 = sbox(state_r0[7:4]);
    wire [3:0] r1_sub3 = sbox(state_r0[3:0]);

    // ShiftRows (Swaps Nibble 1 and Nibble 3)
    wire [3:0] r1_sr0 = r1_sub0;
    wire [3:0] r1_sr1 = r1_sub3;
    wire [3:0] r1_sr2 = r1_sub2;
    wire [3:0] r1_sr3 = r1_sub1;

    // MixColumns
    wire [3:0] r1_mc0 = r1_sr0 ^ gf_mult_4(r1_sr1);
    wire [3:0] r1_mc1 = gf_mult_4(r1_sr0) ^ r1_sr1;
    wire [3:0] r1_mc2 = r1_sr2 ^ gf_mult_4(r1_sr3);
    wire [3:0] r1_mc3 = gf_mult_4(r1_sr2) ^ r1_sr3;

    wire [15:0] state_r1 = {r1_mc0, r1_mc1, r1_mc2, r1_mc3} ^ k1;

    // Round 2 (Final): SubNibbles -> ShiftRows -> AddRoundKey (K2)
    wire [3:0] r2_sub0 = sbox(state_r1[15:12]);
    wire [3:0] r2_sub1 = sbox(state_r1[11:8]);
    wire [3:0] r2_sub2 = sbox(state_r1[7:4]);
    wire [3:0] r2_sub3 = sbox(state_r1[3:0]);

    wire [3:0] r2_sr0 = r2_sub0;
    wire [3:0] r2_sr1 = r2_sub3;
    wire [3:0] r2_sr2 = r2_sub2;
    wire [3:0] r2_sr3 = r2_sub1;

    assign out_data = {r2_sr0, r2_sr1, r2_sr2, r2_sr3} ^ k2;

endmodule
