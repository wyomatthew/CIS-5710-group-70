/* TODO: Names of all group members
 * TODO: PennKeys of all group members
 *
 * lc4_regfile.v
 * Implements an 8-register register file parameterized on word size.
 *
 */

`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

module lc4_regfile #(parameter n = 16)
   (input  wire         clk,
    input  wire         gwe,
    input  wire         rst,
    input  wire [  2:0] i_rs,      // rs selector
    output wire [n-1:0] o_rs_data, // rs contents
    input  wire [  2:0] i_rt,      // rt selector
    output wire [n-1:0] o_rt_data, // rt contents
    input  wire [  2:0] i_rd,      // rd selector
    input  wire [n-1:0] i_wdata,   // data to write
    input  wire         i_rd_we    // write enable
    );

    wire [n-1:0] o_reg [7:0];

    genvar i;
    for (i = 0; i < 8; i = i + 1) begin
        Nbit_reg
            #(.n(n), .r(0))
        my_reg (
            .we(i_rd == i ? i_rd_we : 1'b0),
            .in(i_wdata),
            .out(o_reg[i]),
            .clk(clk),
            .gwe(gwe),
            .rst(rst)
        );
    end

    assign o_rs_data = i_rs == 0 ? o_reg[0] :
                       i_rs == 1 ? o_reg[1] :
                       i_rs == 2 ? o_reg[2] :
                       i_rs == 3 ? o_reg[3] :
                       i_rs == 4 ? o_reg[4] :
                       i_rs == 5 ? o_reg[5] :
                       i_rs == 6 ? o_reg[6] :
                                   o_reg[7];
    assign o_rt_data = i_rt == 0 ? o_reg[0] :
                       i_rt == 1 ? o_reg[1] :
                       i_rt == 2 ? o_reg[2] :
                       i_rt == 3 ? o_reg[3] :
                       i_rt == 4 ? o_reg[4] :
                       i_rt == 5 ? o_reg[5] :
                       i_rt == 6 ? o_reg[6] :
                                   o_reg[7];

endmodule
