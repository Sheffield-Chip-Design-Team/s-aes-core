`timescale 1ns/1ps

module s_aes_top_tb;

    reg  [15:0] plaintext;
    reg  [15:0] key;
    wire [15:0] ciphertext;

    // Instantiate Unit Under Test (UUT)
    saes_cipher dut (
        .in_data(plaintext),
        .key(key),
        .out_data(ciphertext)
    );

    // Task to run a single 16-bit test vector
    task run_vector;
        input [15:0] pt;
        input [15:0] k;
        begin
            plaintext = pt;
            key = k;
            #10; // Wait for combinational logic propagation
            $display("PT=%h KEY=%h CT=%h TIME=%0t", pt, k, ciphertext, $time);
        end
    endtask

    initial begin
        // Setup GTKWave / waveform dump
        $dumpfile("saes_tb.vcd");
        $dumpvars(0, saes_tb);

        // Standard S-AES Test Vectors
        run_vector(16'h6F6B, 16'hA3B5); // Expected CT: 0738
        run_vector(16'h0000, 16'h0000);
        run_vector(16'hFFFF, 16'hFFFF);

        #10;
        $finish;
    end

endmodule
