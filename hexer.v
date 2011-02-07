module hexer(Clock, resetn, switchUp, switchDown, autoChange, 
	Tx, TxChanging, Ty, TyChanging, Tz, TzChanging, Rx, RxChanging, Ry, RyChanging, Rz, RzChanging, Sx, SxChanging, Sy, SyChanging, Sz, SzChanging, 
	hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0, changing);
	
	input Clock, resetn, switchUp, switchDown, autoChange;
	input TxChanging, TyChanging, TzChanging, RxChanging, RyChanging, RzChanging, SxChanging, SyChanging, SzChanging;
	parameter size = 9;
	input [size:0] Tx, Ty, Tz, Rx, Ry, Rz, Sx, Sy, Sz;
	
	output [3:0] hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7;
	reg[4:0] Step;
	reg[4:0] StepHex;
	parameter [4:0] A=4'd0, B=4'd1, C=4'd2, D=4'd3, E=4'd4, F=4'd5, G=4'd6, H=4'd7, I=4'd8, J=4'd9, K=4'd10;
	
	reg [3:0] hex7,hex6,hex5,hex4,hex3,hex2,hex1,hex0;
	reg [size:0] value;
	output changing;
	
	assign changing = TxChanging + TyChanging + TzChanging + RxChanging + RyChanging + RzChanging + SxChanging + SyChanging + SzChanging;
	
	initial begin
		value = 0;
		StepHex = A;
		Step = A;
		
		hex7 = 0;
		hex6 = 0;
		hex5 = 0;
		hex4 = 0;
		hex3 = 0;
		hex2 = 0;
		hex1 = 0;
		hex0 = 0;
	end	
	
	always @(posedge Clock or posedge resetn) begin
		if (resetn) begin
			value = 0;
			StepHex = B;
			Step = A;
		end else begin
			if (autoChange) begin
				if (TxChanging)			StepHex = B;
				else if (TyChanging)	StepHex = C;
				else if (TzChanging)	StepHex = D;
				else if (RxChanging)	StepHex = E;
				else if (RyChanging)	StepHex = F;
				else if (RzChanging)	StepHex = G;
				else if (SxChanging)	StepHex = H;
				else if (SyChanging)	StepHex = I;
				else if (SzChanging)	StepHex = J;
			end else begin
				case (Step)
					A: 
					begin
						if (switchUp ^ switchDown) begin
							StepHex = StepHex + (switchUp ? 5'd1 : -5'd1);
							if (StepHex > J) StepHex = B;
							if (StepHex < B) StepHex = J;
							Step = B;
						end
					end
					B:
					begin
						if (!(switchUp ^ switchDown))
							Step = A;
						else
							Step = B;
					end
					default Step = A;
				endcase
			end
			
			case (StepHex)
				A: begin value = 0;	 hex7 = 0;			hex6 = 0;		end
				B: begin value = Tx; hex7 = 4'b1010; 	hex6 = 0;		end
				C: begin value = Ty; hex7 = 4'b1011; 	hex6 = 0;		end
				D: begin value = Tz; hex7 = 4'b1100; 	hex6 = 0; 		end
				E: begin value = Rx; hex7 = 4'b1101; 	hex6= 4'b1010; end
				F: begin value = Ry; hex7 = 4'b1101; 	hex6 = 4'b1011; end
				G: begin value = Rz; hex7 = 4'b1101; 	hex6 = 4'b1100; end
				H: begin value = Sx; hex7 = 4'b1110; 	hex6 = 4'b1010; end
				I: begin value = Sy; hex7 = 4'b1110; 	hex6 = 4'b1011; end
				J: begin value = Sz; hex7 = 4'b1110; 	hex6 = 4'b1100; end
				default StepHex = B;
			endcase
			
			hex5 = value/100000;
			hex4 = value/10000 - hex5*10;
			hex3 = value/1000 - hex5*100 - hex4*10;
			hex2 = value/100 - hex5*1000 - hex4*100 - hex3*10;
			hex1 = value/10 - hex5*10000 - hex4*1000 - hex3*100 - hex2*10;
			hex0 = value - hex5*100000 - hex4*10000 - hex3*1000 - hex2*100 - hex1*10;
			
			/*
			hex5 = value/100000;
			hex4 = value/10000 - hex5*10;
			hex3 = value/1000 - hex5*100 - hex4*10;
			hex2 = value/100 - hex5*1000 - hex4*100 - hex3*10;
			hex1 = value/10 - hex5*10000 - hex4*1000 - hex3*100 - hex2*10;
			hex0 = value - hex5*100000 - hex4*10000 - hex3*1000 - hex2*100 - hex1*10;
			/*
			hex2 = value/100;
			hex1 = value/10 - hex2*10;
			hex0 = value - hex2*100 - hex1*10;*/
			
		end
	end
	
	
	// X: 1010
	// Y: 1011
	// Z: 1100
	// R: 1101
	// S: 1110
endmodule