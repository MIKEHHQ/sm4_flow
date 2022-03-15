
module sm4_toplevel (input CLK_i,
                     input RST_N_i,
                     input [127:0] MK_i,
                     input MK_VALID_i,
                     input [127:0] DAT_i,
                     input DAT_VALID_i,
                     output [127:0] DAT_o,
                     output DAT_READY_o);
    wire RK[31:0];
    wire RK_ready[31:0];

    wire [127:0] DAT [32:0];
    wire DAT_VALID[32:0];

    wire [127:0] MK [31:0];
    wire MK_VALID[31:0];
    
    assign MK[0]        = MK_i;
    assign MK_VALID[0]  = MK_VALID_i;
    assign DAT[0]       = DAT_i;    
    assign DAT_VALID[0] = DAT_VALID_i;

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
        .MK_o       (MK[i+1]),
        .RK_o       (RK[i]),
        .RK_READY_o (RK_ready[i])
        );
        mesenc mesenc(
        .CLK_i      (CLK_i),
        .RST_N_i    (RST_N_i),
        .RK_i       (RK[i]),
        .DAT_i      (DAT[i]),
        .DAT_VALID_i(DAT_VALID[i] & RK_ready),
        .DAT_o      (DAT_o),
        .DAT_READY_o(DAT__VALID[i+1])
        );
    end
    endgenerate
    
endmodule
