
module MUX2#(
    parameter WIDTH = 32
)
(   input sel,
	input [WIDTH-1:0] in0,in1,
	output reg[WIDTH-1:0] mux_out
);
always@*
    mux_out <= sel? in1
            :   in0;
endmodule
