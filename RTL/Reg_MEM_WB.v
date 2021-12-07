module Reg_MEM_WB #(parameter WIDTH = 32)
(
    //inputs
    input clk,reset,
    input [WIDTH-1:0] pc_mem,
    input [WIDTH-1:0] instruction_mem,ALU_in,Data_R_in,immediate_mem,
    input RegW_en_mem,
    input [1:0] WB_sel_mem,
    //outputs
    output reg [WIDTH-1:0] pc_wb,instruction_wb,ALU_out,Data_R_out,immediate_wb,
    output reg RegW_en_wb,
    output reg [1:0] WB_sel_wb 
);

always @(posedge clk,posedge reset)
begin
    if(reset)begin
	 pc_wb <= 32'h0;
    instruction_wb    <=        32'h0;
    ALU_out            <=        32'h0;
    Data_R_out         <=        32'h0;  
    RegW_en_wb        <=     1'b0;  
    WB_sel_wb         <=     2'b00;
    immediate_wb       <=    32'h0;
	end
	else
    begin
	   pc_wb <= pc_mem;
    instruction_wb    <=        instruction_mem;
    ALU_out            <=        ALU_in;
    Data_R_out         <=        Data_R_in;  
    RegW_en_wb        <=     RegW_en_mem;  
    WB_sel_wb         <=     WB_sel_mem;
    immediate_wb       <=    immediate_mem;
    end      
end   
endmodule


