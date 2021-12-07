
module ALU#
(
   parameter WIDTH = 32  
)
(
	input [WIDTH-1:0]in_a,in_b,
	input [3:0]ALU_Sel,
	output reg[WIDTH-1:0]alu_out
);

    localparam add = 4'b0000, sub = 4'b0001, sll = 4'b0010, slt = 4'b0011, sltu = 4'b0100, Xor = 4'b0101,
               srl = 4'b0110, sra = 4'b0111, Or  = 4'b1000, And = 4'b1001, addw = 4'b1010, subw = 4'b1011,
               sllw = 4'b1100, srlw = 4'b1101, sraw = 4'b1110; 

always @* begin
    case(ALU_Sel)
	    add:    alu_out = in_a + in_b ;                      //add
	    sub:    alu_out = in_a - in_b;                       //sub
	    sll:    alu_out = in_a << in_b;                      //sll
	    slt:    alu_out = $signed(in_a) < $signed(in_b);     //slt
	    sltu:   alu_out = in_a < in_b;                       //sltu
	    Xor:    alu_out = in_a ^ in_b;                       //xor
	    srl:    alu_out = in_a >> in_b;                      //srl
	    sra:    alu_out = $signed($signed(in_a) >>> in_b);   //sra
	    Or:     alu_out = in_a | in_b;                       //or
            And:    alu_out = in_a & in_b;                       //and
//	    addw:   alu_out = in_a + in_b;                       //addw
//	    subw:   alu_out = in_a - in_b;                       //subw
//          sllw:   alu_out = in_a << in_b;                      //sllw
//	    srlw:   alu_out = in_a << in_b;                      //srlw
//	    sraw:   alu_out = in_a >>> in_b;                     //sraw
    default:        alu_out = 'hz;
    endcase
end
endmodule
