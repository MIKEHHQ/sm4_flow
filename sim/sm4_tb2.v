`timescale 1ns / 1ps

module tb_sm4_toplevel;

   reg clk = 1'b1;
   reg rst = 1'b1;
   
   always #1 clk = ~clk;
   
   initial
      begin
         rst = 1'b0;
         #2 rst = 1'b1;
      end
   
   wire [127:0] MK;
   wire MK_VALID;
   wire [127:0] plaintext;
   wire plaintext_valid;
   wire [127:0] ciphertext;
   wire ciphertext_valid;

   /* test key */
   assign MK = 128'h0123456789ABCDEFFEDCBA9876543210;
   assign MK_VALID = 1'b1;
   
   /* test data */
   assign plaintext = 128'h0123456789ABCDEFFEDCBA9876543210;
   assign plaintext_valid = 1'b1;
   
   sm4_toplevel   ENCRYPTOR(
      .CLK_i      (clk),
      .RST_N_i    (rst),
      .MK_i       (MK),
      .MK_VALID_i (MK_VALID),
      .DAT_i      (plaintext),
      .DAT_VALID_i (plaintext_valid),
      .DAT_o      (ciphertext),
      .DAT_READY_o (ciphertext_valid)
   );
   
endmodule