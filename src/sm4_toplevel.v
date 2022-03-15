
module sm4_toplevel (input CLK_i,
                     input RST_N_i,
                     input [127:0] MK_i,
                     input MK_VALID_i,
                     input [127:0] DAT_i,
                     input DAT_VALID_i,
                     output [127:0] DAT_o,
                     output DAT_READY_o);
    wire [31:0] RK[31:0];
    
    wire [127:0] DAT [32:0];
    wire DAT_VALID[32:0];
    
    wire [127:0] MK [32:0];
    wire MK_VALID[32:0];
    
    wire [31:0] CK [31:0];
    
    assign MK_VALID[0]  = MK_VALID_i;
    assign DAT[0]       = DAT_i;
    assign DAT_VALID[0] = DAT_VALID_i; 
    
    assign DAT_o[32*(0+1)-1:32*0] = DAT[32][32*(3+1)-1:32*3];
    assign DAT_o[32*(1+1)-1:32*1] = DAT[32][32*(2+1)-1:32*2];
    assign DAT_o[32*(2+1)-1:32*2] = DAT[32][32*(1+1)-1:32*1];
    assign DAT_o[32*(3+1)-1:32*3] = DAT[32][32*(0+1)-1:32*0];

    
    genvar i;
    /* key expand algorithm module */
    generate
    for(i = 0;i<32;i = i+1)
    begin
        keygen keygen(
        .CLK_i      (CLK_i),
        .RST_N_i    (RST_N_i),
        .MK_i       (MK[i]),
        .MK_VALID_i (MK_VALID[i]),
        .CK         (CK[i]),
        .MK_o       (MK[i+1]),
        .RK_o       (RK[i]),
        .RK_READY_o (MK_VALID[i+1])
        );
        
        mesenc mesenc(
        .CLK_i      (CLK_i),
        .RST_N_i    (RST_N_i),
        .RK_i       (RK[i]),
        .DAT_i      (DAT[i]),
        .DAT_VALID_i(DAT_VALID[i]),
        .DAT_o      (DAT[i+1]),
        .DAT_READY_o(DAT_VALID[i+1])
        
        );
    end
    endgenerate
    
    assign MK[0]  = {MK_i[32*(3+1)-1:32*3] ^ 32'hA3B1BAC6,MK_i[32*(2+1)-1:32*2] ^ 32'h56AA3350,
                     MK_i[32*(1+1)-1:32*1] ^ 32'h677D9197,MK_i[32*(0+1)-1:32*0] ^ 32'hB27022DC
    };
    
    assign CK[0]  = 32'h00070E15, CK[1]  = 32'h1C232A31, CK[2]  = 32'h383F464D, CK[3]  = 32'h545B6269;
    assign CK[4]  = 32'h70777E85, CK[5]  = 32'h8C939AA1, CK[6]  = 32'hA8AFB6BD, CK[7]  = 32'hC4CBD2D9;
    assign CK[8]  = 32'hE0E7EEF5, CK[9]  = 32'hFC030A11, CK[10]  = 32'h181F262D, CK[11]  = 32'h343B4249;
    assign CK[12] = 32'h50575E65, CK[13] = 32'h6C737A81, CK[14] = 32'h888F969D, CK[15] = 32'hA4ABB2B9;
    assign CK[16] = 32'hC0C7CED5, CK[17] = 32'hDCE3EAF1, CK[18] = 32'hF8FF060D, CK[19] = 32'h141B2229;
    assign CK[20] = 32'h30373E45, CK[21] = 32'h4C535A61, CK[22] = 32'h686F767D, CK[23] = 32'h848B9299;
    assign CK[24] = 32'hA0A7AEB5, CK[25] = 32'hBCC3CAD1, CK[26] = 32'hD8DFE6ED, CK[27] = 32'hF4FB0209;
    assign CK[28] = 32'h10171E25, CK[29] = 32'h2C333A41, CK[30] = 32'h484F565D, CK[31] = 32'h646B7279;
    
    reg [30:0] ready;
    assign DAT_READY_o = ready[30];
    always @(posedge CLK_i or negedge RST_N_i)
        if (~RST_N_i)
        begin
            ready <= 'b0;
        end
        else
        begin
            ready[0] <= MK_VALID_i;
            ready[30:1] <= ready[29:0];
        end

endmodule
