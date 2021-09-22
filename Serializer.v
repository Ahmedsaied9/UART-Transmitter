module Serializer #(parameter data_width = 8) 
(
	input wire [data_width-1 :0] p_data,
	input wire serialize_en, ser_RST, CLK,busy,
	output reg ser_out, 
	output			out_flag
);
localparam count_width = 3; 

reg [data_width-1 :0]	data_reg;
reg [count_width:0]	count;
wire count_flag;

always @ (posedge CLK)
begin
	if (ser_RST && !busy)
	begin
		data_reg <= p_data;
		count <= 'b0;
		//out_flag <= 1'b1;
		ser_out <= 1'b0;
	end
	else if (serialize_en && out_flag )
	begin
		{data_reg,ser_out} <= {1'b0,data_reg};
		count <= count+'b1;
		//out_flag <= 1'b1;
	end
	else 
	begin
		count <= count;
		//out_flag <= 1'b0;
		//ser_out <= 1'b1;
	end
end

assign out_flag = (count == data_width) ? 1'b0 : 1'b1;
endmodule