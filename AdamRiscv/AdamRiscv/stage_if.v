module stage_if(
    input  wire          clk,
    input  wire          rst,
    input  wire          pc_stall,
    input  wire[31:0]    br_addr,
    input  wire          br_ctrl,
    output wire[34:0]    if_inst,
    output wire[31:0]    if_pc
);
wire[31:0]    if_inst0;
pc u_pc(
    .clk      (clk      ),
    .br_ctrl  (br_ctrl  ),
    .br_addr  (br_addr  ),
    .rst      (rst      ),
    .pc_o     (if_pc    ),
    .pc_stall (pc_stall )
);

inst_memory #(
    .IROM_SPACE (1024 )
)inst_memory(
    .inst_addr (if_pc     ),
    .inst_o    (if_inst0      )
);
//assign if_inst=((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?
wire [1:0]idx;
assign idx =((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?if_inst0[8:7]:
            ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?if_inst0[21:20]:
            ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?if_inst0[8:7]:
            ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?if_inst0[21:20]:2'b0;
wire [5:0]new_rd,new_rs1;
assign new_rd={1'b0,if_inst0[11:7]}+{4'b0000,idx};
assign new_rs1={1'b0,if_inst0[19:15]}+{4'b0000,idx};
assign if_inst=((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS1))?{3'b100,if_inst0[31:15],3'b010,if_inst0[11:7],7'b0000011}:
               ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS2))?{3'b010,if_inst0[31:15],3'b010,if_inst0[11:7],7'b0100011}:
               ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS3))?{3'b100,12'b000000000000,if_inst0[19:15],3'b000,if_inst0[11:7],7'b0010011}:
               ((if_inst0[6:0]==`wtype)&&(if_inst0[14:12]==`INS4))?{3'b001,12'b000000000000,if_inst0[24:20],3'b000,if_inst0[11:7],7'b0010011}:
               {3'b000,if_inst0};
endmodule
