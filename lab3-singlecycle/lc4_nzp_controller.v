/**
 * lc4_nzp_controller
 * Tasneem Pathan (tpathan)
 * Matthew Pickering (mpick)
 * group 70
 */

module lc4_nzp_controller(input wire        clk,
                          input wire        gwe,
                          input wire        rst,
                          input wire [15:0] wdata,
                          input wire        nzp_we,
                          output wire [2:0] o_nzp,
                          output wire [2:0] i_nzp);
    Nbit_reg #(.n(3), .r(0)) nzp_reg(.clk(clk), .gwe(gwe), .rst(rst), .we(nzp_we), .out(o_nzp), .in(i_nzp));

    assign i_nzp = $signed(wdata) <  0 ? 3'b100 :
                   $signed(wdata) == 0 ? 3'b010 :
                                         3'b001 ;
//     assign i_nzp = wdata[15] ? 3'b100 :
//                    |wdata    ? 3'b001 :
//                                3'b010 ;
endmodule
