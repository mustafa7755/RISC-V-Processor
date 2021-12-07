module Data_Hazards_stalls#(parameter WIDTH=32)
(
    input [WIDTH-1:0] instruction_d,instruction_ex,
    input Br_eq,Br_lt,
    output stall,flush
);
//Parsing instruction
wire [4:0] RD_ex;
wire [4:0] RS1_d;
wire [4:0] RS2_d;
wire [6:0] opcode_ex;

assign RS1_d = instruction_d[19:15];
assign RS2_d = instruction_d[24:20];

assign RD_ex = instruction_ex[11:7];

assign opcode_d = instruction_d[6:0];
assign opcode_ex = instruction_ex[6:0];
//Hazard detection in case of load instruction followed by instruction dependent on it
assign stall = (opcode_ex==7'h3) && (RD_ex!=5'h0) && ( (RD_ex == RS1_d) || (RD_ex == RS2_d) );

assign flush = ((opcode_ex==7'b1100011) || (opcode_ex==7'b1101111) || (opcode_ex==7'b1100111)) && (Br_eq || Br_lt) ;

endmodule
