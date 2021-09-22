module UART_TOP #(parameter D_width = 8 )
(
	input	[D_width-1 :0]	P_DATA,
	input					DATA_VALID,
	input					PAR_EN,
	input					PAR_TYP,
	input					CLK,RST,
	output	wire				S_DATA,BUSY				
);
wire serialize_en, out_flag, ser_out,  par_bit;
wire [1:0] sel;
wire	s_data, busy;

Serializer #(.data_width(D_width)) U1(	
    .p_data(P_DATA),
	.serialize_en(serialize_en), 
	.ser_RST(DATA_VALID), 
	.CLK(CLK),
	.busy(busy),
	.ser_out(ser_out), 
	.out_flag(out_flag)
);

FSM U2 (
.PAR_EN(PAR_EN),
.Valid(DATA_VALID),
.RST(RST),
.CLK(CLK),
.OUT_flag(out_flag),
.busy(busy),
.ser_en(serialize_en),
.sel(sel) 
);

parity_gen #(.data_width(D_width)) U3 (
	.p_data(P_DATA),
	.PAR_TYP(PAR_TYP),
	.parity_bit(par_bit)
);

MUX U4 (
.ser_data(ser_out),
.par_bit(par_bit),
.sel(sel),
.CLK(CLK),
.S_DATA(S_DATA)
);

assign BUSY = busy;

/*always @ (posedge CLK)
begin
	S_DATA <= s_data;
	
	BUSY <= busy;
end*/

endmodule