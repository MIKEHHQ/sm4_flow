`timescale 1ns / 100ps

module cir_top(
    clk,
    reset ,
    plaintext_in,
    key_in,
    in_valid,
    result_out,
    out_valid
);
    input clk;
    input reset;
    input [127:0] plaintext_in;
    input [127:0] key_in;
    input in_valid;
    output [127:0] result_out;
    output out_valid;

    reg [4:0] cnt;
    reg in_flag;
    reg [127:0] data_in;
    reg [127:0] key_for_round;
    wire [127:0] key_after_round;
    wire [127:0] data_after_round;
    wire [31:0] cki;
    wire [4:0] cnt_wire;


    //传递 user_key_valid_in
    always@(posedge clk or posedge reset)
    if (reset)
        in_flag <= 1'b0;
    else
        in_flag <= in_valid;

    //传递 user_key_in
    always@(posedge clk or posedge reset)
    if (reset)
        begin
            key_for_round <= 128'b0;
            data_in <= 128'b0;
        end
    else if ((~in_flag && in_valid)||cnt_wire==5'b11111)
        begin
            key_for_round <= key_in;
            data_in <= plaintext_in;
        end
    else
        begin
            data_in <= data_after_round;
            key_for_round <= key_after_round;
        end

    get_cki u_get_cki
    (
        .count_round_in(cnt_wire),
        .cki_out(cki)
    );

    one_round_for_key_exp   u_key
    (
        .count_round_in(cnt=='b0),
        .data_in(key_for_round),
        .ck_parameter_in(cki),
        .result_out(key_after_round)
    );

    one_round_for_encdec u_encdec (
        .data_in(data_in),
        .round_key_in(key_after_round[31:0]),
        .result_out(data_after_round)
    );

    //    count for cir
    assign cnt_wire = cnt;
    assign result_out = (cnt_wire==5'b11111)?{data_after_round[31:0  ],data_after_round[63:32 ],data_after_round[95:64 ],data_after_round[127:96]}:127'b0;
    //    assign result_out = data_after_round;
    assign out_valid = (cnt_wire==5'b11111)?1'b1:1'b0;
    always @(posedge clk or posedge reset)
    begin
        if(reset || ~in_flag)
            begin
                cnt<=5'b0;
                //                out_valid<=1'b0;
            end
        else
            begin
                cnt<=cnt+5'b00001;
                //                if(cnt==5'b11111)
                //                    begin
                //                        cnt<=5'b0;
                ////                        out_valid<=1'b1;
                //                    end
                //                 else
                //                    begin
                //                        cnt<=cnt+5'b00001;
                //                    end
            end
    end


endmodule    