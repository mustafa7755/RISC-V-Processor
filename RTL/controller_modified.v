module Controller#(
    parameter WIDTH = 32
)
(   //Controller inputs
    input [WIDTH-1:0]instruction,
    input Br_eq,Br_lt,
    //Controller outputs
    output reg [3:0] ALU_Sel,
    output reg [1:0] WB_sel,
    output reg [2:0] Imm_sel,
    output reg [2:0] size_type,
    output reg PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw
);   
    //ALU operations
    localparam add = 4'b0000, sub = 4'b0001, sll = 4'b0010, slt = 4'b0011, sltu = 4'b0100, Xor = 4'b0101,
               srl = 4'b0110, sra = 4'b0111, Or  = 4'b1000, And = 4'b1001, addw = 4'b1010, subw = 4'b1011,
               sllw = 4'b1100, srlw = 4'b1101, sraw = 4'b1110;   
    //Instructions Opcode
    localparam R_type1 = 7'b0110011, R_type2 = 7'b0111011; 
    localparam I_type1 = 7'b0000011, I_type2 = 7'b0001111, I_type3 = 7'b0010011,
               I_type4 = 7'b0011011, I_type5 = 7'b1100111, I_type6 = 7'b1110011;
    localparam S_type = 7'b0100011;
    localparam SB_type = 7'b1100011;
    localparam U1_type = 7'b0010111, U2_type = 7'b0110111;
    localparam UJ_type = 7'b1101111;
    //Parsing instruction
    wire [6:0] opcode;
    wire [2:0] func3;
    wire [6:0] func7;
assign opcode = instruction[6:0];
assign func3 = instruction[14:12];
assign func7 = instruction[31:25];

always @*
begin
	        //Controlling register file write enable
            RegW_en         =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2])    ||   //R1_type
		                        (~opcode[6] && ~opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2])    ||   //I1_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2])    ||   //I3_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] &&  opcode[2])    ||   //I5_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
		                        (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U2_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2]);        //UJ_type
            //Controlling branch unsigned
            Br_un           =   ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]          //SB_type
                                                          &&   func3[2] &&   func3[1] &&  ~func3[0])    ||   //bltu
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]      
                                                          &&   func3[2] &&   func3[1] &&   func3[0]);        //bgeu
            //Controlling memory read write
	        Mem_rw          =   (~opcode[6] &&  opcode[5] &&  opcode[4] &&  opcode[3] &&  opcode[2]);        //S_type 
            //Controlling B_sel
            B_sel           =   (~opcode[6] && ~opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2])    ||   //I1_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2])    ||   //I3_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] &&  opcode[2])    ||   //I5_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
		                        (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U2_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2])    ||   //UJ_type
                                ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2])    ||   //SB_type
                                (~opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]);        //S_type 
            //Controlling A_sel
            A_sel           =   (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2])    ||   //UJ_type
                                ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]);        //SB_type  
            //Controlling PC_sel
            PC_sel          =   ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] &&  opcode[2])    ||   //I5_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2])    ||   //UJ_type
                                ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //SB_type
                                                (( Br_eq  &&  ~func3[2] &&  ~func3[1] &&  ~func3[0])    ||   //beq 
                                                 (~Br_eq  &&  ~func3[2] &&  ~func3[1] &&   func3[0])    ||   //bne
                                                 ( Br_lt  &&   func3[2] &&  ~func3[1] &&  ~func3[0])    ||   //blt
                                                 ( Br_lt  &&   func3[2] &&   func3[1] &&  ~func3[0])    ||   //bltu
                                                 (~Br_lt  &&   func3[2] &&  ~func3[1] &&   func3[0])    ||   //bge
                                                 (~Br_lt  &&   func3[2] &&   func3[1] &&   func3[0])));      //bgeu
            //Controlling write back select
            WB_sel[0]       =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2])    ||   //R1_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2])    ||   //I3_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
                                (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2]);        //U2_type
            WB_sel[1]       =   ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] &&  opcode[2])    ||   //I5_type
		                        (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U2_type
		                        ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2]);        //UJ_type
            //Controlling immediate select
            Imm_sel[0]      =   (~opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2])    ||   //S_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
                                (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2]);        //U2_type
            Imm_sel[1]      =   ( opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2])    ||   //SB_type
		                        (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2])    ||   //U1_type
                                (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] &&  opcode[2]);        //U2_type
            Imm_sel[2]      =   ( opcode[6] &&  opcode[5] && ~opcode[4] &&  opcode[3] &&  opcode[2]);        //UJ_type
            //Controlling byte,half word,word size type
            size_type[0]    =   (~opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //S_type
                                                            ((~func3[2] &&  ~func3[1] &&   func3[0])    ||    
                                                             (~func3[2] &&   func3[1] &&   func3[0])))  ||
                                (~opcode[6] && ~opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I1_type
                                                            ((~func3[2] &&  ~func3[1] &&   func3[0])    ||    
                                                             (~func3[2] &&   func3[1] &&   func3[0])    ||                      
                                                             ( func3[2] &&  ~func3[1] &&   func3[0])));
            size_type[1]    =   (~opcode[6] &&  opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //S_type
                                                            ((~func3[2] &&  ~func3[1] &&  ~func3[0])    ||    
                                                             (~func3[2] &&   func3[1] &&   func3[0])))  ||
                                (~opcode[6] && ~opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I1_type
                                                            ((~func3[2] &&  ~func3[1] &&  ~func3[0])    ||    
                                                             (~func3[2] &&   func3[1] &&   func3[0])    ||                      
                                                             ( func3[2] &&  ~func3[1] &&  ~func3[0])));                        
            size_type[2]    =   (~opcode[6] && ~opcode[5] && ~opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I1_type
                                                            ((~func3[2] &&  ~func3[1] &&  ~func3[0])    ||    
                                                             (~func3[2] &&  ~func3[1] &&   func3[0])    ||                      
                                                             (~func3[2] &&   func3[1] &&  ~func3[0])    ||
                                                             (~func3[2] &&   func3[1] &&   func3[0])));
            //Controlling ALU selector
            ALU_Sel[0]      =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //R1_type
                                              ((~func3[2] &&  ~func3[1] &&  ~func3[0] &&   func7[5])    ||    
                                                             (~func3[2] &&   func3[1] &&  ~func3[0])    ||                      
                                                             ( func3[2] &&  ~func3[1] &&  ~func3[0])    ||
                                               ( func3[2] &&  ~func3[1] &&   func3[0] &&   func7[5])    ||              
                                                             ( func3[2] &&   func3[1] &&   func3[0])))  ||
                                (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I3_type
                                                            ((~func3[2] &&   func3[1] &&  ~func3[0])    ||                      
                                                             ( func3[2] &&  ~func3[1] &&  ~func3[0])    ||             
                                                             ( func3[2] &&   func3[1] &&   func3[0])));
            ALU_Sel[1]      =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //R1_type
                                              (( func3[2] &&  ~func3[1] &&   func3[0] &&  ~func7[5])    ||    
                                                             (~func3[2] &&  ~func3[1] &&   func3[0])    ||                      
                                                             (~func3[2] &&   func3[1] &&  ~func3[0])    ||
                                               ( func3[2] &&  ~func3[1] &&   func3[0] &&   func7[5])))  ||
                                (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I3_type
                                                            ((~func3[2] &&  ~func3[1] &&   func3[0])    ||                      
                                                             (~func3[2] &&   func3[1] &&  ~func3[0])));                       
            ALU_Sel[2]      =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //R1_type
                                              (( func3[2] &&  ~func3[1] &&   func3[0] &&  ~func7[5])    ||    
                                                             ( func3[2] &&  ~func3[1] &&  ~func3[0])    ||                      
                                                             (~func3[2] &&   func3[1] &&   func3[0])    ||
                                               ( func3[2] &&  ~func3[1] &&   func3[0] &&   func7[5])))  ||
                                (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I3_type
                                                            ((~func3[2] &&   func3[1] &&   func3[0])    ||                      
                                                             ( func3[2] &&  ~func3[1] &&  ~func3[0])));
            ALU_Sel[3]      =   (~opcode[6] &&  opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //R1_type
                                                            (( func3[2] &&   func3[1] &&  ~func3[0])    ||                      
                                                             ( func3[2] &&   func3[1] &&   func3[0])))  ||
                                (~opcode[6] && ~opcode[5] &&  opcode[4] && ~opcode[3] && ~opcode[2]     &&   //I3_type
                                                            (( func3[2] &&   func3[1] &&  ~func3[0])    ||                      
                                                             ( func3[2] &&   func3[1] &&   func3[0])));
end
endmodule

