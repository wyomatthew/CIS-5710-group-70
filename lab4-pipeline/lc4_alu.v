/* Matthew Pickering (mpick), Tasneem Pathan (tpathan) */

`timescale 1ns / 1ps
`default_nettype none

module imm_decider(input wire [15:0] i_insn,
                   output wire [15:0] immx);
      wire [3:0] ms4 = i_insn[15:12];
      assign immx = (ms4 == 4'b0000) | (ms4 == 4'b1001)    ? {{7{i_insn[8]}}, $signed(i_insn[8:0])} : // IMM9
                    (ms4 == 4'b1100)                       ? {{5{i_insn[10]}}, $signed(i_insn[10:0])} : // IMM11 
                    ms4 == 4'b0100                         ? i_insn[10:0] :
                    (ms4 == 4'b1101) | (ms4 == 4'b1111)    ? i_insn[7:0] : // IMM8
                    (ms4 == 4'b0010) & (i_insn[8] == 1'b1) ? (i_insn[7] ? i_insn[6:0] : {{9{i_insn[6]}}, $signed(i_insn[6:0])}) : // IMM7
                    (ms4 == 4'b0110) | (ms4 == 4'b0111)    ? {{10{i_insn[5]}}, $signed(i_insn[5:0])} : // IMM6
                    (ms4 == 4'b0001) | (ms4 == 4'b0101)    ? {{11{i_insn[4]}}, $signed(i_insn[4:0])} : // IMM5
                                                             i_insn[3:0]; // IMM4      
endmodule

module cin_decider(input wire [15:0] i_insn,
                   output wire cin);
      assign cin = (i_insn[15:12] == 4'b0000) | (i_insn[15:11] == 5'b11001) | ((i_insn[15:12] == 4'b0001) & (i_insn[5:3] == 3'b010));
endmodule

module add1_decider(input wire [15:0] i_insn,
                    input wire [15:0] i_r1data,
                    input wire [15:0] i_pc,
                    output wire [15:0] add1);
      assign add1 = (i_insn[15:12] == 4'b0000) | (i_insn[15:12] == 4'b1100) ? i_pc :
                    i_r1data;

endmodule

module neg_decider(input wire [15:0] i_insn,
                   input wire [15:0] add2,
                   output wire [15:0] o_add2);
      assign o_add2 = (i_insn[15:12] == 4'b0001) & (i_insn[5:3] == 3'b010) ? ~add2 :
                      add2;
endmodule

module add2_decider(input wire [15:0] i_insn,
                    input wire [15:0] immx,
                    input wire [15:0] i_r2data,
                    output wire [15:0] add2);
      assign add2 = ((i_insn[15:12] == 4'b0001) & ~i_insn[5]) ? i_r2data : immx;
endmodule


module adder_out(input wire [15:0] i_insn,
                 input wire [15:0] immx,
                 input wire [15:0] i_pc,
                 input wire [15:0] i_r1data,
                 input wire [15:0] i_r2data,
                 output wire [15:0] o_result);
      wire [15:0] add1, add2, o_add2, sum;
      wire cin;
      add1_decider add1d(.i_insn(i_insn), .i_r1data(i_r1data), .i_pc(i_pc), .add1(add1));
      add2_decider add2d(.i_insn(i_insn), .immx(immx), .i_r2data(i_r2data), .add2(add2));
      neg_decider negd(.i_insn(i_insn), .add2(add2), .o_add2(o_add2));
      cin_decider cind(.i_insn(i_insn), .cin(cin));

      cla16 cla(.a(add1), .b(o_add2), .cin(cin), .sum(o_result));
endmodule

module mult_out(input wire [15:0] i_r1data,
                input wire [15:0] i_r2data,
                output wire [15:0] o_result);
      assign o_result = i_r1data * i_r2data;
endmodule

module div_out(input wire [15:0] i_insn,
               input wire [15:0] i_r1data, 
               input wire [15:0] i_r2data, 
               output wire [15:0] o_result);
      wire [3:0] ms4 = i_insn[15:12];
      wire [15:0] rem;
      wire [15:0] quot;
      lc4_divider div(.i_dividend(i_r1data), .i_divisor(i_r2data), .o_remainder(rem), .o_quotient(quot));
      assign o_result = (ms4 == 4'b0001) ? quot : rem;
endmodule

module and_out(input wire [15:0] i_insn,
               input wire [15:0] i_r1data,
               input wire [15:0] i_r2data,
               input wire [15:0] immx,
               output wire [15:0] o_result);      
      assign o_result = i_insn[5] ? (i_r1data & immx) : (i_r1data & i_r2data);
endmodule

module not_out(input wire [15:0] i_r1data,
               output wire [15:0] o_result);
      assign o_result = ~i_r1data;
endmodule

module or_out(input wire [15:0] i_r1data,
              input wire [15:0] i_r2data,
              output wire [15:0] o_result);
      assign o_result = i_r1data | i_r2data;
endmodule

module xor_out(input wire [15:0] i_r1data,
               input wire [15:0] i_r2data,
               output wire [15:0] o_result);
      assign o_result = i_r1data ^ i_r2data;
endmodule

module shift_out(input wire [15:0] i_insn,
                 input wire [15:0] immx,
                 input wire [15:0] i_r1data,
                 output wire [15:0] o_result);
      assign o_result = i_insn[5:4] == 2'b00 ? i_r1data << immx :
                        i_insn[5:4] == 2'b01 ? $signed($signed(i_r1data) >>> immx) :
                        i_r1data >> immx;
endmodule

module const_out(input wire [15:0] immx,
                output wire [15:0] o_result);
      assign o_result = immx;
endmodule

module hiconst_out(input wire [15:0] immx,
                   input wire [15:0] i_r1data,
                   output wire [15:0] o_result);
      assign o_result = (i_r1data & 8'hFF) | (immx << 8);
endmodule 

module comp_out(input wire [15:0] i_insn,
                input wire [15:0] immx,
                input wire [15:0] i_r1data,
                input wire [15:0] i_r2data,
                output wire [15:0] o_result);
      assign o_result = i_insn[8] ? (
            i_insn[7] ? (
                  // Immedate unsigned
                  i_r1data > immx ? 16'b1 :
                  i_r1data == immx ? 16'b0 :
                  16'hFFFF
            ) : (
                  // Immediate signed
                  $signed(i_r1data) > $signed(immx) ? 16'b1 :
                  $signed(i_r1data) == $signed(immx) ? 16'b0 :
                  16'hFFFF
            )
      ) : (
            i_insn[7] ? (
                  // R2 unsigned
                  i_r1data > i_r2data ? 16'b1 :
                  i_r1data == i_r2data ? 16'b0 :
                  16'hFFFF
            ) : (
                  $signed(i_r1data) > $signed(i_r2data) ? 16'b1 :
                  $signed(i_r1data) == $signed(i_r2data) ? 16'b0 :
                  16'hFFFF
            )
      );
endmodule

module lc4_alu(input  wire [15:0] i_insn,
               input wire [15:0]  i_pc,
               input wire [15:0]  i_r1data,
               input wire [15:0]  i_r2data,
               output wire [15:0] o_result);
      wire [15:0] immx;
      imm_decider imm_decider(.i_insn(i_insn), .immx(immx));

      wire [15:0] o_add, o_mult, o_div, o_and, o_not, o_or, o_xor, o_shift, o_const, o_hiconst, o_comp;
      
      adder_out adder_out(.i_insn(i_insn), .immx(immx), .i_pc(i_pc), .i_r1data(i_r1data), .i_r2data(i_r2data), .o_result(o_add));
      mult_out mult_out(.i_r1data(i_r1data), .i_r2data(i_r2data), .o_result(o_mult));
      div_out div_out(.i_insn(i_insn), .i_r1data(i_r1data), .i_r2data(i_r2data), .o_result(o_div));
      and_out and_out(.i_insn(i_insn), .i_r1data(i_r1data), .immx(immx), .i_r2data(i_r2data), .o_result(o_and));
      or_out or_out(.i_r1data(i_r1data), .i_r2data(i_r2data), .o_result(o_or));
      not_out not_out(.i_r1data(i_r1data), .o_result(o_not));
      xor_out xor_out(.i_r1data(i_r1data), .i_r2data(i_r2data), .o_result(o_xor));
      shift_out shift_out(.i_insn(i_insn), .immx(immx), .i_r1data(i_r1data), .o_result(o_shift));
      const_out const_out(.immx(immx), .o_result(o_const));
      hiconst_out hiconst_out(.immx(immx), .i_r1data(i_r1data), .o_result(o_hiconst));
      comp_out comp_out(.i_insn(i_insn), .i_r1data(i_r1data), .immx(immx), .i_r2data(i_r2data), .o_result(o_comp));
      
      // Top-level MUX
      wire [3:0] first4 = i_insn[15:12];
      assign o_result = first4 == 4'b1101 ? o_hiconst :
                        first4 == 4'b1001 ? o_const :
                        (first4 == 4'b1010) & (~(i_insn[5] & i_insn[4])) ? o_shift :
                        first4 == 4'b0101 ? ( // Boolean instruction
                              i_insn[5] ? o_and :
                              i_insn[4:3] == 2'b01 ? o_not :
                              i_insn[4:3] == 2'b10 ? o_or :
                              i_insn[4:3] == 2'b11 ? o_xor :
                              o_and
                        ) :
                        (first4 == 4'b0001) & (i_insn[5:3] == 3'b001) ? o_mult :
                        (first4 == 4'b0001) & (i_insn[5:3] == 3'b011) ? o_div :
                        (first4 == 4'b1010) ? o_div :
                        (first4 == 4'b0010) ? o_comp :
                        (i_insn[15:11] == 5'b01000) ? i_r1data :
                        (i_insn[15:11] == 5'b01001) ? ((i_pc & 16'h8000) | (immx << 4)) :
                        (first4 == 4'b1111) ? (16'h8000 | immx) :
                        (first4 == 4'b1000) ? i_r1data :
                        (i_insn[15:11] == 5'b11000) ? i_r1data :
                        o_add;

endmodule
