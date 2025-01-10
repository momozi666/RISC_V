`include "./AdamRiscv/define.vh"
module stage_id(
    input wire         clk,
    input wire         rst,
    input wire[34:0]   id_inst,//wsy
    input wire         w_regs_en,
    input wire[5:0]    w_regs_addr,
    input wire[31:0]   w_regs_data,
    input wire[31:0]   w_regs_data2,
    input wire         w_regs_mop_en,
    input wire         ctrl_stall,
    output  wire[31:0] id_regs_data1,
    output  wire[31:0] id_regs_data2,
    output  wire[31:0] id_imm,
    output  wire[2:0]  id_func3_code, 
    output  wire       id_func7_code,
    output  wire[5:0]  id_rd,
    output  wire       id_br,
    output  wire       id_mem_read,
    output  wire       id_mem2reg,
    output  wire[2:0]  id_alu_op,
    output  wire       id_mem_write,
    output  wire[1:0]  id_alu_src1,
    output  wire[1:0]  id_alu_src2,
    output  wire       id_br_addr_mode,
    output  wire       id_regs_write,
    //forwarding
    output  wire[5:0]  id_rs1,
    output  wire[5:0]  id_rs2,
    output  wire id_have_mop
);

wire        br          ;
wire        mem_read    ;
wire        mem2reg     ;
wire[2:0]   alu_op      ;
wire        mem_write   ;
wire[1:0]   alu_src1    ;
wire[1:0]   alu_src2    ;
wire        br_addr_mode;
wire        regs_write  ;

assign id_have_mop=(id_inst[6:0]==`wtype)?1:0;
regs u_regs(
    .clk          (clk              ),
    .rst          (rst              ),
    .r_regs_addr1 ({id_inst[32],id_inst[19:15]}   ),
    .r_regs_addr2 ({id_inst[33],id_inst[24:20]}   ),
    .w_regs_addr  (w_regs_addr      ),
    .w_regs_data  (w_regs_data      ),
    .w_regs_data2  (w_regs_data2      ),
    .w_regs_mop_en(w_regs_mop_en),
    .w_regs_en    (w_regs_en        ),
    .r_regs_o1    (id_regs_data1    ),
    .r_regs_o2    (id_regs_data2    )
);

ctrl u_ctrl(
    .inst_op        (id_inst[6:0] ),
    .br             (br           ),
    .mem_read       (mem_read     ),
    .mem2reg        (mem2reg      ),
    .alu_op         (alu_op       ),
    .mem_write      (mem_write    ),
    .alu_src1       (alu_src1     ),
    .alu_src2       (alu_src2     ),
    .br_addr_mode   (br_addr_mode ),
    .regs_write     (regs_write   )
);

imm_gen u_imm_gen(
    .inst  (id_inst  ),
    .imm_o (id_imm   )
);

assign id_rd         = {id_inst[34],id_inst[11:7]};
assign id_func3_code = id_inst[14:12];
assign id_func7_code = id_inst[30];

assign id_rs1 = {id_inst[32],id_inst[19:15]};
assign id_rs2 = {id_inst[33],id_inst[24:20]};

//stall
assign id_br           = (ctrl_stall == 1) ? 0 : br             ;
assign id_mem_read     = (ctrl_stall == 1) ? 0 : mem_read       ;       
assign id_mem2reg      = (ctrl_stall == 1) ? 0 : mem2reg        ;      
assign id_alu_op       = (ctrl_stall == 1) ? 0 : alu_op         ;     
assign id_mem_write    = (ctrl_stall == 1) ? 0 : mem_write      ;            
assign id_alu_src1     = (ctrl_stall == 1) ? 0 : alu_src1       ;
assign id_alu_src2     = (ctrl_stall == 1) ? 0 : alu_src2       ; 
assign id_br_addr_mode = (ctrl_stall == 1) ? 0 : br_addr_mode   ;       
assign id_regs_write   = (ctrl_stall == 1) ? 0 : regs_write     ;             



endmodule