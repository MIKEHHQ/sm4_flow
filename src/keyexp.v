
module keygen(input CLK_i,
              input RST_N_i,
              input [127:0] MK_i,
              input MK_VALID_i,
              input CK,
              output [127:0] MK_o,
              output [31:0] RK_o,
              output RK_READY_o);
    
    // wire [31:0] CK [31:0];
    
    // /* CK constant table */
    // assign CK[0]  = 32'h00070E15, CK[1]  = 32'h1C232A31, CK[2]  = 32'h383F464D, CK[3]  = 32'h545B6269;
    // assign CK[4]  = 32'h70777E85, CK[5]  = 32'h8C939AA1, CK[6]  = 32'hA8AFB6BD, CK[7]  = 32'hC4CBD2D9;
    // assign CK[8]  = 32'hE0E7EEF5, CKgen[9]  = 32'hFC030A11, CK[10]  = 32'h181F262D, CK[11]  = 32'h343B4249;
    // assign CK[12] = 32'h50575E65, CK[13] = 32'h6C737A81, CK[14] = 32'h888F969D, CK[15] = 32'hA4ABB2B9;
    // assign CK[16] = 32'hC0C7CED5, CK[17] = 32'hDCE3EAF1, CK[18] = 32'hF8FF060D, CK[19] = 32'h141B2229;
    // assign CK[20] = 32'h30373E45, CK[21] = 32'h4C535A61, CK[22] = 32'h686F767D, CK[23] = 32'h848B9299;
    // assign CK[24] = 32'hA0A7AEB5, CK[25] = 32'hBCC3CAD1, CK[26] = 32'hD8DFE6ED, CK[27] = 32'hF4FB0209;
    // assign CK[28] = 32'h10171E25, CK[29] = 32'h2C333A41, CK[30] = 32'h484F565D, CK[31] = 32'h646B7279;
    
    wire [31:0] K [4:0];
    
    assign K[3] = MK_i[32*(0+1)-1:32*0] ^ 32'hB27022DC;
    assign K[2] = MK_i[32*(1+1)-1:32*1] ^ 32'h677D9197;
    assign K[1] = MK_i[32*(2+1)-1:32*2] ^ 32'h56AA3350;
    assign K[0] = MK_i[32*(3+1)-1:32*3] ^ 32'hA3B1BAC6;
    
    wire [31:0] x;
    wire [31:0] y;
    wire [31:0] k_ff;
    
    /* Input of transformation function T'(X) */
    assign x = (K[1] ^ K[2]) ^ (K[3] ^ CK);
    
    sbox_32b SBOX(
    .X_i     (x),
    .Y_o     (y)
    );
    
    /* Linear transformation */
    wire [31:0] t = y ^ {y[18:0],y[31:19]} ^ {y[8:0],y[31:9]};
    
    /* Pipeline stage i */
    assign k_ff = K[0];
    
    assign K[4] = k_ff ^ t;
    
    /* Extract round key from K */
    assign RK_o[31] = K[4];
    assign MK_o     = {K[4],K[3],K[2],K[1]};
    
    
    
    /* Maintain ready signal */
    reg [1:0] ready;
    always @(posedge CLK_i or negedge RST_N_i)
        if (~RST_N_i)
        begin
            ready <= 'b0;
        end
        else
        begin
            ready[0] <= MK_VALID_i;
            ready[1] <= ready[0];
        end
    
    assign RK_READY_o = ready[1];
    
endmodule
