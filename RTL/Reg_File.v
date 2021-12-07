
module Reg_File#
(
  parameter AWIDTH=5,
  parameter DWIDTH=32
 )
 (
  input                 clk  ,
  input               RegW_en,
  input  [AWIDTH-1:0]   addrA,
  input  [AWIDTH-1:0]   addrB,
  input  [AWIDTH-1:0]   addrD,
  input  [DWIDTH-1:0]   dataD,
  output [DWIDTH-1:0]   dataA,
  output [DWIDTH-1:0]   dataB
 );

  reg [DWIDTH-1:0] register [2**AWIDTH-1:0];
  assign  dataA = register[addrA];
  assign  dataB = register[addrB];
always @ (negedge clk)
begin
        if(RegW_en)begin
            register[addrD] <= dataD;
	    register[0] <= {32{1'h0}};
	end
end
endmodule

