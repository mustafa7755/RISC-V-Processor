module PC_reg#(
    parameter WIDTH = 32
)
(   input clk,reset,stall,//flush,
    input  [WIDTH-1:0] pc_in,
    output reg [WIDTH-1:0] pc_out
);
always @(posedge clk or posedge reset)
begin
    pc_out = (reset) ? 32'h0
            :  (stall) ? pc_out
            :            pc_in;
end
endmodule

