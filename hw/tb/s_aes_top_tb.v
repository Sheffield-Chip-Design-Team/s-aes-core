`timescale 1ns/1ps

module s_aes_top_tb;

	reg         clk;
	reg         rst_n;
	reg         start;
	reg  [127:0] plaintext;
	reg  [127:0] key;
	wire [127:0] ciphertext;
	wire         done;

	s_aes_otop dut (
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
			plaintext = 128'h0;
			key = 128'h0;
			repeat (4) @(posedge clk);
			rst_n = 1'b1;
			@(posedge clk);
		end
	endtask

	task run_vector;
		input [127:0] pt;
		input [127:0] k;
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

		run_vector(128'h00000000000000000000000000000000,
							 128'h00000000000000000000000000000000);

		run_vector(128'h00112233445566778899aabbccddeeff,
							 128'h000102030405060708090a0b0c0d0e0f);

		run_vector(128'h6bc1bee22e409f96e93d7e117393172a,
							 128'h2b7e151628aed2a6abf7158809cf4f3c);

		repeat (10) @(posedge clk);
		$finish;
	end

endmodule
