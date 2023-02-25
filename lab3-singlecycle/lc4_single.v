/* TODO: name and PennKeys of all group members here
 *
 * lc4_single.v
 * Implements a single-cycle data path
 *
 */

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

module lc4_processor
   (input  wire        clk,                // Main clock
    input  wire        rst,                // Global reset
    input  wire        gwe,                // Global we for single-step clock
   
    output wire [15:0] o_cur_pc,           // Address to read from instruction memory
    input  wire [15:0] i_cur_insn,         // Output of instruction memory
    output wire [15:0] o_dmem_addr,        // Address to read/write from/to data memory; SET TO 0x0000 FOR NON LOAD/STORE INSNS
    input  wire [15:0] i_cur_dmem_data,    // Output of data memory
    output wire        o_dmem_we,          // Data memory write enable
    output wire [15:0] o_dmem_towrite,     // Value to write to data memory

    // Testbench signals are used by the testbench to verify the correctness of your datapath.
    // Many of these signals simply export internal processor state for verification (such as the PC).
    // Some signals are duplicate output signals for clarity of purpose.
    //
    // Don't forget to include these in your schematic!

    output wire [1:0]  test_stall,         // Testbench: is this a stall cycle? (don't compare the test values)
    output wire [15:0] test_cur_pc,        // Testbench: program counter
    output wire [15:0] test_cur_insn,      // Testbench: instruction bits
    output wire        test_regfile_we,    // Testbench: register file write enable
    output wire [2:0]  test_regfile_wsel,  // Testbench: which register to write in the register file 
    output wire [15:0] test_regfile_data,  // Testbench: value to write into the register file
    output wire        test_nzp_we,        // Testbench: NZP condition codes write enable
    output wire [2:0]  test_nzp_new_bits,  // Testbench: value to write to NZP bits
    output wire        test_dmem_we,       // Testbench: data memory write enable
    output wire [15:0] test_dmem_addr,     // Testbench: address to read/write memory
    output wire [15:0] test_dmem_data,     // Testbench: value read/writen from/to memory
   
    input  wire [7:0]  switch_data,        // Current settings of the Zedboard switches
    output wire [7:0]  led_data            // Which Zedboard LEDs should be turned on?
    );

   // By default, assign LEDs to display switch inputs to avoid warnings about
   // disconnected ports. Feel free to use this for debugging input/output if
   // you desire.
   assign led_data = switch_data;

   
   /* DO NOT MODIFY THIS CODE */
   // Always execute one instruction each cycle (test_stall will get used in your pipelined processor)
   assign test_stall = 2'b0; 

   // pc wires attached to the PC register's ports
   wire [15:0]   pc;      // Current program counter (read out from pc_reg)
   wire [15:0]   next_pc; // Next program counter (you compute this and feed it into next_pc)

   // Program counter register, starts at 8200h at bootup
   Nbit_reg #(16, 16'h8200) pc_reg (.in(next_pc), .out(pc), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

   /* END DO NOT MODIFY THIS CODE */


   /*******************************
    * TODO: INSERT YOUR CODE HERE *
    *******************************/
    wire [2:0] r1sel, r2sel, wsel, o_nzp;
    wire r1re, r2re, regfile_we, nzp_we, select_pc_plus_one, is_load,
      is_branch, is_control_insn, take_branch;
   lc4_decoder decoder(.insn(i_cur_insn), .r1sel(r1sel), .r2sel(r2sel), .wsel(wsel),
      .r1re(r1re), .r2re(r2re), .regfile_we(regfile_we), .nzp_we(nzp_we),
      .select_pc_plus_one(select_pc_plus_one), .is_load(is_load), .is_store(o_dmem_we),
      .is_branch(is_branch), .is_control_insn(is_control_insn));

   wire [15:0] wdata;
   // wire [15:0] i_pc1;
   // cla16 incrementer(.a(pc), .b(16'b1), .cin(1'b0), .sum(i_pc1));

   wire [15:0] o_rs_data, o_rt_data;
   lc4_regfile #(.n(16)) regfile(.clk(clk), .gwe(gwe), .rst(rst), .i_rs(r1sel),
      .i_rt(r2sel), .i_rd(wsel), .i_rd_we(regfile_we), .i_wdata(wdata),
      .o_rs_data(o_rs_data), .o_rt_data(o_rt_data));

   lc4_branch_controller br_controller(.insn(i_cur_insn),
      .is_control_insn(is_control_insn), .is_branch(is_branch), .o_nzp(o_nzp),
      .take_branch(take_branch));
   
   lc4_data_controller data_controller(.r1data(o_rs_data), .r2data(o_rt_data), .insn(i_cur_insn), 
      .i_pc1(pc), .dmem_load(i_cur_dmem_data), .is_load(is_load), .take_branch(take_branch), 
      .select_pc_plus_one(select_pc_plus_one), .wdata(wdata), .o_pc(next_pc), .dmem_addr(o_dmem_addr), 
      .dmem_store(o_dmem_towrite));

   lc4_nzp_controller nzp_controller(.clk(clk), .gwe(gwe), .rst(rst), .wdata(wdata), .nzp_we(nzp_we), .o_nzp(o_nzp), .i_nzp(test_nzp_new_bits));

   // Wire to test outputs

   assign test_cur_pc = pc;
   assign o_cur_pc = pc;
   assign test_cur_insn = i_cur_insn;
   assign test_regfile_we = regfile_we;
   assign test_regfile_wsel = wsel;
   assign test_regfile_data = wdata; // regfile_in
   assign test_nzp_we = nzp_we;
   assign test_dmem_we = o_dmem_we;
   assign test_dmem_addr = o_dmem_we | is_load ? o_dmem_addr    : 16'b0;
   assign test_dmem_data = o_dmem_we ? o_dmem_towrite :
                           is_load   ? i_cur_dmem_data :
                           16'b0;

   /* Add $display(...) calls in the always block below to
    * print out debug information at the end of every cycle.
    *
    * You may also use if statements inside the always block
    * to conditionally print out information.
    *
    * You do not need to resynthesize and re-implement if this is all you change;
    * just restart the simulation.
    * 
    * To disable the entire block add the statement
    * `define NDEBUG
    * to the top of your file.  We also define this symbol
    * when we run the grading scripts.
    */
`ifndef NDEBUG
   always @(posedge gwe) begin
      // $display("pc: %h\ninsn: %b\ni_cur_dmem_data: %h\nwdata: %h\nmem_data: %h\ndmem_addr: %h\nis_load: %b\nis_store: %h\nrs: %h\nrt: %h\n", pc, i_cur_insn, i_cur_dmem_data, wdata, test_dmem_data, test_dmem_addr, is_load, o_dmem_we, o_rs_data, o_rt_data);
      // $display("pc: %h\ni_pc1: %h\nnext_pc: %h\n", pc, i_pc1, next_pc);
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
      // run it for that many nano-seconds, then set
      // the breakpoint.

      // In the objects view, you can change the values to
      // hexadecimal by selecting all signals (Ctrl-A),
      // then right-click, and select Radix->Hexadecial.

      // To see the values of wires within a module, select
      // the module in the hierarchy in the "Scopes" pane.
      // The Objects pane will update to display the wires
      // in that module.

      // $display();
   end
`endif
endmodule
