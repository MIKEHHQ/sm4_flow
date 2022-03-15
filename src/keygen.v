
module keygen(input CLK_i,
              input RST_N_i,
              input [127:0] MK_i,
              input MK_VALID_i,
              input [31:0] CK,
              output [127:0] MK_o,
              output [31:0] RK_o,
              output RK_READY_o);
    
    reg [31:0] K [4:0];
    always @(posedge CLK_i)
    begin
        K[3] = MK_i[32*(0+1)-1:32*0];
        K[2] = MK_i[32*(1+1)-1:32*1];
        K[1] = MK_i[32*(2+1)-1:32*2];
        K[0] = MK_i[32*(3+1)-1:32*3];
    end
    wire [31:0] x;
    wire [31:0] y;
//    wire [31:0] k_ff;
    
    /* Input of transformation function T'(X) */
    assign x = (K[1] ^ K[2]) ^ (K[3] ^ CK);
    
    sbox_32b SBOX(
    .X_i     (x),
    .Y_o     (y)
    );
    
    /* Linear transformation */
//    wire [31:0] t = (y ^ {y[18:0],y[31:19]}) ^ ({y[8:0],y[31:9]}^K[0]);
    /* Pipeline stage i */
//    assign k_ff = K[0];
//    always @(k_ff, t)
//        K[4] = k_ff ^ t;
    always @(y)
        K[4] = (y ^ {y[18:0],y[31:19]}) ^ ({y[8:0],y[31:9]}^K[0]);
    
    /* Extract round key from K */
    assign RK_o = K[4];
    assign MK_o = {K[1],K[2],K[3],K[4]};
    
    /* Maintain ready signal */
//    reg [1:0] ready;
//    always @(posedge CLK_i or negedge RST_N_i)
//        if (~RST_N_i)
//        begin
//            ready <= 'b0;
//        end
//        else
//        begin
//            ready[0] <= MK_VALID_i;
//            ready[1] <= ready[0];
//        end
    
//    assign RK_READY_o = ready[1];
    
endmodule
