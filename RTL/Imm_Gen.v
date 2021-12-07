
module Imm_Gen#(
    parameter WIDTH = 32
)
(
    input [WIDTH-1:0]instruction,
    input [2:0]Imm_sel,
    output reg [WIDTH-1:0] immediate 
);

always @*
begin
    case(Imm_sel)
            3'b000:     immediate = {instruction[31]? {20{1'b1}}:20'b0 , instruction[31:20]};                                        //I-type 
            3'b001:     immediate = {instruction[31]? {20{1'b1}}:20'b0 , instruction[31:25], instruction[11:7]};                     //S-type
            3'b010:     immediate = {instruction[31]? {20{1'b1}}:20'b0 , instruction[7], instruction[30:25],instruction[11:8],1'b0}; //SB-type
            3'b011:     immediate = {instruction[31:12], {12{1'b0}}};                                                                //U1-U2-type
            3'b100:     immediate = {instruction[31]? {20{1'b1}}:20'b0 , instruction[19:12], instruction[19:12],instruction[20],         
                                        instruction[30:25],instruction[24:21],1'b0};                                                 //UJ-type
            default:    immediate = 32'b0;
    endcase
end
endmodule
