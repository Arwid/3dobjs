module DataPath2(Clock, resetn, add_sub, Enable, out);
	input Clock, resetn,add_sub,Enable;
	parameter bits = 9;
	output [bits:0] out;
	parameter min = 0;
	parameter max = 360;
	
	reg [10:0] StoredVal;
	reg[2:1] Step;
	parameter [2:1] A=2'b00, B=2'b01, C=2'b10, D=3'b11;
	
	always @(posedge Clock)
		if (resetn) // Reset All
			begin
				StoredVal = 0;
			end
		else
			begin
				case(Step)
					A:
						begin
							if (Enable)
								begin
									if (add_sub)
									begin
										StoredVal = StoredVal + 2'b01;
										if (StoredVal > max)
											StoredVal = min;
									end
									else
									begin
										StoredVal = StoredVal - 2'b01;
										if (StoredVal < min)
											StoredVal = max;
									end
									Step = B;
								end
						end
					B: 
						begin
							if (!Enable)
								begin
									Step = A;
								end
						end
					default 
						begin
							Step = A;
						end
				endcase
			end
	assign out = StoredVal;
	//assign out2 = StoredVal/100;
	//assign out1 = StoredVal/10 - out2*10;
	//assign out0 = StoredVal - out2*100 - out1*10;
endmodule