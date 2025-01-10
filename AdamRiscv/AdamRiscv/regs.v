module regs(
    input wire clk,
    input wire rst,

    input wire[5:0]     r_regs_addr1,
    input wire[5:0]     r_regs_addr2,
    input wire[5:0]     w_regs_addr,
    input wire[31:0]    w_regs_data,
    input wire[31:0]    w_regs_data2,
    input wire    w_regs_mop_en,
    input wire          w_regs_en,

    output wire[31:0]   r_regs_o1,
    output wire[31:0]   r_regs_o2
);

reg [31:0] regs_file [35:0]; //  32 32-bit registers
wire wb_hazard_a;
wire wb_hazard_b;
wire [7:0]mop_res[15:0];
wire [7:0]tmp[15:0];
assign tmp[0]=w_regs_data[31:24]*w_regs_data2[31:24];
assign tmp[1]=w_regs_data[23:16]*w_regs_data2[31:24];
assign tmp[2]=w_regs_data[15:8]*w_regs_data2[31:24];
assign tmp[3]=w_regs_data[7:0]*w_regs_data2[31:24];
assign tmp[4]=w_regs_data[31:24]*w_regs_data2[23:16];
assign tmp[5]=w_regs_data[23:16]*w_regs_data2[23:16];
assign tmp[6]=w_regs_data[15:8]*w_regs_data2[23:16];
assign tmp[7]=w_regs_data[7:0]*w_regs_data2[23:16];
assign tmp[8]=w_regs_data[31:24]*w_regs_data2[15:8];
assign tmp[9]=w_regs_data[23:16]*w_regs_data2[15:8];
assign tmp[10]=w_regs_data[15:8]*w_regs_data2[15:8];
assign tmp[11]=w_regs_data[7:0]*w_regs_data2[15:8];
assign tmp[12]=w_regs_data[31:24]*w_regs_data2[7:0];
assign tmp[13]=w_regs_data[23:16]*w_regs_data2[7:0];
assign tmp[14]=w_regs_data[15:8]*w_regs_data2[7:0];
assign tmp[15]=w_regs_data[7:0]*w_regs_data2[7:0];

assign mop_res[0]=regs_file[32][31:24]+tmp[12][7:0];
assign mop_res[1]=regs_file[32][23:16]+tmp[13][7:0];
assign mop_res[2]=regs_file[32][15:8]+tmp[14][7:0];
assign mop_res[3]=regs_file[32][7:0]+tmp[15][7:0];
assign mop_res[4]=regs_file[33][31:24]+tmp[8][7:0];
assign mop_res[5]=regs_file[33][23:16]+tmp[9][7:0];
assign mop_res[6]=regs_file[33][15:8]+tmp[10][7:0];
assign mop_res[7]=regs_file[33][7:0]+tmp[11][7:0];
assign mop_res[8]=regs_file[34][31:24]+tmp[4][7:0];
assign mop_res[9]=regs_file[34][23:16]+tmp[5][7:0];
assign mop_res[10]=regs_file[34][15:8]+tmp[6][7:0];
assign mop_res[11]=regs_file[34][7:0]+tmp[7][7:0];
assign mop_res[12]=regs_file[35][31:24]+tmp[0][7:0];
assign mop_res[13]=regs_file[35][23:16]+tmp[1][7:0];
assign mop_res[14]=regs_file[35][15:8]+tmp[2][7:0];
assign mop_res[15]=regs_file[35][7:0]+tmp[3][7:0];
/*------------------------Write RegisterFile---------------*/
always @(posedge clk) begin
    if (!rst)begin
        regs_file[0] <= 0;
        regs_file[32] <= 32'h55555555;
        regs_file[33] <= 32'haaaaaaaa;
        regs_file[34] <= 32'h33333333;
        regs_file[35] <= 32'hcccccccc;
    end
    else if (w_regs_en && w_regs_addr != 6'b0) begin //forbit write x0
        $display("WRITE REGISTER FILE: x%d = %h", w_regs_addr, w_regs_data);
        if(!w_regs_mop_en)
        regs_file[w_regs_addr] <= w_regs_data;
    end
    else if (w_regs_en &&w_regs_mop_en)begin
            regs_file[32]<={mop_res[0],mop_res[1],mop_res[2],mop_res[3]};
            regs_file[33]<={mop_res[4],mop_res[5],mop_res[6],mop_res[7]};
            regs_file[34]<={mop_res[8],mop_res[9],mop_res[10],mop_res[11]};
            regs_file[35]<={mop_res[12],mop_res[13],mop_res[14],mop_res[15]};
        end
end

/*------------------------hazard check & forwarding-------------*/
assign wb_hazard_a = w_regs_en && (w_regs_addr != 0) && (w_regs_addr == r_regs_addr1); //me_rd != 0 : don't forward the result when rd is x0
assign wb_hazard_b = w_regs_en && (w_regs_addr != 0) && (w_regs_addr == r_regs_addr2);

/*------------------------Read RegisterFile---------------*/
assign r_regs_o1 = wb_hazard_a ? w_regs_data : regs_file[r_regs_addr1];
assign r_regs_o2 = wb_hazard_b ? w_regs_data : regs_file[r_regs_addr2];

endmodule
