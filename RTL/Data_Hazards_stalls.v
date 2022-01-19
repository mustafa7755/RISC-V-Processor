module Data_Hazards_stalls#(parameter WIDTH=32)
(
    input [WIDTH-1:0] instruction_d,instruction_ex,
    input Br_eq,Br_lt,
    output reg PC_sel_ex, Br_Un_ex,
    output stall,flush
);
wire [4:0]RS1_d;
wire [4:0]RS2_d;
wire [4:0]RD_ex;
wire [6:0]opcode_ex;
wire [2:0] func3_ex;

//Parsing instruction
assign RS1_d = instruction_d[19:15];
assign RS2_d = instruction_d[24:20];
assign RD_ex = instruction_ex[11:7];
assign func3_ex = instruction_ex[14:12];
assign opcode_ex = instruction_ex[6:0];
//Hazard detection in case of load instruction followed by instruction dependent on it
assign stall = (opcode_ex==7'h3) && (RD_ex!=5'h0) && ( (RD_ex == RS1_d) || (RD_ex == RS2_d) );

assign flush = PC_sel_ex;

always@(*)
begin
	if(opcode_ex==7'b1100011)
        case(func3_ex)
            3'b000: begin  //beq
                Br_Un_ex = 1'b0; 
                PC_sel_ex = Br_eq? 1'b1 : 1'b0;
            end
            3'b001:  begin //bne
                Br_Un_ex = 1'b0; 
                PC_sel_ex = Br_eq? 1'b0 : 1'b1; 
            end
            3'b100:  begin //blt
                Br_Un_ex = 1'b0; 
                PC_sel_ex = Br_lt? 1'b1 : 1'b0; 
            end
            3'b101:  begin //bge
                Br_Un_ex = 1'b0; 
                PC_sel_ex = Br_lt? 1'b0 : 1'b1; 
            end
            3'b110:  begin //bltu
                Br_Un_ex = 1'b1; 
                PC_sel_ex = Br_lt? 1'b1 : 1'b0; 
            end
            3'b111:  begin //bgeu
                Br_Un_ex = 1'b1; 
                PC_sel_ex = Br_lt? 1'b0 : 1'b1; 
            end
        endcase
	else if (opcode_ex==7'b1101111||opcode_ex==7'b1100111)
		PC_sel_ex = 1;
	else
		PC_sel_ex=0;
end
endmodule

