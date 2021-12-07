module Forwarding_unit#(parameter WIDTH=32)
(
    input [WIDTH-1:0] instruction_ex,instruction_mem,instruction_wb,
    input RegW_en_mem,RegW_en_wb,
    output [1:0] forward_A,forward_B
);
wire [4:0] RD_mem,RD_wb;
wire [4:0] RS1_ex;
wire [4:0] RS2_ex;

assign RS1_ex = instruction_ex[19:15];
assign RS2_ex = instruction_ex[24:20];

assign RD_mem = instruction_mem[11:7];
assign RD_wb = instruction_wb[11:7];

assign forward_A[0] = RegW_en_wb && (RD_wb != 5'h0) && (RD_wb==RS1_ex);
assign forward_A[1] = RegW_en_mem && (RD_mem!=5'h0) && (RD_mem == RS1_ex);

assign forward_B[0] = RegW_en_wb && (RD_wb!=5'h0) && (RD_wb == RS2_ex);
assign forward_B[1] = RegW_en_mem && (RD_mem!=5'h0) && (RD_mem == RS2_ex);

endmodule

/*
always @*
begin
    //For execute stage hazard
    if(RegW_en_mem && (RD_mem!=5'h0) && (RD_mem == RS1_ex) )
        forward_A = 2'b10;
    else if (RegW_en_mem && (RD_mem!=5'h0) && (RD_mem == RS2_ex))
        forward_B = 2'b10;
    else begin
        forward_A = 2'b00;
        forward_B = 2'b00;
    end

    //For memory stage hazard
    if( RegW_en_wb && (RD_wb!=5'h0) && (RD_wb == RS1_ex))
        forward_A = 2'b01;
    else if (RegW_en_wb && (RD_wb!=5'h0) && (RD_wb == RS2_ex))
        forward_B = 2'b01;
    else begin
        forward_A = 2'b00;
        forward_B = 2'b00;
    end    
end
*/
