/* TODO: INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps
`default_nettype none


// A if Sel True, B otherwise
module mux2to1(input wire Sel,
      input wire [N-1:0] A,
      input wire [N-1:0] B,
      output wire [N-1:0] Out);
      parameter N = 1;
      assign Out = Sel ? A : B;
endmodule

module lc4_divider(input  wire [15:0] i_dividend,
                   input  wire [15:0] i_divisor,
                   output wire [15:0] o_remainder,
                   output wire [15:0] o_quotient);
      wire DivEqZero;
      wire[15:0] DividOut;
      wire[15:0] RemOut;
      assign DivEqZero = i_divisor == (16'b0);

      // Wire up output Mux
      mux2to1 #(16) QuotMux (.Sel(DivEqZero), .A(16'b0), .B(DividOut), .Out(o_quotient));
      mux2to1 #(16) RemMux (.Sel(DivEqZero), .A(16'b0), .B(RemOut), .Out(o_remainder));

      // Wire up SSHs
      wire[15:0] TempDividend[16:0];
      wire[15:0] TempRemainder[16:0];
      wire[15:0] TempQuotient[16:0];
      assign TempDividend[0] = i_dividend;
      assign TempRemainder[0] = 16'b0;
      assign TempQuotient[0] = 16'b0;

      genvar i;
      for (i = 0; i < 16; i = i + 1) begin
            lc4_divider_one_iter SSH(
                  .i_dividend(TempDividend[i]),
                  .i_divisor(i_divisor),
                  .i_remainder(TempRemainder[i]),
                  .i_quotient(TempQuotient[i]),
                  .o_dividend(TempDividend[i + 1]),
                  .o_remainder(TempRemainder[i + 1]),
                  .o_quotient(TempQuotient[i + 1])
            );
      end
      assign DividOut = TempQuotient[16];
      assign RemOut = TempRemainder[16];

endmodule // lc4_divider

module lc4_divider_one_iter(input  wire [15:0] i_dividend,
                            input  wire [15:0] i_divisor,
                            input  wire [15:0] i_remainder,
                            input  wire [15:0] i_quotient,
                            output wire [15:0] o_dividend,
                            output wire [15:0] o_remainder,
                            output wire [15:0] o_quotient);
      wire [15:0] RemoDivid;
      wire RemLessDivis; 
      wire [15:0] RemMinDivis;
      wire [15:0] QuotTemp;

      // Value of new remainder
      assign RemoDivid = (i_remainder << 1) | ((i_dividend >> 15) & (16'h01));
      assign RemLessDivis = RemoDivid < i_divisor; // High

      // Output quotient
      assign QuotTemp = i_quotient << 1;
      mux2to1 #(16) MuxQuot (
            .Sel(RemLessDivis), // Conditional
            .A(QuotTemp), // If True
            .B(QuotTemp | (16'h01)), // If False
            .Out(o_quotient));

      // Output remainder
      assign RemMinDivis = (~i_divisor + 1) + RemoDivid;
      mux2to1 #(16) MuxRem (
            .Sel(RemLessDivis), // Conditional
            .A(RemoDivid), // If True
            .B(RemMinDivis), // If False
            .Out(o_remainder));

      // Dividend is left shifted by 1
      assign o_dividend = i_dividend << 1;
endmodule
