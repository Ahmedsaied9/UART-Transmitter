`timescale 1ns/100ps

module UART_TOP_tb();

localparam CLK_period = 2.5;
localparam D_width = 8;

	reg	[D_width-1 :0]	P_DATA;
	reg					DATA_VALID;
	reg					PAR_EN;
	reg					PAR_TYP;
	reg					CLK,RST;
	wire				S_DATA,BUSY	;	
	

always #CLK_period CLK = ~CLK;

UART_TOP #(.D_width(D_width)) DUT(
.P_DATA(P_DATA),
.DATA_VALID(DATA_VALID),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP),
.CLK(CLK),
.RST(RST),
.S_DATA(S_DATA),
.BUSY(BUSY)
);	

initial 
begin
	$dumpfile("UART.vcd");
	$dumpvars;
	CLK = 1'b1;
	
	//***********************Even Parity Case**********************\\\\\\\\\\\\\\\\\\\
	
	P_DATA = 8'h3F;
	PAR_EN = 1'b1;
	PAR_TYP = 1'b0;
	DATA_VALID = 1'b0;
	reset();
	#(CLK_period*4)
	Valid();
	#(15*2*CLK_period)
//************************Odd Parity Case**********************\\\\\\\\\\\\\\\\\\\	
	P_DATA = 8'b01010101;
	PAR_EN = 1'b1;
	PAR_TYP = 1'b1;
	DATA_VALID = 1'b0;
	reset();
	#(CLK_period*4)
	Valid();
	#(15*2*CLK_period)
	
	
//************************Parity disabled Case & DATA_VALID is high during transmission**********************\\\\\\\\\\\\\\\\\\\
	
	P_DATA = 8'b01010101;
	PAR_EN = 1'b0;
	PAR_TYP = 1'b0;
	DATA_VALID = 1'b0;
	reset();
	#(CLK_period*4)
	Valid();
	#(2*2*CLK_period)
	P_DATA = 8'h11;
	Valid();
	#(15*2*CLK_period)
	
	
	
	
	$finish;
end

task reset;
begin 
	RST = 1'b1;
	#(CLK_period/2)
	RST = 1'b0;
	#(CLK_period/2)
	RST = 1'b1;
end
endtask

task Valid;
begin
	DATA_VALID = 1'b1;
	#(CLK_period*2)
	DATA_VALID = 1'b0;
end
endtask
endmodule