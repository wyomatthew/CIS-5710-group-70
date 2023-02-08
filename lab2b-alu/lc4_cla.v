/* Matthew Pickering (mpick), Tasneem Pathan (tpathan) */

`timescale 1ns / 1ps
`default_nettype none

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals 
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits collectively generate a carry (ignoring cin)
 * @param pout whether these 4 bits collectively would propagate an incoming carry (ignoring cin)
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);
   assign cout[0] = gin[0] | (cin & pin[0]);
   assign cout[1] = gin[1] | (pin[1] & gin[0]) | (cin & pin[0] & pin[1]);
   assign cout[2] = gin[2] | (pin[2] & gin[1]) | (pin[2] & pin[1] & gin[0]) | (cin & pin[0] & pin[1] & pin[2]);
   assign gout = gin[3] | (pin[3] & gin[2]) | (pin[3] & pin[2] & gin[1]) | (pin[3] & pin[2] & pin[1] & gin[0]);
   assign pout = pin[0] & pin[1] & pin[2] & pin[3];
endmodule

/**
 * 16-bit Carry-Lookahead Adder
 * @param a first input
 * @param b second input
 * @param cin carry in
 * @param sum sum of a + b + carry-in
 */
module cla16
  (input wire [15:0]  a, b,
   input wire         cin,
   output wire [15:0] sum);

  wire[15:0] Generate1;
  wire[15:0] Propagate1;
  
  genvar i; 
  for (i = 0; i < 16; i = i + 1) begin
    gp1 gp(.a(a[i]), .b(b[i]), .g(Generate1[i]), .p(Propagate1[i]));
  end

  wire[3:0] g30 = {Generate1[3], Generate1[2], Generate1[1], Generate1[0]};
  wire[3:0] p30 = {Propagate1[3], Propagate1[2], Propagate1[1], Propagate1[0]};

  wire[3:0] g74 = {Generate1[7], Generate1[6], Generate1[5], Generate1[4]};
  wire[3:0] p74 = {Propagate1[7], Propagate1[6], Propagate1[5], Propagate1[4]};

  wire[3:0] g118 = {Generate1[11], Generate1[10], Generate1[9], Generate1[8]};
  wire[3:0] p118 = {Propagate1[11], Propagate1[10], Propagate1[9], Propagate1[8]};

  wire[3:0] g1512 = {Generate1[15], Generate1[14], Generate1[13], Generate1[12]};
  wire[3:0] p1512 = {Propagate1[15], Propagate1[14], Propagate1[13], Propagate1[12]};

  wire[2:0] carry31;
  wire[2:0] carry75;
  wire[2:0] carry119;
  wire[2:0] carry1513;

  wire[2:0] carry4812;

  wire gen4_30;
  wire gen4_74;
  wire gen4_118;
  wire gen4_1512;

  wire prop4_30; 
  wire prop4_74; 
  wire prop4_118;
  wire prop4_1512; 

  gp4 gp30(.gin(g30), .pin(p30), .cin(cin), .gout(gen4_30), .pout(prop4_30), .cout(carry31));
  gp4 gp74(.gin(g74), .pin(p74), .cin(carry4812[0]), .gout(gen4_74), .pout(prop4_74), .cout(carry75));
  gp4 gp118(.gin(g118), .pin(p118), .cin(carry4812[1]), .gout(gen4_118), .pout(prop4_118), .cout(carry119));
  gp4 gp1512(.gin(g1512), .pin(p1512), .cin(carry4812[2]), .gout(gen4_1512), .pout(prop4_1512), .cout(carry1513));

  wire[3:0] gen4_full = {gen4_1512, gen4_118, gen4_74, gen4_30};
  wire[3:0] prop4_full = {prop4_1512, prop4_118, prop4_74, prop4_30};

  wire gen_full; 
  wire prop_full; 

  gp4 gp_full(.gin(gen4_full), .pin(prop4_full), .cin(cin), .gout(gen_full), .pout(prop_full), .cout(carry4812));
  
  wire[15:0] carry_full = {carry1513, carry4812[2], carry119, carry4812[1], carry75, carry4812[0], carry31, cin};

  genvar j;
  for (j = 0; j < 16; j = j + 1) begin
    assign sum[j] = a[j] ^ b[j] ^ carry_full[j];
  end
endmodule


/** Lab 2 Extra Credit, see details at
  https://github.com/upenn-acg/cis501/blob/master/lab2-alu/lab2-cla.md#extra-credit
 If you are not doing the extra credit, you should leave this module empty.
 */
module gpn
  #(parameter N = 4)
  (input wire [N-1:0] gin, pin,
   input wire  cin,
   output wire gout, pout,
   output wire [N-2:0] cout);
 
endmodule
