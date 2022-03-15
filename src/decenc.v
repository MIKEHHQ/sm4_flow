
module mesenc(input CLK_i,
           input RST_N_i,
           input [31:0] RK_i,
           input [127:0] DAT_i,
           input DAT_VALID_i,
           output [127:0] DAT_o,
           output DAT_READY_o);
    
    wire [31:0] X [4:0];
    
    assign X[3] = DAT_i[32*(0+1)-1:32*0];
    assign X[2] = DAT_i[32*(1+1)-1:32*1];
    assign X[1] = DAT_i[32*(2+1)-1:32*2];
    assign X[0] = DAT_i[32*(3+1)-1:32*3];
    
    
    wire [31:0] a;
    wire [31:0] b;
    reg [31:0] x_ff;
    
    /* Input of transformation function T(X) */
    assign a = (X[1] ^ X[2]) ^ (X[3] ^ RK_i);
    
    sbox_32b SBOX(
    .X_i     (a),
    .Y_o     (b)
    );
    
    /* Linear transformation */
    wire [31:0] t = (b ^ {b[29:0],b[31:30]}) ^ ({b[21:0],b[31:22]} ^ {b[13:0],b[31:14]}) ^ {b[7:0],b[31:8]};
    
    /* Pipeline stage i */
    always @(posedge CLK_i or negedge RST_N_i)
        if (~RST_N_i)
            x_ff <= 'h0;
        else
            x_ff <= X[0];
    
    assign X[4] = x_ff ^ t;
    
    /* Reverse order function */
    // assign DAT_o[32*(0+1)-1:32*0] = X[32];
    // assign DAT_o[32*(1+1)-1:32*1] = X[33];
    // assign DAT_o[32*(2+1)-1:32*2] = X[34];
    // assign DAT_o[32*(3+1)-1:32*3] = X[35];
    
    assign DAT_o = {X[4],X[3],X[2],X[1]};
    
    reg [1:0] ready;
    
    /* Maintain ready signal */
    always @(posedge CLK_i or negedge RST_N_i)
        if (~RST_N_i)
        begin
            ready <= 'b0;
        end
        else
        begin
            ready[0] <= DAT_VALID_i;
            ready[1] <= ready[1];
        end
    
    assign DAT_READY_o = ready[1];
    
endmodule
