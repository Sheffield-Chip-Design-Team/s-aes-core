module counter (

    input [15:0] data_in,
    input [15:0] key_in,
    output [15:0] data_out
);
    assign data_out = data_in ^ key_in;
    
endmodule
