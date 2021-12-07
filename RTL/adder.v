
module adder#
(
    parameter WIDTH = 32
)
(
    input [WIDTH-1:0] pc0,
    output [WIDTH-1:0] pc4
);

    assign pc4 = pc0 + 32'h4;
endmodule
