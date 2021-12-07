module Reg_IF_ID #(parameter WIDTH = 32)
(
    //inputs
    input clk,reset,stall,flush,
    input [WIDTH-1:0] pc_f,
    input [WIDTH-1:0] instruction_f,
    //outputs
    output reg [WIDTH-1:0] pc_d,instruction_d
);

always @(posedge clk,posedge reset)
begin

    pc_d = (reset) ? 32'h0
            :  (stall) ? pc_d
            :            pc_f;

    instruction_d = (reset || flush) ? 32'h0
                    :  (stall) ? instruction_d
                    :            instruction_f;

end 
endmodule

