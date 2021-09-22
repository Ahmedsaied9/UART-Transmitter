module parity_gen #(parameter data_width = 8)(
input wire [data_width-1 :0] p_data,
input wire PAR_TYP,
output wire parity_bit
);

assign parity_bit = (PAR_TYP) ? ~^p_data : ^p_data;
endmodule