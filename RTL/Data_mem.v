
module Data_mem#
(
  parameter AWIDTH=32,
  parameter DWIDTH=32
 )
 (
  input  clk, Mem_rw,
  input  [AWIDTH-1:0]   addr,
  input  [DWIDTH-1:0]   dataW,
  input  [2:0] size_type,
  output reg [DWIDTH-1:0] dataR
 );

  localparam load_word = 3'b000, load_half_word = 3'b001, load_byte = 3'b010,
             load_word_signed = 3'b100, load_half_word_signed = 3'b101,
             load_byte_signed = 3'b110, load_double_word = 3'b111;

  localparam store_word = 2'b00, store_half_word = 2'b01, store_byte = 2'b10, store_double_word = 2'b11;

  reg [7:0] dmem [0:255];

//Synchronous write
always @(posedge clk)
begin
    if ( Mem_rw )
    begin
      case(size_type[1:0])

          store_word:
          begin
                dmem[addr] = dataW[7:0];
                dmem[addr+1] = dataW[15:8];
                dmem[addr+2] = dataW[23:16];
                dmem[addr+3] = dataW[31:24];
          end

          store_half_word:
          begin
                dmem[addr] = dataW[7:0];
                dmem[addr+1] = dataW[15:8];
                dmem[addr+2] = 8'h0;
                dmem[addr+3] = 8'h0;
          end

          store_byte:
          begin
                dmem[addr] = dataW[7:0];
                dmem[addr+1] = 8'h0;
                dmem[addr+2] = 8'h0;
                dmem[addr+3] = 8'h0;
          end

          store_double_word:
          begin
                //for 64-bit
          end
      endcase
    end
end

//Asynchronous read
always @*
begin
  case(size_type)

      load_word:  
      begin
                dataR[7:0] = dmem[addr];
                dataR[15:8] = dmem[addr+1];
                dataR[23:16] = dmem[addr+2];
                dataR[31:24] = dmem[addr+3];
      end

      load_half_word:
      begin
                dataR[7:0] = dmem[addr];
                dataR[15:8] = dmem[addr+1]; 
		dataR[31:16] = {16{1'h0}};
      end

      load_byte:
      begin
                dataR[7:0] = dmem[addr];
		dataR[31:8] = {24{1'h0}};
      end

      load_word_signed:  
      begin
                dataR[7:0] = dmem[addr];
                dataR[15:8] = dmem[addr+1];
                dataR[23:16] = dmem[addr+2];
                dataR[31:24] = dmem[addr+3];
      end
      
      load_half_word_signed:
      begin
                dataR[7:0] = dmem[addr];
                dataR[15:8] = dmem[addr+1]; 
		dataR[31:16] = {16{dataR[15]}};
      end

      load_byte_signed:
      begin
                dataR[7:0] = dmem[addr];
                dataR[31:8] = dataR[7]? {24{1'b1}} : {24{1'b0}}; 
      end

      load_double_word:
      begin
                //for 64-bit 
      end
  endcase
end
endmodule




    