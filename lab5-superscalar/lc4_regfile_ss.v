`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

/* 8-register, n-bit register file with
 * four read ports and two write ports
 * to support two pipes.
 * 
 * If both pipes try to write to the
 * same register, pipe B wins.
 * 
 * Inputs should be bypassed to the outputs
 * as needed so the register file returns
 * data that is written immediately
 * rather than only on the next cycle.
 */
module lc4_regfile_ss #(parameter n = 16)
   (input  wire         clk,
    input  wire         gwe,
    input  wire         rst,

    input  wire [  2:0] i_rs_A,      // pipe A: rs selector
    output wire [n-1:0] o_rs_data_A, // pipe A: rs contents
    input  wire [  2:0] i_rt_A,      // pipe A: rt selector
    output wire [n-1:0] o_rt_data_A, // pipe A: rt contents

    input  wire [  2:0] i_rs_B,      // pipe B: rs selector
    output wire [n-1:0] o_rs_data_B, // pipe B: rs contents
    input  wire [  2:0] i_rt_B,      // pipe B: rt selector
    output wire [n-1:0] o_rt_data_B, // pipe B: rt contents

    input  wire [  2:0]  i_rd_A,     // pipe A: rd selector
    input  wire [n-1:0]  i_wdata_A,  // pipe A: data to write
    input  wire          i_rd_we_A,  // pipe A: write enable

    input  wire [  2:0]  i_rd_B,     // pipe B: rd selector
    input  wire [n-1:0]  i_wdata_B,  // pipe B: data to write
    input  wire          i_rd_we_B   // pipe B: write enable
    );

   wire [n - 1:0] reg0_in, reg0_out;
   wire reg0_we;
   Nbit_reg #(.n(n), .r(0)) reg0(.in(reg0_in), .out(reg0_out), .clk(clk), .we(reg0_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg1_in, reg1_out;
   wire reg1_we;
   Nbit_reg #(.n(n), .r(0)) reg1(.in(reg1_in), .out(reg1_out), .clk(clk), .we(reg1_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg2_in, reg2_out;
   wire reg2_we;
   Nbit_reg #(.n(n), .r(0)) reg2(.in(reg2_in), .out(reg2_out), .clk(clk), .we(reg2_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg3_in, reg3_out;
   wire reg3_we;
   Nbit_reg #(.n(n), .r(0)) reg3(.in(reg3_in), .out(reg3_out), .clk(clk), .we(reg3_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg4_in, reg4_out;
   wire reg4_we;
   Nbit_reg #(.n(n), .r(0)) reg4(.in(reg4_in), .out(reg4_out), .clk(clk), .we(reg4_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg5_in, reg5_out;
   wire reg5_we;
   Nbit_reg #(.n(n), .r(0)) reg5(.in(reg5_in), .out(reg5_out), .clk(clk), .we(reg5_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg6_in, reg6_out;
   wire reg6_we;
   Nbit_reg #(.n(n), .r(0)) reg6(.in(reg6_in), .out(reg6_out), .clk(clk), .we(reg6_we), .gwe(gwe), .rst(rst));
   wire [n - 1:0] reg7_in, reg7_out;
   wire reg7_we;
   Nbit_reg #(.n(n), .r(0)) reg7(.in(reg7_in), .out(reg7_out), .clk(clk), .we(reg7_we), .gwe(gwe), .rst(rst));

   assign reg0_we = (i_rd_we_A & i_rd_A == 3'h0) | (i_rd_we_B & i_rd_B == 3'h0);
   assign reg0_in = (i_rd_we_B & i_rd_B == 3'h0) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h0) ? i_wdata_A :
                                                   1'b0      ;

   assign reg1_we = (i_rd_we_A & i_rd_A == 3'h1) | (i_rd_we_B & i_rd_B == 3'h1);
   assign reg1_in = (i_rd_we_B & i_rd_B == 3'h1) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h1) ? i_wdata_A :
                                                   1'b0      ;

   assign reg2_we = (i_rd_we_A & i_rd_A == 3'h2) | (i_rd_we_B & i_rd_B == 3'h2);
   assign reg2_in = (i_rd_we_B & i_rd_B == 3'h2) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h2) ? i_wdata_A :
                                                   1'b0      ;

   assign reg3_we = (i_rd_we_A & i_rd_A == 3'h3) | (i_rd_we_B & i_rd_B == 3'h3);
   assign reg3_in = (i_rd_we_B & i_rd_B == 3'h3) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h3) ? i_wdata_A :
                                                   1'b0      ;

   assign reg4_we = (i_rd_we_A & i_rd_A == 3'h4) | (i_rd_we_B & i_rd_B == 3'h4);
   assign reg4_in = (i_rd_we_B & i_rd_B == 3'h4) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h4) ? i_wdata_A :
                                                   1'b0      ;

   assign reg5_we = (i_rd_we_A & i_rd_A == 3'h5) | (i_rd_we_B & i_rd_B == 3'h5);
   assign reg5_in = (i_rd_we_B & i_rd_B == 3'h5) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h5) ? i_wdata_A :
                                                   1'b0      ;

   assign reg6_we = (i_rd_we_A & i_rd_A == 3'h6) | (i_rd_we_B & i_rd_B == 3'h6);
   assign reg6_in = (i_rd_we_B & i_rd_B == 3'h6) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h6) ? i_wdata_A :
                                                   1'b0      ;

   assign reg7_we = (i_rd_we_A & i_rd_A == 3'h7) | (i_rd_we_B & i_rd_B == 3'h7);
   assign reg7_in = (i_rd_we_B & i_rd_B == 3'h7) ? i_wdata_B :
                    (i_rd_we_A & i_rd_A == 3'h7) ? i_wdata_A :
                                                   1'b0      ;
   
   wire [n-1:0] rs_A_sel_out = i_rs_A == 3'h0 ? reg0_out : i_rs_A == 3'h1 ? reg1_out : i_rs_A == 3'h2 ? reg2_out : i_rs_A == 3'h3 ? reg3_out : i_rs_A == 3'h4 ? reg4_out : i_rs_A == 3'h5 ? reg5_out : i_rs_A == 3'h6 ? reg6_out : reg7_out ;
   wire [n-1:0] rt_A_sel_out = i_rt_A == 3'h0 ? reg0_out : i_rt_A == 3'h1 ? reg1_out : i_rt_A == 3'h2 ? reg2_out : i_rt_A == 3'h3 ? reg3_out : i_rt_A == 3'h4 ? reg4_out : i_rt_A == 3'h5 ? reg5_out : i_rt_A == 3'h6 ? reg6_out : reg7_out ;
   wire [n-1:0] rs_B_sel_out = i_rs_B == 3'h0 ? reg0_out : i_rs_B == 3'h1 ? reg1_out : i_rs_B == 3'h2 ? reg2_out : i_rs_B == 3'h3 ? reg3_out : i_rs_B == 3'h4 ? reg4_out : i_rs_B == 3'h5 ? reg5_out : i_rs_B == 3'h6 ? reg6_out : reg7_out ;
   wire [n-1:0] rt_B_sel_out = i_rt_B == 3'h0 ? reg0_out : i_rt_B == 3'h1 ? reg1_out : i_rt_B == 3'h2 ? reg2_out : i_rt_B == 3'h3 ? reg3_out : i_rt_B == 3'h4 ? reg4_out : i_rt_B == 3'h5 ? reg5_out : i_rt_B == 3'h6 ? reg6_out : reg7_out ;

   assign o_rs_data_A = (i_rd_B == i_rs_A) & i_rd_we_B ? i_wdata_B : 
                        (i_rd_A == i_rs_A) & i_rd_we_A ? i_wdata_A :
                                                         rs_A_sel_out;
   assign o_rt_data_A = (i_rd_B == i_rt_A) & i_rd_we_B ? i_wdata_B :
                        (i_rd_A == i_rt_A) & i_rd_we_A ? i_wdata_A :
                                                         rt_A_sel_out;
   assign o_rs_data_B = (i_rd_B == i_rs_B) & i_rd_we_B ? i_wdata_B : 
                        (i_rd_A == i_rs_B) & i_rd_we_A ? i_wdata_A : 
                                                         rs_B_sel_out;
   assign o_rt_data_B = (i_rd_B == i_rt_B) & i_rd_we_B ? i_wdata_B : 
                        (i_rd_A == i_rt_B) & i_rd_we_A ? i_wdata_A :
                                                         rt_B_sel_out;

endmodule

