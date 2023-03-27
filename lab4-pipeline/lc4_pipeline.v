/* TODO: name and PennKeys of all group members here */

`timescale 1ns / 1ps

// disable implicit wire declaration
`default_nettype none

module lc4_branch_controller(input wire [15:0] insn,
                             input wire [2:0]  o_nzp,
                             input wire        is_branch,
                             input wire        is_control_insn,
                             output wire take_branch);
    wire [2:0] insn_br = insn[11:9];
    wire nzp_branch_works = |(insn_br & o_nzp);
    
    assign take_branch = (is_branch & nzp_branch_works) | is_control_insn;
endmodule

module lc4_data_controller(input wire [15:0] r1data,
                           input wire [15:0] r2data,
                           input wire [15:0] insn,
                           input wire [15:0] i_pc1,
                           input wire [15:0] dmem_load,
                           input wire        is_load,
                           input wire        take_branch,
                           input wire        select_pc_plus_one,
                           output wire [15:0] wdata,
                           output wire [15:0] o_pc,
                           output wire [15:0] dmem_addr,
                           output wire [15:0] dmem_store);
    wire [15:0] o_alu;
    lc4_alu alu(.i_insn(insn), .i_pc(i_pc1), .i_r1data(r1data), .i_r2data(r2data), .o_result(o_alu));

    // Determine branch
    wire [15:0] pc_inc;
    cla16 incrementer(.a(i_pc1), .b(16'b0), .cin(1'b1), .sum(pc_inc));

    assign o_pc = take_branch ? o_alu : pc_inc;

    wire [15:0] o_reg = select_pc_plus_one ? pc_inc : o_alu;
    assign dmem_addr = o_reg;
    assign dmem_store = r2data;

    assign wdata = is_load ? dmem_load : o_reg;
endmodule

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
                  input wire         i_take_branch,
                  input wire         i_select_pc_plus_one,
                  input wire         i_regfile_we,
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
                  output wire        o_take_branch,
                  output wire        o_select_pc_plus_one,
                  output wire        o_regfile_we,
                  output wire [2:0]  o_regfile_wsel,
                  output wire [2:0]  o_regfile_r1sel,
                  output wire [2:0]  o_regfile_r2sel);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) r1data_reg (.in(i_r1data), .out(o_r1data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) r2data_reg (.in(i_r2data), .out(o_r2data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(1), .r(0)) nzp_we_reg (.in(i_nzp_we), .out(o_nzp_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_load_reg (.in(i_is_load), .out(o_is_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_store_reg (.in(i_is_store), .out(o_is_store), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
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
                  input wire [15:0]  i_dmem_load,
                  input wire         i_nzp_we,
                  input wire [2:0]   i_nzp_data,
                  input wire         i_is_load,
                  input wire         i_regfile_we,
                  input wire [2:0]   i_regfile_wsel,
                  output wire [15:0] o_insn,
                  output wire [15:0] o_pc,
                  output wire [1:0]  o_stall,
                  output wire [15:0] o_alu_output,
                  output wire [15:0] o_dmem_load,
                  output wire        o_nzp_we,
                  output wire [2:0]  o_nzp_data,
                  output wire        o_is_load,
                  output wire        o_regfile_we,
                  output wire [2:0]  o_regfile_wsel);
   Nbit_reg #(.n(16), .r(0)) insn_reg (.in(i_insn), .out(o_insn), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) pc_reg (.in(i_pc), .out(o_pc), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) alu_output_reg (.in(i_alu_output), .out(o_alu_output), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(16), .r(0)) dmem_load_reg (.in(i_dmem_load), .out(o_dmem_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   
   Nbit_reg #(.n(1), .r(0)) nzp_we_reg (.in(i_nzp_we), .out(o_nzp_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) is_load_reg (.in(i_is_load), .out(o_is_load), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(1), .r(0)) regfile_we_reg (.in(i_regfile_we), .out(o_regfile_we), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(3), .r(0)) regfile_wsel_reg (.in(i_regfile_wsel), .out(o_regfile_wsel), .clk(clk), .we(we), .gwe(gwe), .rst(rst));

   Nbit_reg #(.n(3), .r(0)) nzp_data_reg (.in(i_nzp_data), .out(o_nzp_data), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
   Nbit_reg #(.n(2), .r(2)) stall_reg (.in(i_stall), .out(o_stall), .clk(clk), .we(we), .gwe(gwe), .rst(rst));
endmodule

module lc4_processor
   (input  wire        clk,                // main clock
    input wire         rst, // global reset
    input wire         gwe, // global we for single-step clock
                                    
    output wire [15:0] o_cur_pc, // Address to read from instruction memory
    input wire [15:0]  i_cur_insn, // Output of instruction memory
    output wire [15:0] o_dmem_addr, // Address to read/write from/to data memory
    input wire [15:0]  i_cur_dmem_data, // Output of data memory
    output wire        o_dmem_we, // Data memory write enable
    output wire [15:0] o_dmem_towrite, // Value to write to data memory
   
    output wire [1:0]  test_stall, // Testbench: is this is stall cycle? (don't compare the test values)
    output wire [15:0] test_cur_pc, // Testbench: program counter
    output wire [15:0] test_cur_insn, // Testbench: instruction bits
    output wire        test_regfile_we, // Testbench: register file write enable
    output wire [2:0]  test_regfile_wsel, // Testbench: which register to write in the register file 
    output wire [15:0] test_regfile_data, // Testbench: value to write into the register file
    output wire        test_nzp_we, // Testbench: NZP condition codes write enable
    output wire [2:0]  test_nzp_new_bits, // Testbench: value to write to NZP bits
    output wire        test_dmem_we, // Testbench: data memory write enable
    output wire [15:0] test_dmem_addr, // Testbench: address to read/write memory
    output wire [15:0] test_dmem_data, // Testbench: value read/writen from/to memory

    input wire [7:0]   switch_data, // Current settings of the Zedboard switches
    output wire [7:0]  led_data // Which Zedboard LEDs should be turned on?
    );
   
   /*** YOUR CODE HERE ***/
   // Always execute one instruction each cycle (test_stall will get used in your pipelined processor)
   wire [15:0]   pc;      // Current program counter (read out from pc_reg)
   wire [15:0]   next_pc; // Next program counter (you compute this and feed it into next_pc)

   // Program counter register, starts at 8200h at bootup
   Nbit_reg #(.n(16), .r(16'h8200)) pc_reg (.in(next_pc), .out(pc), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));
   wire [15:0] flush;
   wire [15:0] flush_sum, next_flush;
   cla16 flush_cla(.a(flush), .b(16'hFFFF), .cin(1'b0), .sum(flush_sum));
   wire flush_reg_we = flush > 0;
   assign next_flush = flush_sum;
   Nbit_reg #(.n(16), .r(16'b100)) flush_reg (.in(next_flush), .out(flush), .clk(clk), .we(flush_reg_we), .gwe(gwe), .rst(rst));
   
   // Initialize pipelines in sequence

   // Initialize F-D split
   wire [15:0] pc1;
   cla16 incrementer(.a(pc), .b(16'b1), .cin(1'b0), .sum(pc1));

   // Branch predict next program counter
   // TODO insert noop on stall
   assign next_pc = reg_D_o_stall == 2'b11 ? pc       : // Check for LOAD to USE penalty
                    reg_X_o_take_branch    ? o_result : // Check for branch taken
                                             pc1      ; // Check for normal instruction or branch prediction
   
   wire [15:0] out_insn, out_pc;
   assign out_insn = i_cur_insn;
   assign out_pc   = pc;
   wire [15:0] reg_D_o_insn, reg_D_o_pc;
   wire [1:0] reg_D_o_stall;

   wire [1:0] next_insn_stall = load_to_use_stall                   ? 2'd3 :
                                (take_branch | reg_X_o_take_branch) ? 2'd2 :
                                                                     2'd0 ;
   pipe_reg_D reg_D(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(out_insn),  // Input wire to module
      .i_pc(out_pc),          // Input wire incremented from pc_reg above
      .i_stall(next_insn_stall),
      .o_insn(reg_D_o_insn),
      .o_pc(reg_D_o_pc),
      .o_stall(reg_D_o_stall));

   // Initialize D-X split
   wire [2:0] r1sel, r2sel, wsel;
   wire r1re, r2re;
   wire regfile_we, is_load, is_store, is_branch, is_control_insn, nzp_we, select_pc_plus_one;
   lc4_decoder decoder(
      .insn(reg_D_o_insn), // Only input wire
      .r1sel(r1sel),
      .r1re(r1re),         // Unused
      .r2sel(r2sel),
      .r2re(r2re),         // Unused
      .wsel(wsel),
      .regfile_we(regfile_we),
      .nzp_we(nzp_we),
      .select_pc_plus_one(select_pc_plus_one),
      .is_load(is_load),
      .is_store(is_store),
      .is_branch(is_branch),
      .is_control_insn(is_control_insn));

   wire load_to_use_stall = reg_X_o_is_load & (
      r1sel == reg_X_o_regfile_wsel | (
         r2sel == reg_X_o_regfile_wsel &
         (!is_store)
      ) | is_branch
   );


   wire take_branch;
   wire [2:0] branch_controller_o_nzp = 
      reg_X_o_nzp_we ? nzp_data         :
      reg_M_o_nzp_we ? reg_M_o_nzp_data :
      reg_W_o_nzp_we ? reg_W_o_nzp_data :
                       o_nzp_reg_data   ;
   lc4_branch_controller branch_controller(
      .insn(reg_D_o_insn),               // 16-bit input
      .o_nzp(branch_controller_o_nzp),   // 3-bit input
      .is_branch(is_branch),             // 1-bit input
      .is_control_insn(is_control_insn), // 1-bit input
      .take_branch(take_branch)          // 1-bit output
   );

   wire i_rd_we;
   wire [15:0] o_rs_data, o_rt_data, i_wdata;
   wire [2:0] i_wsel;
   lc4_regfile #(.n(16)) regfile(
      .clk(clk),
      .gwe(gwe),
      .rst(rst),
      .i_rs(r1sel),
      .o_rs_data(o_rs_data),
      .i_rt(r2sel),
      .o_rt_data(o_rt_data),
      .i_rd(i_wsel),     // wsel from instruction in W split
      .i_wdata(i_wdata), // wdata from instruction in W split
      .i_rd_we(i_rd_we)  // Regfile write enable from instruction in W split
   );
   
   wire wd_bypass_r1 = (r1sel == reg_W_o_regfile_wsel) & reg_W_o_regfile_we;
   wire wd_bypass_r2 = (r2sel == reg_W_o_regfile_wsel) & reg_W_o_regfile_we;

   wire [15:0] rs_data, rt_data;
   assign rs_data = wd_bypass_r1 ? i_wdata : o_rs_data;
   assign rt_data = wd_bypass_r2 ? i_wdata : o_rt_data;

   wire [15:0] reg_X_o_insn, reg_X_o_pc, reg_X_o_r1data, reg_X_o_r2data;
   wire reg_X_o_is_load, reg_X_o_is_store, reg_X_o_take_branch, 
      reg_X_o_select_pc_plus_one, reg_X_o_regfile_we, reg_X_o_nzp_we;
   wire [2:0] reg_X_o_regfile_wsel, reg_X_o_regfile_r1sel, reg_X_o_regfile_r2sel;
   wire [1:0] reg_X_o_stall;
   pipe_reg_X reg_X(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_D_o_insn),
      .i_pc(reg_D_o_pc),
      .i_stall(reg_D_o_stall),
      .i_r1data(rs_data),
      .i_r2data(rt_data),
      .i_nzp_we(nzp_we),
      .i_is_load(is_load),
      .i_is_store(is_store),
      .i_take_branch(take_branch),
      .i_select_pc_plus_one(select_pc_plus_one),
      .i_regfile_we(regfile_we),
      .i_regfile_wsel(wsel),
      .i_regfile_r1sel(r1sel),
      .i_regfile_r2sel(r2sel),
      .o_insn(reg_X_o_insn),
      .o_pc(reg_X_o_pc),
      .o_stall(reg_X_o_stall),
      .o_r1data(reg_X_o_r1data),
      .o_r2data(reg_X_o_r2data),
      .o_nzp_we(reg_X_o_nzp_we),
      .o_is_load(reg_X_o_is_load),
      .o_is_store(reg_X_o_is_store),
      .o_take_branch(reg_X_o_take_branch),
      .o_select_pc_plus_one(reg_X_o_select_pc_plus_one),
      .o_regfile_we(reg_X_o_regfile_we),
      .o_regfile_wsel(reg_X_o_regfile_wsel),
      .o_regfile_r1sel(reg_X_o_regfile_r1sel),
      .o_regfile_r2sel(reg_X_o_regfile_r2sel));

   // Initialize X-M split
   wire [15:0] i_r1data, i_r2data;
   wire mx_bypass_r1, mx_bypass_r2;
   wire wx_bypass_r1, wx_bypass_r2;

   // Determine when to W-X bypass r1
   assign wx_bypass_r1 = (i_wsel == reg_X_o_regfile_r1sel) & reg_W_o_regfile_we;

   // Determine when to W-X bypass r2
   assign wx_bypass_r2 = (i_wsel == reg_X_o_regfile_r2sel) & reg_W_o_regfile_we;
   
   // Determine when to M-X bypass r1
   assign mx_bypass_r1 = (reg_M_o_regfile_wsel == reg_X_o_regfile_r1sel) & (!reg_M_o_is_load) & reg_M_o_regfile_we; // TODO

   // Determine when to M-X bypass r2
   assign mx_bypass_r2 = (reg_M_o_regfile_wsel == reg_X_o_regfile_r2sel) & (!reg_M_o_is_load) & reg_M_o_regfile_we; // TODO

   assign i_r1data = mx_bypass_r1 ? reg_M_o_alu_output :
                     wx_bypass_r1 ? i_wdata            :
                                    reg_X_o_r1data     ;

   assign i_r2data = mx_bypass_r2 ? reg_M_o_alu_output :
                     wx_bypass_r2 ? i_wdata            :
                                    reg_X_o_r2data     ;

   wire [15:0] o_result;
   lc4_alu alu(
      .i_insn(reg_X_o_insn),
      .i_pc(reg_X_o_pc),
      .i_r1data(i_r1data),
      .i_r2data(i_r2data),
      .o_result(o_result));

   wire [15:0] reg_M_o_alu_output, reg_M_o_r2data, reg_M_o_insn, reg_M_o_pc;
   wire reg_M_o_is_load, reg_M_o_is_store, reg_M_o_regfile_we, reg_M_o_nzp_we;
   wire [2:0] reg_M_o_regfile_wsel, reg_M_o_regfile_r2sel, reg_M_o_nzp_data;
   wire [1:0] reg_M_o_stall;
   wire [2:0] nzp_data;
   assign nzp_data = $signed(o_result) <  0 ? 3'b100 :
                     $signed(o_result) == 0 ? 3'b010 :
                                             3'b001 ;
   pipe_reg_M reg_M(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_X_o_insn),
      .i_pc(reg_X_o_pc),
      .i_stall(reg_X_o_stall),
      .i_alu_output(o_result),
      .i_r2data(reg_X_o_r2data),
      .i_nzp_we(reg_X_o_nzp_we),
      .i_is_load(reg_X_o_is_load),
      .i_is_store(reg_X_o_is_store),
      .i_regfile_we(reg_X_o_regfile_we),
      .i_regfile_wsel(reg_X_o_regfile_wsel),
      .i_regfile_r2sel(reg_X_o_regfile_r2sel),
      .i_nzp_data(nzp_data),
      .o_insn(reg_M_o_insn),
      .o_pc(reg_M_o_pc),
      .o_stall(reg_M_o_stall),
      .o_alu_output(reg_M_o_alu_output),
      .o_r2data(reg_M_o_r2data),
      .o_nzp_we(reg_M_o_nzp_we),
      .o_is_load(reg_M_o_is_load),
      .o_is_store(reg_M_o_is_store),
      .o_regfile_we(reg_M_o_regfile_we),
      .o_regfile_wsel(reg_M_o_regfile_wsel),
      .o_regfile_r2sel(reg_M_o_regfile_r2sel),
      .o_nzp_data(reg_M_o_nzp_data));

   // assign next_pc = take_branch ? o_result : reg_X_o_pc;
   assign o_cur_pc = pc;

   // Initialize M-W split
   assign o_dmem_addr = reg_M_o_r2data;
   assign o_dmem_we = reg_M_o_is_store;
   assign o_dmem_towrite = reg_M_o_alu_output;

   wire [15:0] reg_W_o_alu_output, reg_W_o_dmem_load, reg_W_o_insn, reg_W_o_pc;
   wire reg_W_o_is_load, reg_W_o_regfile_we, reg_W_o_nzp_we;
   wire [2:0] reg_W_o_regfile_wsel, reg_W_o_nzp_data;
   wire [1:0] reg_W_o_stall;
   pipe_reg_W reg_W(
      .clk(clk),
      .we(1'b1),
      .gwe(gwe),
      .rst(rst),
      .i_insn(reg_M_o_insn),
      .i_pc(reg_M_o_pc),
      .i_stall(reg_M_o_stall),
      .i_alu_output(reg_M_o_alu_output),
      .i_dmem_load(i_cur_dmem_data),     // Input wire to module
      .i_nzp_we(reg_M_o_nzp_we),
      .i_nzp_data(reg_M_o_nzp_data),
      .i_is_load(reg_M_o_is_load),
      .i_regfile_we(reg_M_o_regfile_we),
      .i_regfile_wsel(reg_M_o_regfile_wsel),
      .o_insn(reg_W_o_insn),
      .o_pc(reg_W_o_pc),
      .o_stall(reg_W_o_stall),
      .o_alu_output(reg_W_o_alu_output),
      .o_dmem_load(reg_W_o_dmem_load),
      .o_nzp_we(reg_W_o_nzp_we),
      .o_nzp_data(reg_W_o_nzp_data),
      .o_is_load(reg_W_o_is_load),
      .o_regfile_we(reg_W_o_regfile_we),
      .o_regfile_wsel(reg_W_o_regfile_wsel));
      
   // Initialize W-F wrap-around split

   assign i_rd_we = reg_W_o_regfile_we;
   assign i_wdata = reg_W_o_is_load ? reg_W_o_dmem_load : reg_W_o_alu_output;
   assign i_wsel = reg_W_o_regfile_wsel;

   wire [2:0] o_nzp_reg_data;
   Nbit_reg #(.n(3), .r(0)) nzp_reg(
      .in(reg_W_o_nzp_data),
      .out(o_nzp_reg_data),
      .clk(clk),
      .we(reg_W_o_nzp_we),
      .gwe(gwe),
      .rst(rst)
   );
   // Wire to test outputs
   assign test_stall = reg_W_o_stall;
   assign test_cur_pc = reg_W_o_pc;
   assign test_cur_insn = reg_W_o_insn;
   assign test_regfile_we = i_rd_we;
   assign test_regfile_wsel = i_wsel;
   assign test_regfile_data = i_wdata;
   assign test_nzp_we = reg_W_o_nzp_we;
   assign test_nzp_new_bits = reg_W_o_nzp_data;
   assign test_dmem_we = o_dmem_we;
   assign test_dmem_addr = test_dmem_we ? o_dmem_addr    : 16'b0;
   assign test_dmem_data = test_dmem_we ? o_dmem_towrite : 16'b0;

   /**** END LC4 SINGLE CODE ****/

   /* Add $display(...) calls in the always block below to
    * print out debug information at the end of every cycle.
    * 
    * You may also use if statements inside the always block
    * to conditionally print out information.
    *
    * You do not need to resynthesize and re-implement if this is all you change;
    * just restart the simulation.
    */
`ifndef NDEBUG
   always @(posedge gwe) begin
      $display("PC: %h", pc);
      $display("flush: %d", flush);
      $display("stall: %d", reg_W_o_stall);
      $display("F -> PC: %h", pc);
      $display("D -> PC: %h, INSN: %h, take_branch: %b", reg_D_o_pc, reg_D_o_insn, take_branch);
      $display("X -> PC: %h, INSN: %h, r1_data: %h, r1_sel: %d, r2_data: %h, r2_sel: %d, w_sel: %d, wx_bypass_r1: %b, wx_bypass_r2: %b, mx_bypass_r1: %b, mx_bypass_r2: %b",
         reg_X_o_pc,
         reg_X_o_insn,
         reg_X_o_r1data,
         reg_X_o_regfile_r1sel,
         reg_X_o_r2data,
         reg_X_o_regfile_r2sel,
         reg_X_o_regfile_wsel,
         wx_bypass_r1,
         wx_bypass_r2,
         mx_bypass_r1,
         mx_bypass_r2);
      $display("M -> PC: %h, INSN: %h, alu_out: %h, w_sel: %d, w_we: %b", reg_M_o_pc, reg_M_o_insn, reg_M_o_alu_output, reg_M_o_regfile_wsel, reg_M_o_regfile_we);
      $display("W -> pc: %h, INSN: %h, writeback_data: %h, writeback_we: %b, w_sel: %d",
         reg_W_o_pc,
         reg_W_o_insn,
         i_wdata,
         i_rd_we,
         reg_W_o_regfile_wsel);

      $display("\n");
      // $display("Time: %d\nPC: %h\nINSN: %h\nregfile_we: %b\nregfile_in: %h\n", 
      //    $time,
      //    test_cur_pc,
      //    test_cur_insn,
      //    test_regfile_we,
      //    test_regfile_data);
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
      // run it for that many nano-seconds, then set
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
`endif
endmodule
