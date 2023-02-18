/**
 * lc4_data_controller
 * Tasneem Pathan (tpathan)
 * Matthew Pickering (mpick)
 * group 70
 */

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
    assign o_pc = take_branch ? o_alu : o_pc;

    wire [15:0] o_reg = select_pc_plus_one ? i_pc1 : o_alu;
    assign dmem_addr = o_reg;
    assign dmem_store = r2data;

    assign wdata = is_load ? dmem_load : o_reg;
endmodule