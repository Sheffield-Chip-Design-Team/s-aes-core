`timescale 1ns/1ps
`include "hw/rtl/s_aes_top.v"

module s_aes_top_tb;

	reg         clk;
	reg         rst_n;
	reg         start;
	reg  [15:0] plaintext;
	reg  [15:0] key;
	wire [15:0] ciphertext;
	wire        done;

	s_aes_top dut (
		.clk(clk),
		.rst_n(rst_n),
		.start(start),
		.plaintext(plaintext),
		.key(key),
		.ciphertext(ciphertext),
		.done(done)
	);

	initial clk = 1'b0;
	always #5 clk = ~clk;

	task reset_dut;
		begin
			rst_n = 1'b0;
			start = 1'b0;
			plaintext = 16'h0;
			key = 16'h0;
			repeat (4) @(posedge clk);
			rst_n = 1'b1;
			@(posedge clk);
		end
	endtask

	task run_vector;
		input [15:0] pt;
		input [15:0] k;
		begin
			plaintext = pt;
			key = k;
			@(posedge clk);
			start = 1'b1;
			@(posedge clk);
			start = 1'b0;
			wait (done === 1'b1);
			@(posedge clk);
			$display("PT=%h KEY=%h CT=%h TIME=%0t", pt, k, ciphertext, $time);
		end
	endtask

	initial begin
		$dumpfile("s_aes_top_tb.vcd");
		$dumpvars(0, s_aes_top_tb);

		reset_dut();

		run_vector(16'h0000000000000000,
					    	16'h0000000000000000);

		repeat (10) @(posedge clk);
		$finish;
	end

endmodule
