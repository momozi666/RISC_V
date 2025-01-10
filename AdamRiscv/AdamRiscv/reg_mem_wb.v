module reg_mem_wb(
    input  wire clk,
    input  wire rst,
    input  wire[31:0] me_mem_data,
    input  wire[31:0] me_alu_o,
    input  wire[31:0] me_alu_o2,
    input  wire me_mop_en,
    input  wire[5:0]  me_rd,
    input  wire       me_mem2reg,
    input  wire       me_regs_write,
    output reg[31:0]  wb_mem_data,
    output reg[31:0]  wb_alu_o,
    output reg[31:0]  wb_alu_o2,
    output reg wb_mop_en,
    output reg[5:0]   wb_rd,
    output reg        wb_mem2reg,
    output reg        wb_regs_write
);

always @(posedge clk) begin
    if (!rst)begin
        wb_mem_data    <= 0;     
        wb_alu_o       <= 0;    
        wb_alu_o2       <= 0;
        wb_mop_en       <= 0;   
        wb_rd          <= 0; 
        wb_mem2reg     <= 0;     
        wb_regs_write  <= 0;              
    end 
    else begin
        wb_mem_data    <= me_mem_data;     
        wb_alu_o       <= me_alu_o;     
        wb_alu_o2       <= me_alu_o2;
        wb_mop_en       <= me_mop_en;      
        wb_rd          <= me_rd; 
        wb_mem2reg     <= me_mem2reg;     
        wb_regs_write  <= me_regs_write;   
    end
    $display("wb_mem_data  : %h",wb_mem_data);
    $display("wb_alu_o     : %h",wb_alu_o);
    $display("wb_mem2reg   : %h",wb_mem2reg);
    $display("wb_regs_write: %h",wb_regs_write);
end

endmodule