module sbox(
    input [3:0] nibble_in ,
    output reg [3:0] nibble_out
    );
    
    always @(*) begin
        case(nibble_in)
            4 'b0000: nibble_out = 4 'b1001;
            4 'b0001: nibble_out = 4 'b0100;
            4 'b0010: nibble_out = 4 'b1010;
            4 'b0011: nibble_out = 4 'b1011;
            4 'b0100: nibble_out = 4 'b1101;
            4 'b0101: nibble_out = 4 'b0001;
            4 'b0110: nibble_out = 4 'b1000;
            4 'b0111: nibble_out = 4 'b0101;
            4 'b1000: nibble_out = 4 'b0110;
            4 'b1001: nibble_out = 4 'b0010;
            4 'b1010: nibble_out = 4 'b0000;
            4 'b1011: nibble_out = 4 'b0011;
            4 'b1100: nibble_out = 4 'b1100;
            4 'b1101: nibble_out = 4 'b1110;
            4 'b1110: nibble_out = 4 'b1111;
            4 'b1111: nibble_out = 4 'b0111;
            default: nibble_out = 4 'b0000;
        endcase
    end
    
endmodule
