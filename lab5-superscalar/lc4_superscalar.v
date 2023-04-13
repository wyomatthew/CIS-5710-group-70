`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

module pipe_reg_D(input wire clk,
                  input wire we,
                  input wire gwe,
                  input wire rst,
                  input wire [15:0] i_insn, 
                  input wire [15:0] i_pc,
                  input wire [1:0]  i_stall,
                  output wire [15:0] o_insn,
                  output wire [15:0] o_pc,
                  output wire [1:0]  o_stall);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(2), .r(2)) stall_reg (.in(i_stall), .out(o_stall), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
endmodule

module pipe_reg_X(input wire         clk,
                  input wire         we,
                  input wire         gwe,
                  input wire         rst,
                  input wire [15:0]  i_insn,
                  input wire [15:0]  i_pc,
                  input wire [1:0]   i_stall,
                  input wire [15:0]  i_r1data,
                  input wire [15:0]  i_r2data,
                  input wire         i_nzp_we,
                  input wire         i_is_load,
                  input wire         i_is_store,
                  input wire         i_is_cntl,
                  input wire         i_take_branch,
                  input wire         i_select_pc_plus_one,
                  input wire         i_regfile_we,
                  input wire         i_regfile_r1re,
                  input wire         i_regfile_r2re,
                  input wire [2:0]   i_regfile_wsel,
                  input wire [2:0]   i_regfile_r1sel,
                  input wire [2:0]   i_regfile_r2sel,
                  output wire [15:0] o_insn,
                  output wire [15:0] o_pc,
                  output wire [1:0]  o_stall,
                  output wire [15:0] o_r1data,
                  output wire [15:0] o_r2data,
                  output wire        o_nzp_we,
                  output wire        o_is_load,
                  output wire        o_is_store,
                  output wire        o_is_cntl,
                  output wire        o_take_branch,
                  output wire        o_select_pc_plus_one,
                  output wire        o_regfile_r1re, 
                  output wire        o_regfile_r2re,
                  output wire        o_regfile_we,
                  output wire [2:0]  o_regfile_wsel,
                  output wire [2:0]  o_regfile_r1sel,
                  output wire [2:0]  o_regfile_r2sel);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) r1data_reg (.in(i_r1data), .out(o_r1data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) r2data_reg (.in(i_r2data), .out(o_r2data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) r1re_reg (.in(i_regfile_r1re), .out(o_regfile_r1re), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) r2re_reg (.in(i_regfile_r2re), .out(o_regfile_r2re), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(1), .r(0)) nzp_we_reg (.in(i_nzp_we), .out(o_nzp_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_load_reg (.in(i_is_load), .out(o_is_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_store_reg (.in(i_is_store), .out(o_is_store), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_cntl_reg (.in(i_is_cntl), .out(o_is_cntl), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) take_branch_reg (.in(i_take_branch), .out(o_take_branch), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) select_pc_plus_one_reg (.in(i_select_pc_plus_one), .out(o_select_pc_plus_one), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) regfile_we_reg (.in(i_regfile_we), .out(o_regfile_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_wsel_reg (.in(i_regfile_wsel), .out(o_regfile_wsel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_r1sel_reg (.in(i_regfile_r1sel), .out(o_regfile_r1sel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_r2sel_reg (.in(i_regfile_r2sel), .out(o_regfile_r2sel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(2), .r(2)) stall_reg (.in(i_stall), .out(o_stall), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
endmodule

module pipe_reg_M(input wire         clk,
                  input wire         we,
                  input wire         gwe,
                  input wire         rst,
                  input wire [15:0]  i_insn,
                  input wire [15:0]  i_pc,
                  input wire [1:0]   i_stall,
                  input wire [15:0]  i_alu_output,
                  input wire [15:0]  i_r2data,
                  input wire         i_nzp_we,
                  input wire         i_is_load,
                  input wire         i_is_store,
                  input wire         i_is_cntl,
                  input wire         i_regfile_we,
                  input wire [2:0]   i_regfile_wsel,
                  input wire [2:0]   i_regfile_r2sel,
                  input wire [2:0]   i_nzp_data,
                  output wire [15:0] o_insn,
                  output wire [15:0] o_pc,
                  output wire [1:0]  o_stall,
                  output wire [15:0] o_alu_output,
                  output wire [15:0] o_r2data,
                  output wire        o_nzp_we,
                  output wire        o_is_load,
                  output wire        o_is_store,
                  output wire        o_is_cntl,
                  output wire        o_regfile_we,
                  output wire [2:0]  o_regfile_wsel,
                  output wire [2:0]  o_regfile_r2sel,
                  output wire [2:0]  o_nzp_data);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) alu_output_reg (.in(i_alu_output), .out(o_alu_output), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) r2data_reg (.in(i_r2data), .out(o_r2data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(1), .r(0)) nzp_we_reg (.in(i_nzp_we), .out(o_nzp_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_load_reg (.in(i_is_load), .out(o_is_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_store_reg (.in(i_is_store), .out(o_is_store), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_cntl_reg (.in(i_is_cntl), .out(o_is_cntl), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) regfile_we_reg (.in(i_regfile_we), .out(o_regfile_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_wsel_reg (.in(i_regfile_wsel), .out(o_regfile_wsel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_r2sel_reg (.in(i_regfile_r2sel), .out(o_regfile_r2sel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(3), .r(0)) nzp_data_reg (.in(i_nzp_data), .out(o_nzp_data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(2), .r(2)) stall_reg (.in(i_stall), .out(o_stall), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

endmodule

module pipe_reg_W(input wire         clk,
                  input wire         we,
                  input wire         gwe,
                  input wire         rst,
                  input wire [15:0]  i_insn,
                  input wire [15:0]  i_pc,
                  input wire [1:0]   i_stall,
                  input wire [15:0]  i_alu_output,
                  input wire         i_nzp_we,
                  input wire [2:0]   i_nzp_data,
                  input wire         i_is_load,
                  input wire         i_is_store,
                  input wire         i_is_cntl,
                  input wire         i_regfile_we,
                  input wire [2:0]   i_regfile_wsel,
                  input wire [15:0]  i_dmem_towrite,
                  input wire [15:0]  i_dmem_loaded_data,
                  output wire [15:0] o_insn,
                  output wire [15:0] o_pc,
                  output wire [1:0]  o_stall,
                  output wire [15:0] o_alu_output,
                  output wire        o_nzp_we,
                  output wire [2:0]  o_nzp_data,
                  output wire        o_is_load,
                  output wire        o_is_store,
                  output wire        o_is_cntl,
                  output wire        o_regfile_we,
                  output wire [2:0]  o_regfile_wsel,
                  output wire [15:0] o_dmem_towrite,
                  output wire [15:0] o_dmem_loaded_data);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) alu_output_reg (.in(i_alu_output), .out(o_alu_output), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) dmem_write_reg (.in(i_dmem_towrite), .out(o_dmem_towrite), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) dmem_loaded_data_reg (.in(i_dmem_loaded_data), .out(o_dmem_loaded_data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(1), .r(0)) is_load_reg (.in(i_is_load), .out(o_is_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_store_reg (.in(i_is_store), .out(o_is_store), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_cntl_reg (.in(i_is_cntl), .out(o_is_cntl), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(1), .r(0)) nzp_we_reg (.in(i_nzp_we), .out(o_nzp_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) regfile_we_reg (.in(i_regfile_we), .out(o_regfile_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_wsel_reg (.in(i_regfile_wsel), .out(o_regfile_wsel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(3), .r(0)) nzp_data_reg (.in(i_nzp_data), .out(o_nzp_data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(2), .r(2)) stall_reg (.in(i_stall), .out(o_stall), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
endmodule

module lc4_processor(input wire         clk,             // main clock
                     input wire         rst,             // global reset
                     input wire         gwe,             // global we for single-step clock

                     output wire [15:0] o_cur_pc,        // address to read from instruction memory
                     input wire [15:0]  i_cur_insn_A,    // output of instruction memory (pipe A)
                     input wire [15:0]  i_cur_insn_B,    // output of instruction memory (pipe B)

                     output wire [15:0] o_dmem_addr,     // address to read/write from/to data memory
                     input wire [15:0]  i_cur_dmem_data, // contents of o_dmem_addr
                     output wire        o_dmem_we,       // data memory write enable
                     output wire [15:0] o_dmem_towrite,  // data to write to o_dmem_addr if we is set

                     // testbench signals (always emitted from the WB stage)
                     output wire [ 1:0] test_stall_A,        // is this a stall cycle?  (0: no stall,
                     output wire [ 1:0] test_stall_B,        // 1: pipeline stall, 2: branch stall, 3: load stall)

                     output wire [15:0] test_cur_pc_A,       // program counter
                     output wire [15:0] test_cur_pc_B,
                     output wire [15:0] test_cur_insn_A,     // instruction bits
                     output wire [15:0] test_cur_insn_B,
                     output wire        test_regfile_we_A,   // register file write-enable
                     output wire        test_regfile_we_B,
                     output wire [ 2:0] test_regfile_wsel_A, // which register to write
                     output wire [ 2:0] test_regfile_wsel_B,
                     output wire [15:0] test_regfile_data_A, // data to write to register file
                     output wire [15:0] test_regfile_data_B,
                     output wire        test_nzp_we_A,       // nzp register write enable
                     output wire        test_nzp_we_B,
                     output wire [ 2:0] test_nzp_new_bits_A, // new nzp bits
                     output wire [ 2:0] test_nzp_new_bits_B,
                     output wire        test_dmem_we_A,      // data memory write enable
                     output wire        test_dmem_we_B,
                     output wire [15:0] test_dmem_addr_A,    // address to read/write from/to memory
                     output wire [15:0] test_dmem_addr_B,
                     output wire [15:0] test_dmem_data_A,    // data to read/write from/to memory
                     output wire [15:0] test_dmem_data_B,

                     // zedboard switches/display/leds (ignore if you don't want to control these)
                     input  wire [ 7:0] switch_data,         // read on/off status of zedboard's 8 switches
                     output wire [ 7:0] led_data             // set on/off status of zedboard's 8 leds
                     );

   /***  YOUR CODE HERE ***/

   wire [15:0] pc_reg_out;
   wire [15:0] pc;
   wire [15:0] next_pc;

   Nbit_reg #(.n(16), .r(16'h8200)) pc_reg (.in(next_pc), .out(pc_reg_out), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));
   assign pc = load_to_use_stall ? reg_D_o_pc : pc_reg_out; // TODO change

   // Initialize pipelines in sequence
   
   // Initialize F-D split
   wire [15:0] pc1;
   cla16 incrementer(.a(pc), .b(16'b1), .cin(1'b0), .sum(pc1));

   // Branch predict next program counter
   assign next_pc = reg_X_o_take_branch ? o_result : // TODO change to accomodate pipelines
                                          pc1      ;

   wire [15:0] out_insn_A, out_insn_B, out_pc;
   assign out_insn_A = i_cur_insn_A;
   assign out_insn_B = i_cur_insn_B;
   assign out_pc     = pc;

   wire [1:0] next_insn_stall_A, next_insn_stall_B; // TODO assign

   wire [15:0] reg_D_A_o_insn, reg_D_A_o_pc;
   wire [1:0] reg_D_A_o_stall;
   wire [15:0] reg_D_B_o_insn, reg_D_B_o_pc;
   wire [1:0] reg_D_B_o_stall;
   pipe_reg_D reg_D_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(out_insn_A),
      .i_pc(out_pc_A),
      .i_stall(next_insn_stall_A),
      .o_insn(reg_D_A_o_insn),
      .o_pc(reg_D_A_o_pc),
      .o_stall(reg_D_A_o_stall)
   );
   pipe_reg_D reg_D_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(out_insn_B),
      .i_pc(out_pc_B),
      .i_stall(next_insn_stall_B),
      .o_insn(reg_D_B_o_insn),
      .o_pc(reg_D_B_o_pc),
      .o_stall(reg_D_B_o_stall)
   );

   // Initialize D-X split
   wire [2:0] r1sel_A, r2sel_A, wsel_A;
   wire r1re_A, r2re_A;
   wire regfile_we_A, is_load_A, is_store_A, is_branch_A, is_control_insn_A, nzp_we_A, select_pc_plus_one_A;
   lc4_decoder decoder_A(
      .insn(reg_D_A_o_insn),
      .r1sel(r1sel_A),
      .r1re(r1re_A),
      .r2sel(r2sel_A),
      .r2re(r2re_A),
      .wsel(wsel_A),
      .regfile_we(regfile_we_A),
      .nzp_we(nzp_we_A),
      .select_pc_plus_one(select_pc_plus_one_A),
      .is_load(is_load_A),
      .is_store(is_store_A),
      .is_branch(is_branch_A),
      .is_control_insn(is_control_insn_A)
   );
   wire [2:0] r1sel_B, r2sel_B, wsel_B;
   wire r1re_B, r2re_B;
   wire regfile_we_B, is_load_B, is_store_B, is_branch_B, is_control_insn_B, nzp_we_B, select_pc_plus_one_B;
   lc4_decoder decoder_B(
      .insn(reg_D_B_o_insn),
      .r1sel(r1sel_B),
      .r1re(r1re_B),
      .r2sel(r2sel_B),
      .r2re(r2re_B),
      .wsel(wsel_B),
      .regfile_we(regfile_we_B),
      .nzp_we(nzp_we_B),
      .select_pc_plus_one(select_pc_plus_one_B),
      .is_load(is_load_B),
      .is_store(is_store_B),
      .is_branch(is_branch_B),
      .is_control_insn(is_control_insn_B)
   );

   wire i_rd_we;
   wire [2:0] i_rs_A, i_rt_A, i_rs_B, i_rt_B, i_rd_A, i_rd_B;
   wire [15:0] o_rs_data_A, o_rt_data_A, o_rs_data_B, o_rt_data_B, i_wdata_A, i_wdata_B; 
   wire i_rd_we_A, i_rd_we_B;  
   lc4_regfile_ss #(.n(16)) regfile(
      .clk(clk),
      .gwe(gwe),
      .rst(rst),
      
      .i_rs_A(i_rs_A),
      .o_rs_data_A(o_rs_data_A),
      .i_rt_A(i_rt_A),
      .o_rt_data_A(o_rt_data_A),

      .i_rd_A(i_rd_A),
      .i_wdata_A(i_wdata_A),
      .i_rd_we_A(i_rd_we_A),
      
      .i_rs_B(i_rs_B),
      .o_rs_data_B(o_rs_data_B),
      .i_rt_B(i_rt_B),
      .o_rt_data_B(o_rt_data_B),

      .i_rd_B(i_rd_B),
      .i_wdata_B(i_wdata_B),
      .i_rd_we_B(i_rd_we_B)
   );
   
   wire  reg_X_A_o_regfile_r1re, reg_X_A_o_regfile_r2re, reg_X_A_o_nzp_we, reg_X_A_o_is_load, reg_X_A_o_is_store, reg_X_A_o_is_cntl, reg_X_A_o_take_branch, reg_X_A_o_select_pc_plus_one, reg_X_A_o_regfile_we;
   wire [1:0] reg_X_A_o_stall;
   wire [2:0] reg_X_A_o_regfile_wsel, reg_X_A_o_regfile_r1sel, reg_X_A_o_regfile_r2sel;
   wire [15:0] reg_X_A_o_insn, reg_X_A_o_pc, reg_X_A_o_r1data, reg_X_A_o_r2data;

   pipe_reg_X_A reg_X_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_D_A_o_insn),
      .i_pc(reg_D_A_o_pc),
      .i_stall(), // TODO
      .i_r1data(i_rs_A),
      .i_r2data(i_rt_A),
      .i_nzp_we(nzp_we_A),
      .i_is_load(is_load_A),
      .i_is_store(is_store_A),
      .i_is_cntl(is_control_insn_A),
      .i_take_branch(), // TODO
      .i_select_pc_plus_one(select_pc_plus_one_A),
      .i_regfile_we(regfile_we_A),
      .i_regfile_wsel(wsel_A),
      .i_regfile_r1sel(r1sel_A),
      .i_regfile_r2sel(r2sel_A),
      .i_regfile_r1re(r1re_A),
      .i_regfile_r2re(r2re_A),
      .o_insn(reg_X_A_o_insn),
      .o_pc(reg_X_A_o_pc),
      .o_stall(reg_X_A_o_stall),
      .o_r1data(reg_X_A_o_r1data),
      .o_r2data(reg_X_A_o_r2data),
      .o_regfile_r1re(reg_X_A_o_regfile_r1re),
      .o_regfile_r2re(reg_X_A_o_regfile_r2re),
      .o_nzp_we(reg_X_A_o_nzp_we),
      .o_is_load(reg_X_A_o_is_load),
      .o_is_store(reg_X_A_o_is_store),
      .o_is_cntl(reg_X_A_o_is_cntl),
      .o_take_branch(reg_X_A_o_take_branch),
      .o_select_pc_plus_one(reg_X_A_o_select_pc_plus_one),
      .o_regfile_we(reg_X_A_o_regfile_we),
      .o_regfile_wsel(reg_X_A_o_regfile_wsel),
      .o_regfile_r1sel(reg_X_A_o_regfile_r1sel),
      .o_regfile_r2sel(reg_X_A_o_regfile_r2sel)
   );

   wire  reg_X_B_o_regfile_r1re, reg_X_B_o_regfile_r2re, reg_X_B_o_nzp_we, reg_X_B_o_is_load, reg_X_B_o_is_store, reg_X_B_o_is_cntl, reg_X_B_o_take_branch, reg_X_B_o_select_pc_plus_one, reg_X_B_o_regfile_we;
   wire [1:0] reg_X_B_o_stall;
   wire [2:0] reg_X_B_o_regfile_wsel, reg_X_B_o_regfile_r1sel, reg_X_B_o_regfile_r2sel;
   wire [15:0] reg_X_B_o_insn, reg_X_B_o_pc, reg_X_B_o_r1data, reg_X_B_o_r2data;

   pipe_reg_X_B reg_X_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_D_B_o_insn),
      .i_pc(reg_D_B_o_pc),
      .i_stall(),  // TODO
      .i_r1data(i_rs_B),
      .i_r2data(i_rt_B),
      .i_nzp_we(nzp_we_B),
      .i_is_load(is_load_B),
      .i_is_store(is_store_B),
      .i_is_cntl(is_control_insn_B),
      .i_take_branch(), // TODO
      .i_select_pc_plus_one(select_pc_plus_one_B),
      .i_regfile_we(regfile_we_B),
      .i_regfile_wsel(wsel_B),
      .i_regfile_r1sel(r1sel_B),
      .i_regfile_r2sel(r2sel_B),
      .i_regfile_r1re(r1re_B),
      .i_regfile_r2re(r2re_B),
      .o_insn(reg_X_B_o_insn),
      .o_pc(reg_X_B_o_pc),
      .o_stall(reg_X_B_o_stall),
      .o_r1data(reg_X_B_o_r1data),
      .o_r2data(reg_X_B_o_r2data),
      .o_regfile_r1re(reg_X_B_o_regfile_r1re),
      .o_regfile_r2re(reg_X_B_o_regfile_r2re),
      .o_nzp_we(reg_X_B_o_nzp_we),
      .o_is_load(reg_X_B_o_is_load),
      .o_is_store(reg_X_B_o_is_store),
      .o_is_cntl(reg_X_B_o_is_cntl),
      .o_take_branch(reg_X_B_o_take_branch),
      .o_select_pc_plus_one(reg_X_B_o_select_pc_plus_one),
      .o_regfile_we(reg_X_B_o_regfile_we),
      .o_regfile_wsel(reg_X_B_o_regfile_wsel),
      .o_regfile_r1sel(reg_X_B_o_regfile_r1sel),
      .o_regfile_r2sel(reg_X_B_o_regfile_r2sel)
   );

   // Initialize X-M split
   wire  reg_M_A_o_nzp_we, reg_M_A_o_is_load, reg_M_A_o_is_store, reg_M_A_o_is_cntl, reg_M_A_o_regfile_we;
   wire [1:0] reg_M_A_o_stall;
   wire [2:0] reg_M_A_o_regfile_wsel, reg_M_A_o_regfile_r2sel, reg_M_A_o_nzp_data;
   wire [15:0] reg_M_A_o_insn, reg_M_A_o_pc, reg_M_A_o_alu_output, reg_M_A_o_r2data;

   pipe_reg_M_A reg_M_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_X_A_o_insn),
      .i_pc(reg_X_A_o_pc),
      .i_stall(reg_X_A_o_stall),
      .i_alu_output(o_result), // TODO
      .i_r2data(i_r2data), // TODO
      .i_nzp_we(reg_X_A_o_nzp_we),
      .i_is_load(reg_X_A_o_is_load),
      .i_is_store(reg_X_A_o_is_store),
      .i_is_cntl(reg_X_A_o_is_cntl),
      .i_regfile_we(reg_X_A_o_regfile_we),
      .i_regfile_wsel(reg_X_A_o_regfile_wsel),
      .i_regfile_r2sel(reg_X_A_o_regfile_r2sel),
      .i_nzp_data(nzp_data), // TODO
      .o_insn(reg_M_A_o_insn),
      .o_pc(reg_M_A_o_pc),
      .o_stall(reg_M_A_o_stall),
      .o_alu_output(reg_M_A_o_alu_output),
      .o_r2data(reg_M_A_o_r2data),
      .o_nzp_we(reg_M_A_o_nzp_we),
      .o_is_load(reg_M_A_o_is_load),
      .o_is_store(reg_M_A_o_is_store),
      .o_is_cntl(reg_M_A_o_is_cntl),
      .o_regfile_we(reg_M_A_o_regfile_we),
      .o_regfile_wsel(reg_M_A_o_regfile_wsel),
      .o_regfile_r2sel(reg_M_A_o_regfile_r2sel),
      .o_nzp_data(reg_M_A_o_nzp_data)
   );

   wire  reg_M_B_o_nzp_we, reg_M_B_o_is_load, reg_M_B_o_is_store, reg_M_B_o_is_cntl, reg_M_B_o_regfile_we;
   wire [1:0] reg_M_B_o_stall;
   wire [2:0] reg_M_B_o_regfile_wsel, reg_M_B_o_regfile_r2sel, reg_M_B_o_nzp_data;
   wire [15:0] reg_M_B_o_insn, reg_M_B_o_pc, reg_M_B_o_alu_output, reg_M_B_o_r2data;

   pipe_reg_M_B reg_M_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_X_B_o_insn),
      .i_pc(reg_X_B_o_pc),
      .i_stall(reg_X_B_o_stall),
      .i_alu_output(o_result), // TODO
      .i_r2data(i_r2data), // TODO
      .i_nzp_we(reg_X_B_o_nzp_we),
      .i_is_load(reg_X_B_o_is_load),
      .i_is_store(reg_X_B_o_is_store),
      .i_is_cntl(reg_X_B_o_is_cntl),
      .i_regfile_we(reg_X_B_o_regfile_we),
      .i_regfile_wsel(reg_X_B_o_regfile_wsel),
      .i_regfile_r2sel(reg_X_B_o_regfile_r2sel),
      .i_nzp_data(nzp_data), // TODO
      .o_insn(reg_M_B_o_insn),
      .o_pc(reg_M_B_o_pc),
      .o_stall(reg_M_B_o_stall),
      .o_alu_output(reg_M_B_o_alu_output),
      .o_r2data(reg_M_B_o_r2data),
      .o_nzp_we(reg_M_B_o_nzp_we),
      .o_is_load(reg_M_B_o_is_load),
      .o_is_store(reg_M_B_o_is_store),
      .o_is_cntl(reg_M_B_o_is_cntl),
      .o_regfile_we(reg_M_B_o_regfile_we),
      .o_regfile_wsel(reg_M_B_o_regfile_wsel),
      .o_regfile_r2sel(reg_M_B_o_regfile_r2sel),
      .o_nzp_data(reg_M_B_o_nzp_data)
   );


   // Initialize M-W split
   wire  reg_W_A_o_nzp_we, reg_W_A_o_is_load, reg_W_A_o_is_store, reg_W_A_o_is_cntl, reg_W_A_o_regfile_we;
   wire [1:0] reg_W_A_o_stall;
   wire [2:0] reg_W_A_o_nzp_data, reg_W_A_o_regfile_wsel;
   wire [15:0] reg_W_A_o_insn, reg_W_A_o_pc, reg_W_A_o_alu_output, reg_W_A_o_dmem_loaded_data, reg_W_A_o_dmem_towrite;

   pipe_reg_W_A reg_W_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_M_A_o_insn),
      .i_pc(reg_M_A_o_pc),
      .i_stall(reg_M_A_o_stall),
      .i_alu_output(reg_M_A_o_alu_output),
      .i_dmem_loaded_data(i_cur_dmem_data), // TODO
      .i_dmem_towrite(o_dmem_towrite), // TODO
      .i_nzp_we(reg_M_A_o_nzp_we),
      .i_nzp_data(reg_M_A_o_nzp_data),
      .i_is_load(reg_M_A_o_is_load),
      .i_is_store(reg_M_A_o_is_store),
      .i_is_cntl(reg_M_A_o_is_cntl),
      .i_regfile_we(reg_M_A_o_regfile_we),
      .i_regfile_wsel(reg_M_A_o_regfile_wsel),
      .o_insn(reg_W_A_o_insn),
      .o_pc(reg_W_A_o_pc),
      .o_stall(reg_W_A_o_stall),
      .o_alu_output(reg_W_A_o_alu_output),
      .o_dmem_loaded_data(reg_W_A_o_dmem_loaded_data),
      .o_dmem_towrite(reg_W_A_o_dmem_towrite),
      .o_nzp_we(reg_W_A_o_nzp_we),
      .o_nzp_data(reg_W_A_o_nzp_data),
      .o_is_load(reg_W_A_o_is_load),
      .o_is_store(reg_W_A_o_is_store),
      .o_is_cntl(reg_W_A_o_is_cntl),
      .o_regfile_we(reg_W_A_o_regfile_we),
      .o_regfile_wsel(reg_W_A_o_regfile_wsel));

   wire  reg_W_B_o_nzp_we, reg_W_B_o_is_load, reg_W_B_o_is_store, reg_W_B_o_is_cntl, reg_W_B_o_regfile_we;
   wire [1:0] reg_W_B_o_stall;
   wire [2:0] reg_W_B_o_nzp_data, reg_W_B_o_regfile_wsel;
   wire [15:0] reg_W_B_o_insn, reg_W_B_o_pc, reg_W_B_o_alu_output, reg_W_B_o_dmem_loaded_data, reg_W_B_o_dmem_towrite;

   pipe_reg_W_B reg_W_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_M_B_o_insn),
      .i_pc(reg_M_B_o_pc),
      .i_stall(reg_M_B_o_stall),
      .i_alu_output(reg_M_B_o_alu_output),
      .i_dmem_loaded_data(i_cur_dmem_data), // TODO
      .i_dmem_towrite(o_dmem_towrite), // TODO
      .i_nzp_we(reg_M_B_o_nzp_we),
      .i_nzp_data(reg_M_B_o_nzp_data),
      .i_is_load(reg_M_B_o_is_load),
      .i_is_store(reg_M_B_o_is_store),
      .i_is_cntl(reg_M_B_o_is_cntl),
      .i_regfile_we(reg_M_B_o_regfile_we),
      .i_regfile_wsel(reg_M_B_o_regfile_wsel),
      .o_insn(reg_W_B_o_insn),
      .o_pc(reg_W_B_o_pc),
      .o_stall(reg_W_B_o_stall),
      .o_alu_output(reg_W_B_o_alu_output),
      .o_dmem_loaded_data(reg_W_B_o_dmem_loaded_data),
      .o_dmem_towrite(reg_W_B_o_dmem_towrite),
      .o_nzp_we(reg_W_B_o_nzp_we),
      .o_nzp_data(reg_W_B_o_nzp_data),
      .o_is_load(reg_W_B_o_is_load),
      .o_is_store(reg_W_B_o_is_store),
      .o_is_cntl(reg_W_B_o_is_cntl),
      .o_regfile_we(reg_W_B_o_regfile_we),
      .o_regfile_wsel(reg_W_B_o_regfile_wsel));


   /* Add $display(...) calls in the always block below to
    * print out debug information at the end of every cycle.
    *
    * You may also use if statements inside the always block
    * to conditionally print out information.
    */
   always @(posedge gwe) begin
      // $display("%d %h %h %h %h %h", $time, f_pc, d_pc, e_pc, m_pc, test_cur_pc);
      // if (o_dmem_we)
      //   $display("%d STORE %h <= %h", $time, o_dmem_addr, o_dmem_towrite);

      // Start each $display() format string with a %d argument for time
      // it will make the output easier to read.  Use %b, %h, and %d
      // for binary, hex, and decimal output of additional variables.
      // You do not need to add a \n at the end of your format string.
      // $display("%d ...", $time);

      // Try adding a $display() call that prints out the PCs of
      // each pipeline stage in hex.  Then you can easily look up the
      // instructions in the .asm files in test_data.

      // basic if syntax:
      // if (cond) begin
      //    ...;
      //    ...;
      // end

      // Set a breakpoint on the empty $display() below
      // to step through your pipeline cycle-by-cycle.
      // You'll need to rewind the simulation to start
      // stepping from the beginning.

      // You can also simulate for XXX ns, then set the
      // breakpoint to start stepping midway through the
      // testbench.  Use the $time printouts you added above (!)
      // to figure out when your problem instruction first
      // enters the fetch stage.  Rewind your simulation,
      // run it for that many nanoseconds, then set
      // the breakpoint.

      // In the objects view, you can change the values to
      // hexadecimal by selecting all signals (Ctrl-A),
      // then right-click, and select Radix->Hexadecimal.

      // To see the values of wires within a module, select
      // the module in the hierarchy in the "Scopes" pane.
      // The Objects pane will update to display the wires
      // in that module.

      //$display();
   end
endmodule
