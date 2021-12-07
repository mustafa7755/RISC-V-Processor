module Reg_Ex_MEM #(parameter WIDTH = 32)
(
    //Inputs
    input clk,reset,
    input [WIDTH-1:0] pc_ex,
    input [WIDTH-1:0] instruction_ex,ALU_in,Data_B_in,immediate_ex,
    input Mem_rw_ex,RegW_en_ex,
    input [2:0] size_type_ex,
    input [1:0] WB_sel_ex,
    //Outputs
    output reg [WIDTH-1:0] pc_mem,instruction_mem,ALU_out,Data_B_out,immediate_mem,
    output reg Mem_rw_mem,RegW_en_mem,
    output reg [2:0] size_type_mem,
    output reg [1:0] WB_sel_mem
);

always @(posedge clk,posedge reset)
begin
    if(reset)begin
	        pc_mem <= 32'h0;
    instruction_mem    <=     32'h0;
    ALU_out            <=     32'h0;
    Data_B_out         <=     32'h0; 
    RegW_en_mem        <=     1'b0;
    Mem_rw_mem         <=     1'b0;  
    WB_sel_mem         <=     2'b00;
    size_type_mem      <=     3'b000;
    immediate_mem      <=     32'h0;
	end
	else
    begin
	 pc_mem <= pc_ex;
    instruction_mem    <=     instruction_ex; 
    ALU_out            <=     ALU_in;
    Data_B_out         <=     Data_B_in; 
    RegW_en_mem        <=     RegW_en_ex;
    Mem_rw_mem         <=     Mem_rw_ex;  
    WB_sel_mem         <=     WB_sel_ex;
    size_type_mem      <=     size_type_ex;
    immediate_mem      <=     immediate_ex;
    end
end   
endmodule

