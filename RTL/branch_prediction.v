module branch_prediction#
(
    parameter WIDTH = 32
)
(
    input clk,reset,
    input [31:0] pc_f,
    input actual_prediction,
    input [31:0] branch_ex,
    output branch_prediction
);
integer i;
localparam GSHARE_BITS = 10;

reg [1:0] state [0:2**GSHARE_BITS];
reg [GSHARE_BITS:0] global_history = 0;

wire [GSHARE_BITS - 1:0] state_index = global_history [GSHARE_BITS - 1:0] ^ pc_f [GSHARE_BITS + 1:2];

always@(posedge clk or posedge reset)
begin
    //Reset
    if (reset)
    begin
        global_history <= 10'h0;
        state_index <= 10'h0;
    genvar i;
    generate
        for(i = 0; i < 2**GSHARE_BITS; i = i + 1)
            state[i] <= 2'b00;
    endgenerate
    end

    //No Reset
    else 
    begin
			if (branch_ex && actual_prediction) 
            begin
                global_history <= {global_history[n-2:0],actual_prediction};
				if (state[state_index] != 2'b11)
					state[state_index] <= state[state_index] + 2'b01;
			end 

            else 
            begin
                global_history <= {global_history[n-2:0],actual_prediction};
				if (state[state_index] != 2'b00)
					state[state_index] <= state[state_index] - 2'b01;
            end
    end
end

assign branch_prediction = state[state_index][1];

endmodule
