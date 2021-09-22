module MUX (
input ser_data,par_bit,CLK,
input [1:0] sel,
output reg S_DATA
);

always @ (*)
begin
	case (sel)
	
		2'b00 : S_DATA = ser_data;
		2'b01 : S_DATA = par_bit;
		2'b11 : S_DATA = 1'b0;
		2'b10 : S_DATA = 1'b1;
	endcase
end
endmodule