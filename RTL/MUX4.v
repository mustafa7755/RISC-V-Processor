module MUX4#(
   parameter WIDTH = 32
)
(   input [1:0]sel,
    input [WIDTH-1:0] in0,in1,in2,in3,
    output reg[WIDTH-1:0] mux_out
);
always@*
begin
    if(sel==00)
	mux_out = in0;
    else if(sel==01)
	mux_out = in1;
    else if(sel==10)
	mux_out = in2;
    else 
	mux_out = in3;
end
endmodule

