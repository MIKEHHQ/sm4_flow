
module ck(input [0:4] num,
               output reg [0:31] ck);

always @(*) begin
    case (num)
        5'd0  : ck = 32'h00070E15;
        5'd1  : ck = 32'h1C232A31;
        5'd2  : ck = 32'h383F464D;
        5'd3  : ck = 32'h545B6269;
        5'd4  : ck = 32'h70777E85;
        5'd5  : ck = 32'h8C939AA1;
        5'd6  : ck = 32'hA8AFB6BD;
        5'd7  : ck = 32'hC4CBD2D9;
        5'd8  : ck = 32'hE0E7EEF5;
        5'd9  : ck = 32'hFC030A11;
        5'd10 : ck = 32'h181F262D;
        5'd11 : ck = 32'h343B4249;
        5'd12 : ck = 32'h50575E65;
        5'd13 : ck = 32'h6C737A81;
        5'd14 : ck = 32'h888F969D;
        5'd15 : ck = 32'hA4ABB2B9;
        5'd16 : ck = 32'hC0C7CED5;
        5'd17 : ck = 32'hDCE3EAF1;
        5'd18 : ck = 32'hF8FF060D;
        5'd19 : ck = 32'h141B2229;
        5'd20 : ck = 32'h30373E45;
        5'd21 : ck = 32'h4C535A61;
        5'd22 : ck = 32'h686F767D;
        5'd23 : ck = 32'h848B9299;
        5'd24 : ck = 32'hA0A7AEB5;
        5'd25 : ck = 32'hBCC3CAD1;
        5'd26 : ck = 32'hD8DFE6ED;
        5'd27 : ck = 32'hF4FB0209;
        5'd28 : ck = 32'h10171E25;
        5'd29 : ck = 32'h2C333A41;
        5'd30 : ck = 32'h484F565D;
        5'd31 : ck = 32'h646B7279;
    endcase
end

endmodule
