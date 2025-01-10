module hazard_detection(
    input  wire      ex_mem_read,
    input  wire[5:0] id_rs1,
    input  wire[5:0] id_rs2,
    input  wire[5:0] ex_rd,
    input  wire      br_ctrl,
    input wire id_have_mop,
    input wire ex_mop_en,
    input wire me_mop_en,
    output wire      load_stall,
    output wire      mop_stall,
    output wire      flush
);
assign mop_stall=id_have_mop||ex_mop_en||me_mop_en;
assign load_stall= ex_mem_read && (ex_rd == id_rs1 || ex_rd == id_rs2);

assign flush      = br_ctrl;


endmodule