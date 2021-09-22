module FSM (
input PAR_EN,
input Valid,
input RST,CLK,
input OUT_flag,
output reg busy,ser_en,
output reg [1:0]  sel
);

localparam [1:0] Idle = 2'b00,
				 ser_data = 2'b10,
				 PAR	  = 2'b11,
				 stop	  = 2'b01;

reg [1:0]	current_state, next_state;				 
				 
always @ (posedge CLK or negedge RST)
begin
	if(!RST)
	begin
		current_state <= Idle;
	end
	else
		current_state <= next_state;
end

//Next_state logic
always @ (*)
begin
	case (current_state)
	
		Idle	:	begin
						
						if(Valid == 1'b1)
							next_state = ser_data;
						else
							next_state = Idle;
					end
		
		ser_data	:	begin
						if(OUT_flag == 1'b1)
							next_state = ser_data;
						else if (PAR_EN)
							next_state = PAR;
						else	
							next_state = stop;
					end
		
		PAR	:	begin
						
						next_state = stop;
				end		
		
		stop	:	begin
						next_state = Idle;
					end			
	endcase
end

always @ (*)
begin
case (current_state)
	
		Idle	:	begin
						ser_en = 0;
						busy = 0;
						sel = 2'b10;
					end
		
		ser_data	:	begin
						ser_en = 'b1;
						busy = 1'b1;
						sel = 2'b00;
					end
		
		PAR	:	begin
						ser_en = 1'b0;
						busy = 1'b1;
						sel = 2'b01;
				end		
		
		stop	:	begin
						ser_en = 1'b1;
						busy = 1'b1;
						sel = 2'b11;
					end			
	endcase
end



endmodule				 