
//Top Module
module single_cycle_risc
(
    input clk , 
    input reset
);

    localparam AWIDTH = 32, DWIDTH = 32;

//PC register
wire [DWIDTH-1:0] pc_in;
wire [DWIDTH-1:0] pc_f;
wire stall;

PC_reg#
(
    .WIDTH(DWIDTH)
)
pc_reg_inst
(
    .clk(clk), 
    .reset(reset),
    .stall(stall),
    .pc_in(pc_in), 
    .pc_out(pc_f)
);

//PC adder
wire [DWIDTH-1:0]pc4_f;

adder pc_adder
(
    .pc0(pc_f),
    .pc4(pc4_f)
);

//IMEM
wire [31:0] instruction_f;
IMEM imem_inst
(
    .pc(pc_f), 
    .instruction(instruction_f)  
);

//Register IF/ID
wire [31:0] pc_d;
wire [31:0] instruction_d;
wire flush;

Reg_IF_ID Reg_IF_ID_inst
(
    .clk(clk),
    .reset(reset),
    .stall(stall),
    .flush(flush),

    .pc_f(pc_f),
    .pc_d(pc_d),

    .instruction_f(instruction_f),
    .instruction_d(instruction_d)
);

//REGFILE
wire RegW_en_wb;
wire [DWIDTH-1:0] wb;
wire [DWIDTH-1:0] dataA_d,dataB_d;
wire [31:0] instruction_wb;

Reg_File reg_file
(
    .clk(clk), 
    .RegW_en(RegW_en_wb), 
    .addrA(instruction_d[19:15]), 
    .addrB(instruction_d[24:20]), 
    .addrD(instruction_wb[11:7]), 
    .dataD(wb),
    .dataA(dataA_d), 
    .dataB(dataB_d)   
);

//Controller
wire PC_sel_d, B_sel_d,A_sel_d,RegW_en_d;
wire [2:0] Imm_sel_d;
wire [2:0] size_type_d;
wire Mem_rw_d;
wire Br_un_d, Br_eq_ex, Br_lt_ex, Br_Un_ex;
wire [1:0] WB_sel_d;
wire [3:0] ALU_Sel_d;
wire [31:0]instruction_d_or_nop;

Controller controller_inst 
(  
    .Br_eq(Br_eq_ex),  
    .Br_lt(Br_lt_ex),  
    .instruction(instruction_d_or_nop),  
    .PC_sel(PC_sel_d),  
    .Imm_sel(Imm_sel_d),
    .RegW_en(RegW_en_d),  
    .Br_un(Br_un_d), 
    .A_sel(A_sel_d), 
    .B_sel(B_sel_d), 
    .ALU_Sel(ALU_Sel_d),
    .size_type(size_type_d),
    .Mem_rw(Mem_rw_d), 
    .WB_sel(WB_sel_d) 
);

//Register ID/Ex
wire [31:0] pc_ex;
wire [31:0] instruction_ex;
wire [31:0] rs1_ex,rs2_ex;

wire PC_sel_ex, B_sel_ex,A_sel_ex,RegW_en_ex,Mem_rw_ex;
wire [2:0] Imm_sel_ex;
wire [2:0] size_type_ex;
wire [1:0] WB_sel_ex;
wire Br_un_ex;
wire [3:0] ALU_Sel_ex;

Reg_ID_Ex Reg_ID_Ex_inst
(   
    .clk(clk),
    .reset(reset),

    .flush(flush),
    .stall(stall),

    .pc_d(pc_d),
    .pc_ex(pc_ex),

    .instruction_d(instruction_d_or_nop),
    .instruction_ex(instruction_ex),

    .Data_A_d(dataA_d),
    .Data_A_ex(rs1_ex),

    .Data_B_d(dataB_d),
    .Data_B_ex(rs2_ex),

    .PC_sel_d(PC_sel_d),

    .Imm_sel_d(Imm_sel_d),
    .Imm_sel_ex(Imm_sel_ex),

    .RegW_en_d(RegW_en_d),
    .RegW_en_ex(RegW_en_ex),  

    .Br_un_d(Br_un_d),
    .Br_un_ex(Br_un_ex),

    .A_sel_d(A_sel_d),
    .A_sel_ex(A_sel_ex), 

    .B_sel_d(B_sel_d),
    .B_sel_ex(B_sel_ex), 

    .ALU_Sel_d(ALU_Sel_d),
    .ALU_Sel_ex(ALU_Sel_ex),

    .size_type_d(size_type_d),
    .size_type_ex(size_type_ex),

    .Mem_rw_d(Mem_rw_d),
    .Mem_rw_ex(Mem_rw_ex), 

    .WB_sel_d(WB_sel_d),
    .WB_sel_ex(WB_sel_ex) 
); 

//BRANCH_COMP
wire [31:0] rs1_ex_frw;
wire [31:0] rs2_ex_frw;
//wire PC_sel_ex2;

Comparator br_cmp
(  
    .Br_un_ex(Br_un_ex),
 
    .instruction_ex(instruction_ex),

    .rs1(rs1_ex_frw),
    .rs2(rs2_ex_frw),
 
    .Br_eq(Br_eq_ex),  
    .Br_lt(Br_lt_ex)

  //  .PC_sel_ex2(PC_sel_ex2)  
);

//IMM_GEN
wire [DWIDTH-1:0] immediate_ex;

Imm_Gen imm_gen
(
    .instruction(instruction_ex),
    .Imm_sel(Imm_sel_ex), 
    .immediate(immediate_ex)
);

//ALU
wire [DWIDTH-1:0] DA,DB, alu_out_ex;

ALU alu_inst
(
    .in_a(DA), 
    .in_b(DB), 
    .ALU_Sel(ALU_Sel_ex), 
    .alu_out(alu_out_ex)
);

//Register Ex/MEM
wire [31:0] pc_mem;
wire [31:0] instruction_mem;
wire [31:0] alu_out_mem;
wire [31:0] rs2_mem;
wire [31:0] immediate_mem;

wire RegW_en_mem;
wire Mem_rw_mem;
wire [2:0] size_type_mem;
wire [1:0] WB_sel_mem;

//wire [31:0] rs2_ex_frw;

Reg_Ex_MEM Reg_Ex_MEM_inst
(
    .clk(clk),
    .reset(reset),

    .pc_ex(pc_ex),
    .pc_mem(pc_mem),

    .instruction_ex(instruction_ex),
    .instruction_mem(instruction_mem),

    .ALU_in(alu_out_ex),
    .ALU_out(alu_out_mem),

    .immediate_ex(immediate_ex),
    .immediate_mem(immediate_mem),

    .Data_B_in(rs2_ex_frw),
    .Data_B_out(rs2_mem),

    .RegW_en_ex(RegW_en_ex),
    .RegW_en_mem(RegW_en_mem),

    .Mem_rw_ex(Mem_rw_ex),
    .Mem_rw_mem(Mem_rw_mem),

    .WB_sel_ex(WB_sel_ex),
    .WB_sel_mem(WB_sel_mem),

    .size_type_ex(size_type_ex),
    .size_type_mem(size_type_mem)
); 

//DMEM
wire MemRW_mem;
wire [DWIDTH-1:0] dataR_mem;

Data_mem dmem_inst
( 
    .clk(clk), 
    .Mem_rw (Mem_rw_mem), 
    .addr (alu_out_mem) ,  
    .dataW (rs2_mem)  , 
    .size_type(size_type_mem),
    .dataR (dataR_mem)  
);

//Register MEM/WB
wire [31:0] pc_wb;
wire [31:0] alu_out_wb;
wire [31:0] dataR_wb;
wire [1:0]WB_sel_wb;
wire [31:0] immediate_wb;

Reg_MEM_WB Reg_MEM_WB_inst
(
    .clk(clk),
    .reset(reset),

    .pc_mem(pc_mem),
    .pc_wb(pc_wb),

    .instruction_mem(instruction_mem),
    .instruction_wb(instruction_wb),

    .immediate_mem(immediate_mem),
    .immediate_wb(immediate_wb),

    .ALU_in(alu_out_mem),
    .ALU_out(alu_out_wb),

    .Data_R_in(dataR_mem),
    .Data_R_out(dataR_wb),

    .WB_sel_mem(WB_sel_mem),
    .WB_sel_wb(WB_sel_wb),

    .RegW_en_mem(RegW_en_mem),
    .RegW_en_wb(RegW_en_wb)
);

//Hazard detection to stall
Data_Hazards_stalls Data_Hazards_stalls_inst
(
    .instruction_d(instruction_d),
    .instruction_ex(instruction_ex),
    .Br_Un_ex(Br_Un_ex),
    .Br_eq(Br_eq_ex),
    .Br_lt(Br_lt_ex),
    .PC_sel_ex(PC_sel_ex), 

    .flush(flush),
    .stall(stall)
);

//Forwarding unit
wire [1:0] forward_A,forward_B;

Forwarding_unit Forwarding_unit_inst
(
    .instruction_ex(instruction_ex),
    .instruction_mem(instruction_mem),
    .instruction_wb(instruction_wb),

    .forward_A(forward_A),
    .forward_B(forward_B),

    .RegW_en_mem(RegW_en_mem),
    .RegW_en_wb(RegW_en_wb)
);

//Forwardng A mux
//wire [31:0] rs1_ex_frw;
forwarding_mux forwardingA_mux_inst
(   
    .sel(forward_A), 
    .in0(rs1_ex), 
    .in1(wb), 
    .in2(alu_out_mem),
    .mux_out(rs1_ex_frw)
);

//Forwardng B mux
forwarding_mux forwardingB_mux_inst
(   
    .sel(forward_B), 
    .in0(rs2_ex), 
    .in1(wb), 
    .in2(alu_out_mem),
    .mux_out(rs2_ex_frw)
);

//Muxes

MUX4 m4_1
(   
    .sel(WB_sel_wb), 
    .in0(dataR_wb), 
    .in1(alu_out_wb), 
    .in2(pc_wb),
    .in3(immediate_wb), 
    .mux_out(wb)
);

MUX2 mux_stall_control
(
    .sel(stall), 
    .in0(instruction_d), 
    .in1(32'h0000_7033), 
    .mux_out(instruction_d_or_nop)
);

MUX2 m2_1
(
    .sel(PC_sel_ex), 
    .in0(pc4_f), 
    .in1(alu_out_ex), 
    .mux_out(pc_in)
);

MUX2 m2_2
(   
    .sel(B_sel_ex), 
    .in0(rs2_ex_frw), 
    .in1(immediate_ex), 
    .mux_out(DB)
);

MUX2 m2_3
(   
    .sel(A_sel_ex), 
    .in0(rs1_ex_frw), 
    .in1(pc_ex),  
    .mux_out(DA)
);

endmodule

