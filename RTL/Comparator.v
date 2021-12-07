
module Comparator#(
  parameter DWIDTH=32
 )
 (
  input   Br_un ,
  input  [DWIDTH-1:0] rs1,rs2,instruction_ex,
  output  Br_eq, Br_lt,PC_sel_ex2
 );
wire [6:0] opcode_ex;

assign opcode_ex = instruction_ex[6:0];

assign Br_eq = (rs1 == rs2);
assign Br_lt = Br_un ? (rs1 <  rs2) : ($signed(rs1) <  $signed(rs2));

assign PC_sel_ex2 = ((opcode_ex==7'b1100011) || (opcode_ex==7'b1101111) || (opcode_ex==7'b1100111)) && (Br_eq || Br_lt);
 
endmodule
