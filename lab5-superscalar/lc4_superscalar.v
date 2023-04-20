`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

module lc4_branch_controller(input wire [15:0] insn,
                             input wire [2:0]  o_nzp,
                             input wire        is_branch,
                             input wire        is_control_insn,
                             output wire       take_branch);
    wire [2:0] insn_br = insn[11:9];
    wire nzp_branch_works = |(insn_br & o_nzp);
    
    assign take_branch = (is_branch & nzp_branch_works) | is_control_insn;
endmodule

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
                  input wire         i_is_branch,
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
                  output wire        o_is_branch,
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
   Nbit_reg #(.n(1), .r(0)) is_branch_reg (.in(i_is_branch), .out(o_is_branch), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
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
   
   wire [15:0] pc_minus_one;
   cla16 decrementer(.a(pc_reg_out), .b(16'hffff), .cin(1'b0), .sum(pc_minus_one));

   wire [15:0] pc_minus_two;
   cla16 decrementer2(.a(pc_reg_out), .b(16'hfffe), .cin(1'b0), .sum(pc_minus_two));

   assign pc = load_to_use_A ? pc_minus_two : do_pipe_switch ? pc_minus_one : pc_reg_out; // TODO handle stalls, branches, etc
   assign o_cur_pc = pc;

   // Initialize pipelines in sequence
   
   // Initialize F-D split
   wire [15:0] pc2;
   cla16 incrementer2(.a(pc), .b(16'd2), .cin(1'b0), .sum(pc2));
   wire [15:0] pc1;
   cla16 incrementer1(.a(pc), .b(16'd1), .cin(1'b0), .sum(pc1));

   // Branch predict next program counter
   assign next_pc = take_branch_A ? o_result_A :
                    take_branch_B ? o_result_B :
                                              pc2        ;

   wire [15:0] out_insn_A, out_insn_B, out_pc_A, out_pc_B;
   assign out_insn_A = i_cur_insn_A;
   assign out_insn_B = i_cur_insn_B;
   assign out_pc_A   = pc;
   cla16 pc_incrementer(.a(pc), .b(16'b1), .cin(1'b0), .sum(out_pc_B));

   wire [1:0] next_insn_stall_A, next_insn_stall_B;
   wire take_branch = take_branch_A | take_branch_B;
   assign next_insn_stall_A = take_branch ? 2'd2 : 2'b0 ;
   assign next_insn_stall_B = take_branch ? 2'd2 : 2'b0 ; 
   
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
   wire [2:0] i_rd_A, i_rd_B;
   wire [15:0] o_rs_data_A, o_rt_data_A, o_rs_data_B, o_rt_data_B, i_wdata_A, i_wdata_B; 
   wire i_rd_we_A, i_rd_we_B;  
   lc4_regfile_ss #(.n(16)) regfile(
      .clk(clk),
      .gwe(gwe),
      .rst(rst),
      
      .i_rs_A(r1sel_A),
      .o_rs_data_A(o_rs_data_A),
      .i_rt_A(r2sel_A),
      .o_rt_data_A(o_rt_data_A),

      .i_rd_A(i_rd_A),
      .i_wdata_A(i_wdata_A),
      .i_rd_we_A(i_rd_we_A),
      
      .i_rs_B(r1sel_B),
      .o_rs_data_B(o_rs_data_B),
      .i_rt_B(r2sel_B),
      .o_rt_data_B(o_rt_data_B),

      .i_rd_B(i_rd_B),
      .i_wdata_B(i_wdata_B),
      .i_rd_we_B(i_rd_we_B)
   );

   // Look for D.A->D.B dependency
   wire memory_overload = (is_load_A | is_store_A) & (is_load_B | is_store_B);
   wire D_B_depends_on_D_A = (reg_D_A_o_stall == 2'b0) & 
      (((regfile_we_A) & (((wsel_A == r1sel_B) & r1re_B) | ((wsel_A == r2sel_B) & r2re_B & ~is_store_B))) | 
      (nzp_we_A & is_branch_B) |
      memory_overload); // only B stalls

   wire load_to_use_XA_DA = reg_X_A_o_is_load & reg_X_A_o_stall == 2'b0 & ((reg_X_A_o_regfile_wsel == r1sel_A & r1re_A) | (reg_X_A_o_regfile_wsel == r2sel_A & r2re_A & ~is_store_A) | (is_branch_A & ~reg_X_B_o_nzp_we)) & ((reg_X_A_o_regfile_wsel != reg_X_B_o_regfile_wsel | ~reg_X_B_o_regfile_we ) | reg_X_B_o_stall != 2'b0);
   wire load_to_use_XB_DA = reg_X_B_o_is_load & reg_X_B_o_stall == 2'b0 & ((reg_X_B_o_regfile_wsel == r1sel_A & r1re_A) | (reg_X_B_o_regfile_wsel == r2sel_A & r2re_A & ~is_store_A) | is_branch_A);
   wire load_to_use_XA_DB = reg_X_A_o_is_load & reg_X_A_o_stall == 2'b0 & ((reg_X_A_o_regfile_wsel == r1sel_B & r1re_B) | (reg_X_A_o_regfile_wsel == r2sel_B & r2re_B & ~is_store_B) | (is_branch_B & ~reg_X_B_o_nzp_we)) & (reg_X_A_o_regfile_wsel != reg_X_B_o_regfile_wsel | ~reg_X_B_o_regfile_we);
   wire load_to_use_XB_DB = reg_X_B_o_is_load & reg_X_B_o_stall == 2'b0 & ((reg_X_B_o_regfile_wsel == r1sel_B & r1re_B) | (reg_X_B_o_regfile_wsel == r2sel_B & r2re_B & ~is_store_B) | is_branch_B);
   wire load_to_use_A = load_to_use_XA_DA | load_to_use_XB_DA;
   wire load_to_use_B = load_to_use_XA_DB | load_to_use_XB_DB;

   wire [1:0] reg_X_A_i_stall = (reg_D_A_o_stall == 2'd2 | take_branch) ? 2'd2 : load_to_use_A ? 2'd3 : 2'd0;
   wire [1:0] reg_X_B_i_stall = (reg_D_B_o_stall == 2'd2 | take_branch) ? 2'd2 : (load_to_use_A | D_B_depends_on_D_A) ? 2'd1 : load_to_use_B ? 2'd3 : 2'd0;
   
   wire do_pipe_switch = D_B_depends_on_D_A | load_to_use_B;

   wire  reg_X_A_o_regfile_r1re, reg_X_A_o_regfile_r2re, reg_X_A_o_nzp_we, reg_X_A_o_is_load, reg_X_A_o_is_store, reg_X_A_o_is_cntl, reg_X_A_o_is_branch, reg_X_A_o_select_pc_plus_one, reg_X_A_o_regfile_we;
   wire [1:0] reg_X_A_o_stall;
   wire [2:0] reg_X_A_o_regfile_wsel, reg_X_A_o_regfile_r1sel, reg_X_A_o_regfile_r2sel;
   wire [15:0] reg_X_A_o_insn, reg_X_A_o_pc, reg_X_A_o_r1data, reg_X_A_o_r2data;

   pipe_reg_X reg_X_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_D_A_o_insn),
      .i_pc(reg_D_A_o_pc),
      .i_stall(reg_X_A_i_stall),
      .i_r1data(o_rs_data_A),
      .i_r2data(o_rt_data_A),
      .i_nzp_we(nzp_we_A),
      .i_is_load(is_load_A),
      .i_is_store(is_store_A),
      .i_is_cntl(is_control_insn_A),
      .i_is_branch(is_branch_A),
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
      .o_is_branch(reg_X_A_o_is_branch),
      .o_select_pc_plus_one(reg_X_A_o_select_pc_plus_one),
      .o_regfile_we(reg_X_A_o_regfile_we),
      .o_regfile_wsel(reg_X_A_o_regfile_wsel),
      .o_regfile_r1sel(reg_X_A_o_regfile_r1sel),
      .o_regfile_r2sel(reg_X_A_o_regfile_r2sel)
   );

   wire  reg_X_B_o_regfile_r1re, reg_X_B_o_regfile_r2re, reg_X_B_o_nzp_we, reg_X_B_o_is_load, reg_X_B_o_is_store, reg_X_B_o_is_cntl, reg_X_B_o_is_branch, reg_X_B_o_select_pc_plus_one, reg_X_B_o_regfile_we;
   wire [1:0] reg_X_B_o_stall;
   wire [2:0] reg_X_B_o_regfile_wsel, reg_X_B_o_regfile_r1sel, reg_X_B_o_regfile_r2sel;
   wire [15:0] reg_X_B_o_insn, reg_X_B_o_pc, reg_X_B_o_r1data, reg_X_B_o_r2data;

   pipe_reg_X reg_X_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_D_B_o_insn),
      .i_pc(reg_D_B_o_pc),
      .i_stall(reg_X_B_i_stall),
      .i_r1data(o_rs_data_B),
      .i_r2data(o_rt_data_B),
      .i_nzp_we(nzp_we_B),
      .i_is_load(is_load_B),
      .i_is_store(is_store_B),
      .i_is_cntl(is_control_insn_B),
      .i_is_branch(is_branch_B),
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
      .o_is_branch(reg_X_B_o_is_branch),
      .o_select_pc_plus_one(reg_X_B_o_select_pc_plus_one),
      .o_regfile_we(reg_X_B_o_regfile_we),
      .o_regfile_wsel(reg_X_B_o_regfile_wsel),
      .o_regfile_r1sel(reg_X_B_o_regfile_r1sel),
      .o_regfile_r2sel(reg_X_B_o_regfile_r2sel)
   );

   // Initialize X-M split

   // Determine if we want to bypass NZP bits
   wire [2:0] branch_controller_o_nzp_A =
      reg_M_B_o_nzp_we & reg_M_B_o_stall == 0 ? reg_M_B_o_nzp_data :
      reg_M_A_o_nzp_we & reg_M_A_o_stall == 0 ? reg_M_A_o_nzp_data :
      reg_W_B_o_nzp_we & reg_W_B_o_stall == 0 ? reg_W_B_o_nzp_data :
      reg_W_A_o_nzp_we & reg_W_A_o_stall == 0 ? reg_W_A_o_nzp_data :
                                                o_nzp_reg_data     ;

   wire [2:0] branch_controller_o_nzp_B =
      reg_X_A_o_nzp_we & reg_X_A_o_stall == 0 ? nzp_data_A         :
      reg_M_B_o_nzp_we & reg_M_B_o_stall == 0 ? reg_M_B_o_nzp_data :
      reg_M_A_o_nzp_we & reg_M_A_o_stall == 0 ? reg_M_A_o_nzp_data :
      reg_W_B_o_nzp_we & reg_W_B_o_stall == 0 ? reg_W_B_o_nzp_data :
      reg_W_A_o_nzp_we & reg_W_A_o_stall == 0 ? reg_W_A_o_nzp_data :
                                                o_nzp_reg_data     ;

   wire branch_controller_out_A, branch_controller_out_B;
   
   lc4_branch_controller branch_controller_A(
      .insn(reg_X_A_o_insn), 
      .o_nzp(branch_controller_o_nzp_A), 
      .is_branch(reg_X_A_o_is_branch),
      .is_control_insn(reg_X_A_o_is_cntl), 
      .take_branch(branch_controller_out_A)
   );
   
   lc4_branch_controller branch_controller_B(
     .insn(reg_X_B_o_insn), 
     .o_nzp(branch_controller_o_nzp_B), 
     .is_branch(reg_X_B_o_is_branch),
     .is_control_insn(reg_X_B_o_is_cntl),
     .take_branch(branch_controller_out_B) 
   );

   wire take_branch_A = branch_controller_out_A & reg_X_A_o_stall == 2'b0;
   wire take_branch_B = branch_controller_out_B & reg_X_B_o_stall == 2'b0;

   // wire mx_bypass_r1, mx_bypass_r2;
   // wire wx_bypass_r1, wx_bypass_r2;

   // // Determine when to W-X bypass r1
   // assign wx_bypass_r1 = reg_X_o_regfile_r1re & (i_wsel == reg_X_o_regfile_r1sel) & reg_W_o_regfile_we & reg_W_o_stall == 0;

   // // Determine when to W-X bypass r2
   // assign wx_bypass_r2 = reg_X_o_regfile_r2re & (i_wsel == reg_X_o_regfile_r2sel) & reg_W_o_regfile_we & reg_W_o_stall == 0;
   
   wire MA_XA_bypass_r1 = reg_X_A_o_regfile_r1re & (reg_M_A_o_regfile_wsel == reg_X_A_o_regfile_r1sel) & (~reg_M_A_o_is_load) & reg_M_A_o_regfile_we & reg_M_A_o_stall == 2'b0;
   wire MA_XA_bypass_r2 = reg_X_A_o_regfile_r2re & (reg_M_A_o_regfile_wsel == reg_X_A_o_regfile_r2sel) & (~reg_M_A_o_is_load) & reg_M_A_o_regfile_we & reg_M_A_o_stall == 2'b0;
   wire MB_XA_bypass_r1 = reg_X_A_o_regfile_r1re & (reg_M_B_o_regfile_wsel == reg_X_A_o_regfile_r1sel) & (~reg_M_B_o_is_load) & reg_M_B_o_regfile_we & reg_M_B_o_stall == 2'b0;
   wire MB_XA_bypass_r2 = reg_X_A_o_regfile_r2re & (reg_M_B_o_regfile_wsel == reg_X_A_o_regfile_r2sel) & (~reg_M_B_o_is_load) & reg_M_B_o_regfile_we & reg_M_B_o_stall == 2'b0;
   wire MA_XB_bypass_r1 = reg_X_B_o_regfile_r1re & (reg_M_A_o_regfile_wsel == reg_X_B_o_regfile_r1sel) & (~reg_M_A_o_is_load) & reg_M_A_o_regfile_we & reg_M_A_o_stall == 2'b0;
   wire MA_XB_bypass_r2 = reg_X_B_o_regfile_r2re & (reg_M_A_o_regfile_wsel == reg_X_B_o_regfile_r2sel) & (~reg_M_A_o_is_load) & reg_M_A_o_regfile_we & reg_M_A_o_stall == 2'b0;
   wire MB_XB_bypass_r1 = reg_X_B_o_regfile_r1re & (reg_M_B_o_regfile_wsel == reg_X_B_o_regfile_r1sel) & (~reg_M_B_o_is_load) & reg_M_B_o_regfile_we & reg_M_B_o_stall == 2'b0;
   wire MB_XB_bypass_r2 = reg_X_B_o_regfile_r2re & (reg_M_B_o_regfile_wsel == reg_X_B_o_regfile_r2sel) & (~reg_M_B_o_is_load) & reg_M_B_o_regfile_we & reg_M_B_o_stall == 2'b0;

   wire WA_XA_bypass_r1 = reg_X_A_o_regfile_r1re & (reg_W_A_o_regfile_wsel == reg_X_A_o_regfile_r1sel) & reg_W_A_o_regfile_we & reg_W_A_o_stall == 2'b0;
   wire WA_XA_bypass_r2 = reg_X_A_o_regfile_r2re & (reg_W_A_o_regfile_wsel == reg_X_A_o_regfile_r2sel) & reg_W_A_o_regfile_we & reg_W_A_o_stall == 2'b0;
   wire WB_XA_bypass_r1 = reg_X_A_o_regfile_r1re & (reg_W_B_o_regfile_wsel == reg_X_A_o_regfile_r1sel) & reg_W_B_o_regfile_we & reg_W_B_o_stall == 2'b0;
   wire WB_XA_bypass_r2 = reg_X_A_o_regfile_r2re & (reg_W_B_o_regfile_wsel == reg_X_A_o_regfile_r2sel) & reg_W_B_o_regfile_we & reg_W_B_o_stall == 2'b0;
   wire WA_XB_bypass_r1 = reg_X_B_o_regfile_r1re & (reg_W_A_o_regfile_wsel == reg_X_B_o_regfile_r1sel) & reg_W_A_o_regfile_we & reg_W_A_o_stall == 2'b0;
   wire WA_XB_bypass_r2 = reg_X_B_o_regfile_r2re & (reg_W_A_o_regfile_wsel == reg_X_B_o_regfile_r2sel) & reg_W_A_o_regfile_we & reg_W_A_o_stall == 2'b0;
   wire WB_XB_bypass_r1 = reg_X_B_o_regfile_r1re & (reg_W_B_o_regfile_wsel == reg_X_B_o_regfile_r1sel) & reg_W_B_o_regfile_we & reg_W_B_o_stall == 2'b0;
   wire WB_XB_bypass_r2 = reg_X_B_o_regfile_r2re & (reg_W_B_o_regfile_wsel == reg_X_B_o_regfile_r2sel) & reg_W_B_o_regfile_we & reg_W_B_o_stall == 2'b0;

   wire [15:0] alu_A_r1data, alu_A_r2data, alu_B_r1data, alu_B_r2data;
   assign alu_A_r1data = MB_XA_bypass_r1 ? reg_M_B_o_alu_output : MA_XA_bypass_r1 ? reg_M_A_o_alu_output : WB_XA_bypass_r1 ? writeback_data_B : WA_XA_bypass_r1 ? writeback_data_A : reg_X_A_o_r1data;
   assign alu_A_r2data = MB_XA_bypass_r2 ? reg_M_B_o_alu_output : MA_XA_bypass_r2 ? reg_M_A_o_alu_output : WB_XA_bypass_r2 ? writeback_data_B : WA_XA_bypass_r2 ? writeback_data_A : reg_X_A_o_r2data;
   assign alu_B_r1data = MB_XB_bypass_r1 ? reg_M_B_o_alu_output : MA_XB_bypass_r1 ? reg_M_A_o_alu_output : WB_XB_bypass_r1 ? writeback_data_B : WA_XB_bypass_r1 ? writeback_data_A : reg_X_B_o_r1data;
   assign alu_B_r2data = MB_XB_bypass_r2 ? reg_M_B_o_alu_output : MA_XB_bypass_r2 ? reg_M_A_o_alu_output : WB_XB_bypass_r2 ? writeback_data_B : WA_XB_bypass_r2 ? writeback_data_A : reg_X_B_o_r2data;
   
   // Initialize ALUs
   wire [15:0] o_result_A, o_result_B;
   lc4_alu alu_A(.i_insn(reg_X_A_o_insn), .i_pc(reg_X_A_o_pc), .i_r1data(alu_A_r1data), .i_r2data(alu_A_r2data), .o_result(o_result_A));
   lc4_alu alu_B(.i_insn(reg_X_B_o_insn), .i_pc(reg_X_B_o_pc), .i_r1data(alu_B_r1data), .i_r2data(alu_B_r2data), .o_result(o_result_B));

   // Initialize NZP data
   wire [2:0] nzp_data_A, nzp_data_B;
   assign nzp_data_A = $signed(o_result_A) < 0 ? 3'b100  :
                       $signed(o_result_A) == 0 ? 3'b010 :
                                                  3'b001 ;
   assign nzp_data_B = $signed(o_result_B) < 0 ? 3'b100  :
                       $signed(o_result_B) == 0 ? 3'b010 :
                                                  3'b001 ;

   wire  reg_M_A_o_nzp_we, reg_M_A_o_is_load, reg_M_A_o_is_store, reg_M_A_o_is_cntl, reg_M_A_o_regfile_we;
   wire [1:0] reg_M_A_o_stall;
   wire [2:0] reg_M_A_o_regfile_wsel, reg_M_A_o_regfile_r2sel, reg_M_A_o_nzp_data;
   wire [15:0] reg_M_A_o_insn, reg_M_A_o_pc, reg_M_A_o_alu_output, reg_M_A_o_r2data;

   pipe_reg_M reg_M_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_X_A_o_insn),
      .i_pc(reg_X_A_o_pc),
      .i_stall(reg_X_A_o_stall),
      .i_alu_output(o_result_A), 
      .i_r2data(alu_A_r2data),
      .i_nzp_we(reg_X_A_o_nzp_we),
      .i_is_load(reg_X_A_o_is_load),
      .i_is_store(reg_X_A_o_is_store),
      .i_is_cntl(reg_X_A_o_is_cntl),
      .i_regfile_we(reg_X_A_o_regfile_we),
      .i_regfile_wsel(reg_X_A_o_regfile_wsel),
      .i_regfile_r2sel(reg_X_A_o_regfile_r2sel),
      .i_nzp_data(nzp_data_A),
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

   pipe_reg_M reg_M_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_X_B_o_insn),
      .i_pc(reg_X_B_o_pc),
      .i_stall(take_branch_A ? 2'd2 : reg_X_B_o_stall != 2'b0 ? reg_X_B_o_stall : 2'b0),
      .i_alu_output(o_result_B),
      .i_r2data(alu_B_r2data),
      .i_nzp_we(reg_X_B_o_nzp_we),
      .i_is_load(reg_X_B_o_is_load),
      .i_is_store(reg_X_B_o_is_store),
      .i_is_cntl(reg_X_B_o_is_cntl),
      .i_regfile_we(reg_X_B_o_regfile_we),
      .i_regfile_wsel(reg_X_B_o_regfile_wsel),
      .i_regfile_r2sel(reg_X_B_o_regfile_r2sel),
      .i_nzp_data(nzp_data_B),
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

   wire WA_MA_bypass_r2 = reg_W_A_o_regfile_wsel == reg_M_A_o_regfile_r2sel & reg_W_A_o_stall == 2'b0 & reg_W_A_o_regfile_we & reg_M_A_o_is_store;
   wire WB_MA_bypass_r2 = reg_W_B_o_regfile_wsel == reg_M_A_o_regfile_r2sel & reg_W_B_o_stall == 2'b0 & reg_W_B_o_regfile_we & reg_M_A_o_is_store;
   wire WA_MB_bypass_r2 = reg_W_A_o_regfile_wsel == reg_M_B_o_regfile_r2sel & reg_W_A_o_stall == 2'b0 & reg_W_A_o_regfile_we & reg_M_B_o_is_store;
   wire WB_MB_bypass_r2 = reg_W_B_o_regfile_wsel == reg_M_B_o_regfile_r2sel & reg_W_B_o_stall == 2'b0 & reg_W_B_o_regfile_we & reg_M_B_o_is_store;
   wire MA_MB_bypass_r2 = reg_M_A_o_regfile_wsel == reg_M_B_o_regfile_r2sel & reg_M_A_o_stall == 2'b0 & reg_M_A_o_regfile_we & reg_M_B_o_is_store;
   
   assign o_dmem_addr = reg_M_A_o_is_store | reg_M_A_o_is_load ? reg_M_A_o_alu_output : reg_M_B_o_is_store | reg_M_B_o_is_load ? reg_M_B_o_alu_output : 16'b0;
   assign o_dmem_we = (reg_M_A_o_is_store & reg_M_A_o_stall == 2'b0) | (reg_M_B_o_is_store & reg_M_B_o_stall == 2'b0) ;
   wire [15:0] M_W_dmem_towrite = reg_M_A_o_is_store ? (
         WB_MA_bypass_r2 ? writeback_data_B :
         WA_MA_bypass_r2 ? writeback_data_A :
                           reg_M_A_o_r2data
      ) : reg_M_B_o_is_store ? (
         MA_MB_bypass_r2 ? reg_M_A_o_alu_output :
         WB_MB_bypass_r2 ? writeback_data_B :
         WA_MB_bypass_r2 ? writeback_data_A :
                           reg_M_B_o_r2data      ) : 16'b0;
   assign o_dmem_towrite = M_W_dmem_towrite;

   // wire test_dmem_we_A = reg_W_A_o_is_load | reg_W_A_o_is_store;      // data memory write enable
   // wire test_dmem_we_B = reg_W_B_o_is_load | reg_W_B_o_is_store;
   // wire test_dmem_addr_A = reg_W_A_o_is_store | reg_W_A_o_is_load ? reg_W_A_o_alu_output : 16'b0;    // address to read/write from/to memory
   // wire test_dmem_addr_B = reg_W_B_o_is_store | reg_W_B_o_is_load ? reg_W_B_o_alu_output : 16'b0;
   // wire test_dmem_data_A = reg_W_A_o_is_load ? reg_W_A_o_dmem_loaded_data : reg_W_A_o_is_store ? reg_W_A_o_alu_output : 16'b0;   // data to read/write from/to memory
   // wire test_dmem_data_B = reg_W_B_o_is_load ? reg_W_B_o_dmem_loaded_data : reg_W_B_o_is_store ? reg_W_B_o_alu_output : 16'b0;


   pipe_reg_W reg_W_A(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_M_A_o_insn),
      .i_pc(reg_M_A_o_pc),
      .i_stall(reg_M_A_o_stall),
      .i_alu_output(reg_M_A_o_alu_output),
      .i_dmem_loaded_data(i_cur_dmem_data), // TODO
      .i_dmem_towrite(M_W_dmem_towrite), 
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

   pipe_reg_W reg_W_B(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_M_B_o_insn),
      .i_pc(reg_M_B_o_pc),
      .i_stall(reg_M_B_o_stall),
      .i_alu_output(reg_M_B_o_alu_output),
      .i_dmem_loaded_data(i_cur_dmem_data), // TODO
      .i_dmem_towrite(M_W_dmem_towrite), 
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

      // Initialize W-F wrap-around split
      wire [15:0] pc2_wrap_A;
      cla16 pc2_wrap_cla_A(
         .a(reg_W_A_o_pc),
         .b(16'b0),
         .cin(1'b1),
         .sum(pc2_wrap_A)
      );
      wire [15:0] pc2_wrap_B;
      cla16 pc2_wrap_cla_B(
         .a(reg_W_B_o_pc),
         .b(16'b0),
         .cin(1'b1),
         .sum(pc2_wrap_B)
      );

      wire [15:0] writeback_data_A, writeback_data_B;
      assign writeback_data_A = reg_W_A_o_is_load ? reg_W_A_o_dmem_loaded_data :
                                reg_W_A_o_is_cntl ? pc2_wrap_A                 :
                                                    reg_W_A_o_alu_output       ;
      assign writeback_data_B = reg_W_B_o_is_load ? reg_W_B_o_dmem_loaded_data :
                                reg_W_B_o_is_cntl ? pc2_wrap_B                 :
                                                    reg_W_B_o_alu_output       ;

      wire [2:0] wrap_nzp_data_A, wrap_nzp_data_B;
      assign wrap_nzp_data_A = $signed(writeback_data_A) <  0 ? 3'b100 :
                               $signed(writeback_data_A) == 0 ? 3'b010 :
                                                                3'b001 ;
      assign wrap_nzp_data_B = $signed(writeback_data_B) <  0 ? 3'b100 :
                               $signed(writeback_data_B) == 0 ? 3'b010 :
                                                                3'b001 ;

     wire wrap_nzp_we_A, wrap_nzp_we_B;
     assign wrap_nzp_we_A = reg_W_A_o_nzp_we & reg_W_A_o_stall == 2'b0;
     assign wrap_nzp_we_B = reg_W_B_o_nzp_we & reg_W_B_o_stall == 2'b0;
     wire [2:0] o_nzp_reg_data;
     wire [2:0] i_nzp_reg_data = wrap_nzp_we_B ? wrap_nzp_data_B :
                                 wrap_nzp_we_A ? wrap_nzp_data_A :
                                                    3'b0 ;
     wire       wrap_nzp_we = wrap_nzp_we_A | wrap_nzp_we_B;
     Nbit_reg #(.n(3), .r(0)) nzp_reg(.in(i_nzp_reg_data), .out(o_nzp_reg_data), .clk(clk), .we(wrap_nzp_we), .gwe(gwe), .rst(rst));

      // Wire up writeback
      assign i_rd_A = reg_W_A_o_regfile_wsel;
      assign i_wdata_A = writeback_data_A;
      assign i_rd_we_A = reg_W_A_o_regfile_we & reg_W_A_o_stall == 2'b0;

      assign i_rd_B = reg_W_B_o_regfile_wsel;
      assign i_wdata_B = writeback_data_B;
      assign i_rd_we_B = reg_W_B_o_regfile_we & reg_W_B_o_stall == 2'b0;

      assign test_stall_A = reg_W_A_o_stall;        // is this a stall cycle?  (0: no stall,
      assign test_stall_B = reg_W_B_o_stall;        // 1: pipeline stall, 2: branch stall, 3: load stall)

      assign test_cur_pc_A = reg_W_A_o_pc;       // program counter
      assign test_cur_pc_B = reg_W_B_o_pc;
      assign test_cur_insn_A = reg_W_A_o_insn;     // instruction bits
      assign test_cur_insn_B = reg_W_B_o_insn;
      assign test_regfile_we_A = reg_W_A_o_regfile_we;   // register file write-enable
      assign test_regfile_we_B = reg_W_B_o_regfile_we;
      assign test_regfile_wsel_A = reg_W_A_o_regfile_wsel; // which register to write
      assign test_regfile_wsel_B = reg_W_B_o_regfile_wsel;
      assign test_regfile_data_A = writeback_data_A;  // data to write to register file
      assign test_regfile_data_B = writeback_data_B; 
      assign test_nzp_we_A = reg_W_A_o_nzp_we;       // nzp register write enable
      assign test_nzp_we_B = reg_W_B_o_nzp_we;
      assign test_nzp_new_bits_A = wrap_nzp_data_A; // new nzp bits
      assign test_nzp_new_bits_B = wrap_nzp_data_B;
      assign test_dmem_we_A = reg_W_A_o_is_store;      // data memory write enable
      assign test_dmem_we_B = reg_W_B_o_is_store;
      assign test_dmem_addr_A = reg_W_A_o_is_store | reg_W_A_o_is_load ? reg_W_A_o_alu_output : 16'b0;    // address to read/write from/to memory
      assign test_dmem_addr_B = reg_W_B_o_is_store | reg_W_B_o_is_load ? reg_W_B_o_alu_output : 16'b0;
      assign test_dmem_data_A = reg_W_A_o_is_load ? reg_W_A_o_dmem_loaded_data : reg_W_A_o_is_store ? reg_W_A_o_dmem_towrite : 16'b0;   // data to read/write from/to memory
      assign test_dmem_data_B = reg_W_B_o_is_load ? reg_W_B_o_dmem_loaded_data : reg_W_B_o_is_store ? reg_W_B_o_dmem_towrite : 16'b0;


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

      // $display("PC: %h", pc);
      // $display("Next PC: %h", next_pc);
      // $display("stall_A: %d, stall_B: %d", reg_W_A_o_stall, reg_W_B_o_stall);
      // $display("F -> PC: %h", pc);
      // $display("D_A -> PC: %h, INSN: %h, stall: %d, r1_sel: %d, r2_sel: %d, wsel: %d, we: %d, do_pipe_switch: %b, r1re: %b, r2re: %b",
      //    reg_D_A_o_pc,
      //    reg_D_A_o_insn,
      //    reg_X_A_i_stall,
      //    r1sel_A,
      //    r2sel_A,
      //    wsel_A,
      //    regfile_we_A,
      //    do_pipe_switch,
      //    r1re_A,
      //    r2re_A);
      // $display("D_B -> PC: %h, INSN: %h, stall: %d, r1_sel: %d, r2_sel: %d, wsel: %d, we: %d, do_pipe_switch: %b, r1re: %b, r2re: %b",
      //    reg_D_B_o_pc,
      //    reg_D_B_o_insn,
      //    reg_X_B_i_stall,
      //    r1sel_B,
      //    r2sel_B,
      //    wsel_B,
      //    regfile_we_B,
      //    do_pipe_switch,
      //    r1re_B,
      //    r2re_B);
      // $display("X_A -> PC: %h, INSN: %h, stall: %d, r1_data: %h, alu_r1: %h, r1_sel: %d, r2_data: %h, alu_r2: %h, r2_sel: %d, w_sel: %d, take_branch: %b, nzp_we: %b, nzp_data: %b, branch_nzp_data: %b",
      //    reg_X_A_o_pc,
      //    reg_X_A_o_insn,
      //    reg_X_A_o_stall,
      //    reg_X_A_o_r1data,
      //    alu_A_r1data,
      //    reg_X_A_o_regfile_r1sel,
      //    reg_X_A_o_r2data,
      //    alu_A_r2data,
      //    reg_X_A_o_regfile_r2sel,
      //    reg_X_A_o_regfile_wsel,
      //    take_branch_A,
      //    reg_X_A_o_nzp_we,
      //    nzp_data_A,
      //    branch_controller_o_nzp_A
      // );
      // $display("X_B -> PC: %h, INSN: %h, stall: %d, r1_data: %h, alu_r1: %h, r1_sel: %d, r2_data: %h, alu_r2: %h, r2_sel: %d, w_sel: %d, take_branch: %b, nzp_we: %b, nzp_data: %b, branch_nzp_data: %b",
      //    reg_X_B_o_pc,
      //    reg_X_B_o_insn,
      //    reg_X_B_o_stall,
      //    reg_X_B_o_r1data,
      //    alu_B_r1data,
      //    reg_X_B_o_regfile_r1sel,
      //    reg_X_B_o_r2data,
      //    alu_B_r2data,
      //    reg_X_B_o_regfile_r2sel,
      //    reg_X_B_o_regfile_wsel,
      //    take_branch_B,
      //    reg_X_B_o_nzp_we,
      //    nzp_data_B,
      //    branch_controller_o_nzp_B
      // );
      // $display("MA_XA_bypass_r1: %b, MA_XA_bypass_r2: %b, MB_XA_bypass_r1: %b, MB_XA_bypass_r2: %b, MA_XB_bypass_r1: %b, MA_XB_bypass_r2: %b, MB_XB_bypass_r1: %b, MB_XB_bypass_r2: %b, WA_XA_bypass_r1: %b, WA_XA_bypass_r2: %b, WB_XA_bypass_r1: %b, WB_XA_bypass_r2: %b, WA_XB_bypass_r1: %b, WA_XB_bypass_r2: %b, WB_XB_bypass_r1: %b, WB_XB_bypass_r2: %b",
      //    MA_XA_bypass_r1,
      //    MA_XA_bypass_r2,
      //    MB_XA_bypass_r1,
      //    MB_XA_bypass_r2,
      //    MA_XB_bypass_r1,
      //    MA_XB_bypass_r2,
      //    MB_XB_bypass_r1,
      //    MB_XB_bypass_r2,
      //    WA_XA_bypass_r1,
      //    WA_XA_bypass_r2,
      //    WB_XA_bypass_r1,
      //    WB_XA_bypass_r2,
      //    WA_XB_bypass_r1,
      //    WA_XB_bypass_r2,
      //    WB_XB_bypass_r1,
      //    WB_XB_bypass_r2
      // );
      // $display("M_A -> PC: %h, INSN: %h, stall: %d, alu_out: %h, w_sel: %d, w_we: %b, nzp_we: %b, nzp_data: %b, i_cur_dmem_data: %h",
      //    reg_M_A_o_pc,
      //    reg_M_A_o_insn,
      //    reg_M_A_o_stall,
      //    reg_M_A_o_alu_output,
      //    reg_M_A_o_regfile_wsel,
      //    reg_M_A_o_regfile_we,
      //    reg_M_A_o_nzp_we,
      //    reg_M_A_o_nzp_data,
      //    i_cur_dmem_data
      // );
      // $display("M_B -> PC: %h, INSN: %h, stall: %d, alu_out: %h, w_sel: %d, w_we: %b, nzp_we: %b, nzp_data: %b, i_cur_dmem_data: %h",
      //    reg_M_B_o_pc,
      //    reg_M_B_o_insn,
      //    reg_M_B_o_stall,
      //    reg_M_B_o_alu_output,
      //    reg_M_B_o_regfile_wsel,
      //    reg_M_B_o_regfile_we,
      //    reg_M_B_o_nzp_we,
      //    reg_M_B_o_nzp_data,
      //    i_cur_dmem_data
      // );
      // $display("W_A -> PC: %h, INSN: %h, stall: %d, writeback_data: %h, writeback_we: %b, w_sel: %d, nzp_we: %b, nzp_data: %b",
      //    reg_W_A_o_pc,
      //    reg_W_A_o_insn,
      //    reg_W_A_o_stall,
      //    writeback_data_A,
      //    i_rd_we_A,
      //    i_rd_A,
      //    reg_W_A_o_nzp_we,
      //    wrap_nzp_data_A
      // );
      // $display("W_B -> PC: %h, INSN: %h, stall: %d, writeback_data: %h, writeback_we: %b, w_sel: %d, nzp_we: %b, nzp_data: %b",
      //    reg_W_B_o_pc,
      //    reg_W_B_o_insn,
      //    reg_W_B_o_stall,
      //    writeback_data_B,
      //    i_rd_we_B,
      //    i_rd_B,
      //    reg_W_B_o_nzp_we,
      //    wrap_nzp_data_B
      // );

      // $display("\n");

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
