// message encoder
module mesenc(input CLK_i,//CLK
    //           input RST_N_i,
    input [31:0] RK_i,//round key
    input [127:0] DAT_i,//data input
    //           input DAT_VALID_i,
    output [127:0] DAT_o//data output
    //           output DAT_READY_o
);

    reg [31:0] X [4:0];
    always @(posedge CLK_i)
    begin
        X[3] = DAT_i[32*(0+1)-1:32*0];
        X[2] = DAT_i[32*(1+1)-1:32*1];
        X[1] = DAT_i[32*(2+1)-1:32*2];
        X[0] = DAT_i[32*(3+1)-1:32*3];
    end

    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] x_ff;

    /* Input of transformation function T(X) */
    assign a = (X[1] ^ X[2]) ^ (X[3] ^ RK_i);

    sbox_32b SBOX(
        .X_i     (a),
        .Y_o     (b)
    );

    /* Linear transformation */
    //    wire [31:0] t = (b ^ {b[29:0],b[31:30]}) ^ ({b[21:0],b[31:22]} ^ {b[13:0],b[31:14]}) ^ {b[7:0],b[31:8]};

    /* Pipeline stage i */
    //    assign x_ff = X[0];
    //    always @(x_ff, t)
    //        X[4] = x_ff ^ t;
    
    always@(b)
    X[4] = (b ^ {b[29:0],b[31:30]}) ^ ({b[21:0],b[31:22]} ^ {b[13:0],b[31:14]}) ^ ({b[7:0],b[31:8]}^X[0]);

    /* Reverse order function */
    assign DAT_o = {X[1],X[2],X[3],X[4]};

    //    reg [1:0] ready;

    //    /* Maintain ready signal */
    //    always @(posedge CLK_i or negedge RST_N_i)
    //        if (~RST_N_i)
    //        begin
    //            ready <= 'b0;
    //        end
    //        else
    //        begin
    //            ready[0] <= DAT_VALID_i;
    //            ready[1] <= ready[0];
    //        end

    //    assign DAT_READY_o = ready[1];

endmodule
