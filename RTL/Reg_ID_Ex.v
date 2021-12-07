module Reg_ID_Ex #(parameter WIDTH = 32)
(
    //Inputs
    input clk,reset,
    input [WIDTH-1:0] pc_d,
    input [WIDTH-1:0] instruction_d,Data_A_d,Data_B_d,
    input PC_sel_d, Br_un_d, A_sel_d, B_sel_d, RegW_en_d, Mem_rw_d,flush,
    input [2:0] Imm_sel_d,
    input [1:0] WB_sel_d,
    input [2:0] size_type_d,
    input [3:0] ALU_Sel_d,
    //Outputs
    output reg [WIDTH-1:0] pc_ex,instruction_ex,Data_A_ex,Data_B_ex,
    output reg PC_sel_ex, Br_un_ex, A_sel_ex, B_sel_ex, RegW_en_ex, Mem_rw_ex,
    output reg [2:0] Imm_sel_ex,
    output reg [1:0] WB_sel_ex,
    output reg [2:0] size_type_ex,
    output reg [3:0] ALU_Sel_ex
);

always @(posedge clk,posedge reset)
begin
    if(reset)begin
		            pc_ex  <= 32'h0;
    		instruction_ex     <=     32'h0;
    		PC_sel_ex          <=     1'b0;
		Data_A_ex          <=     32'h0;
    		Data_B_ex          <=     32'h0;  
    		Imm_sel_ex         <=     2'b00;
    		Br_un_ex           <=     1'b0;
    		A_sel_ex           <=     1'b0;
    		B_sel_ex           <=     1'b0;
    		RegW_en_ex         <=     1'b0;
    		Mem_rw_ex          <=     1'b0;  
    		WB_sel_ex          <=     2'b00;
    		size_type_ex       <=     3'b000;
    		ALU_Sel_ex         <=     4'b0000; 
     		end
    else if(flush)begin 
          instruction_ex     <=     32'h0;
 	end
 
    else  
    begin

                pc_ex  <= pc_d;
    instruction_ex     <=     instruction_d;
    PC_sel_ex          <=     PC_sel_d;
    Data_A_ex          <=     Data_A_d;
    Data_B_ex          <=     Data_B_d;  
    Imm_sel_ex         <=     Imm_sel_d;
    Br_un_ex           <=     Br_un_d;
    A_sel_ex           <=     A_sel_d;
    B_sel_ex           <=     B_sel_d;
    RegW_en_ex         <=     RegW_en_d;
    Mem_rw_ex          <=     Mem_rw_d;  
    WB_sel_ex          <=     WB_sel_d;
    size_type_ex       <=     size_type_d;
    ALU_Sel_ex         <=     ALU_Sel_d;
    end          
end   
endmodule

