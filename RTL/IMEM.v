
module IMEM#(
  parameter AWIDTH=32,
  parameter DWIDTH=32
)
(
    input [AWIDTH-1:0] pc,
    output reg [DWIDTH-1:0] instruction
);

    reg [7:0] imem [0:1023]; 

    always @*
    begin
          instruction[31:24] = imem[pc];
          instruction[23:16] = imem[pc+1];
          instruction[15:8] = imem[pc+2];
          instruction[7:0] = imem[pc+3];
    end
endmodule

