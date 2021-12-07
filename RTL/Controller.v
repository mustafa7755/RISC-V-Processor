
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
case(opcode)

//R-type instruction
	R_type1:
	begin
        case(func3)
            3'b000:	ALU_Sel = func7[5]? sub : add;
            3'b001:	ALU_Sel = sll;
            3'b010:	ALU_Sel = slt;
            3'b011:	ALU_Sel = sltu;
            3'b100:	ALU_Sel = Xor;
            3'b101:	ALU_Sel = func7[5]? sra : srl;
            3'b110:	ALU_Sel = Or;
            3'b111:	ALU_Sel = And;
           default: ALU_Sel = 32'hz;
        endcase
            {PC_sel,Imm_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw,WB_sel} = 11'b0_000_1_0_0_0_0_01;
	end
    R_type2:
	begin
        case(func3)
            3'b000:	ALU_Sel = func7[5]? subw : addw;
            3'b001:	ALU_Sel = sllw;
            3'b101:	ALU_Sel = func7[5]? sraw : srlw;
           default: ALU_Sel = 32'hz;
        endcase
            {PC_sel,Imm_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw,WB_sel} = 11'b0_000_1_0_0_0_0_01;
	end

//I-type instruction
	I_type1:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b000;
            WB_sel = 2'b00;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_1_0_0_0_0;

            case(func3)
                3'b000:         size_type = 3'b110;  //load byte signed
                3'b001:         size_type = 3'b101;  //load half word signed
                3'b010:         size_type = 3'b100;  //load word signed
                3'b011:         size_type = 3'b111;  //load double word
                3'b100:         size_type = 3'b010;  //load byte unsigned
                3'b101:         size_type = 3'b001;  //load half word unsigned
                3'b110:         size_type = 3'b000;  //load word unsigned

                default:        size_type = 3'b000;
            endcase
            
	end

    I_type3:
	begin
        case(func3)
            3'b000:	ALU_Sel = add;
            3'b001:	ALU_Sel = sll;
            3'b010:	ALU_Sel = slt;
            3'b011:	ALU_Sel = sltu;
            3'b100:	ALU_Sel = Xor;
            3'b101:	ALU_Sel = srl;
            3'b110:	ALU_Sel = Or;
            3'b111:	ALU_Sel = And;
            default: ALU_Sel = 32'hz;
        endcase
            Imm_sel = 3'b000;
            WB_sel = 2'b01;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_1_0_1_0_0;    
	end

    I_type5:
	begin
            ALU_Sel = add;   
            Imm_sel = 3'b000;
            WB_sel = 2'b10;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b1_1_0_1_0_0;
	end

//S-type instruction
	S_type:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b001;
            WB_sel = 2'b00;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_0_0_1_0_1;

            case(func3)
                3'b000:         size_type = 3'b010;  //store byte
                3'b001:         size_type = 3'b001;  //store half word
                3'b010:         size_type = 3'b000;  //store word
                3'b011:         size_type = 3'b011;  //store double word
                default:        size_type = 3'b000;
            endcase
	end

//SB-type instruction
	SB_type:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b010;
            WB_sel = 2'b00;
            RegW_en = 1'b0;
            A_sel = 1'b1;
            B_sel = 1'b1;
            Mem_rw = 1'b0;
        case(func3)
            3'b000: begin  //beq
                Br_un = 1'b0; 
                PC_sel = Br_eq? 1'b1 : 1'b0;
            end
            3'b001:  begin //bne
                Br_un = 1'b0; 
                PC_sel = Br_eq? 1'b0 : 1'b1; 
            end
            3'b100:  begin //blt
                Br_un = 1'b0; 
                PC_sel = Br_lt? 1'b1 : 1'b0; 
            end
            3'b101:  begin //bge
                Br_un = 1'b0; 
                PC_sel = Br_lt? 1'b0 : 1'b1; 
            end
            3'b110:  begin //bltu
                Br_un = 1'b1; 
                PC_sel = Br_lt? 1'b1 : 1'b0; 
            end
            3'b111:  begin //bgeu
                Br_un = 1'b1; 
                PC_sel = Br_lt? 1'b0 : 1'b1; 
            end
        endcase

	end

//U-type instruction
	U1_type:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b011;
            WB_sel = 2'b01;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_1_0_1_1_0;
	end

	U2_type:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b011;
            WB_sel = 2'b11;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_1_0_1_1_0;
	end


//UJ-type instruction
	UJ_type:    
	begin
            ALU_Sel = add;
            Imm_sel = 3'b100;
            WB_sel = 2'b10;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b1_1_0_1_1_0;
	end

	default:
	begin
	    ALU_Sel = add;
            Imm_sel = 3'b100;
            WB_sel = 2'b10;
            {PC_sel,RegW_en,Br_un,B_sel,A_sel,Mem_rw} = 6'b0_1_0_1_1_0;
	end 
endcase

end
endmodule
