/**
 * lc4_branch_controller
 * Tasneem Pathan (tpathan)
 * Matthew Pickering (mpick)
 * group 70
 */

module lc4_branch_controller(input wire [15:0] insn,
                             input wire [2:0]  o_nzp,
                             input wire        is_branch,
                             input wire        is_control_insn,
                             output wire take_branch);
    wire [2:0] insn_br = insn[11:9];
    wire nzp_branch_works = |(insn_br & o_nzp);
    
    assign take_branch = (is_branch & nzp_branch_works) | is_control_insn;
endmodule