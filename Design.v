module Design(clock, resetn, Up, Right, Down, Left, Forward, Back, RotateRight, RotateLeft, RotateForward, RotateBack, 
add_sub_X, EnableX, add_sub_Y, EnableY, add_sub_Z, EnableZ, add_sub_R1, EnableR1, add_sub_R2, EnableR2, add_sub_R3, EnableR3);

	input clock, resetn, Up, Right, Down, Left, Forward, Back, RotateRight, RotateLeft, RotateForward, RotateBack;
	output add_sub_X, EnableX, add_sub_Y, EnableY, add_sub_Z, EnableZ, add_sub_R1, EnableR1, add_sub_R2, EnableR2, add_sub_R3, EnableR3;
	
	reg [3:1] State;
	parameter [3:1] 
	A=2'b000, 
	B=2'b001,
	C=3'b010,
	D=4'b011,
	E=5'b100;
	
	// Description
	// resetn == 0: cursor to (0,0);
	//
	// States: 
	// State1: reset to (0,0)
	// State2: wait for toggle
	// State3: move cursor by enabling resisters
	// State4: enable plot_dot signal and go to final state
	// State5: wait for all switched in off position before going back to state 1
	
	reg EnableX, EnableY, EnableZ, EnableR1, EnableR2, EnableR3,
		add_sub_X, EnableY, add_sub_Z, add_sub_R1, add_sub_R2, add_sub_R3,
		plot_dot;
	
	always @(posedge clock or negedge resetn)
	begin
		if (!resetn)
			State = A;
			
		case (State)
			A:
				begin
					plot_dot = 0;
					EnableX = 0;
					EnableY = 0;
					EnableZ = 0;
					EnableR1 = 0;
					EnableR2 = 0;
					EnableR3 = 0;
					State = B;
				end
			
			B:
				begin
					if (Up|Right|Down|Left|Forward|Back|RotateRight|RotateLeft|RotateForward|RotateBack);
						State = C;
					else
						State = B;
				end
			C:
				begin
					if (Up^Down)
						begin
							EnableY = 1;
							add_sub_Y = up ? 1 : 0;
						end
					if (Left^Right)
						begin
							EnableX = 1;
							add_sub_X = right ? 1 : 0;
						end
					State = D;
				end
			D:
				begin
					EnableX = 0;
					EnableY = 0;
					plot_dot = 1;
					State = E;
				end
			E:
				begin
					if (!(up|down|left|right))
						State = B;
				end
				
			default
				State = A;
		endcase
	end
		
endmodule