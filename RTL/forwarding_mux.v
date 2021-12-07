
module forwarding_mux#(
   parameter WIDTH = 32
)
(   input [1:0]sel,
    input [WIDTH-1:0] in0,in1,in2,
    output reg[WIDTH-1:0] mux_out
);
always@*
begin
    case(sel)
	2'b00: mux_out = in0;
	2'b01: mux_out = in1;
	2'b10: mux_out = in2;
	default: mux_out = in0;
    endcase
end
endmodule
