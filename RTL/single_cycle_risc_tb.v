module single_cycle_risc_tb#
(
    localparam DWIDTH = 32,
    localparam AWIDTH = 32
)
();
     reg clk,reset;
     integer i;
//Top Module Instantiation
single_cycle_risc single_cycle_risc_inst(.*);
//Task to generate clock
initial repeat (95) begin #5 clk=1; #5 clk=0; end
initial begin
//Initializing Register File
for(i=0; i<32; i=i+1)
	single_cycle_risc_inst.reg_file.register[i] = 32'h0;
$readmemh("test_cases.txt", single_cycle_risc_inst.imem_inst.imem);
#5;  reset = 1'b1;
#5;  reset = 1'b0;
end
endmodule
