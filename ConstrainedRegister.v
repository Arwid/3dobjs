module ConstrainedRegister(Clock, resetn, in1, in2, out);
	input Clock, resetn, in1, in2;
	parameter bits = 9;
	parameter wrap = 1; // 1 - true, 0 - false
	parameter ClockSync = 1; // 1- true, 0 - false
	output [bits:0] out;
	parameter min = 0; // >= 0
	parameter max = 5;
	parameter [2:1] Stepper = 2'b01;
	
	reg [bits:0] StoredVal;
	reg[2:1] Step;
	parameter [2:1] A=2'b00, B=2'b01;
	
	always @(posedge Clock or posedge resetn)
		if (resetn) // Reset All
			begin
				StoredVal = 0;
			end
		else
			begin
				case(Step)
					A:
						begin
							if (in1 ^ in2)
								begin
									if (in1) // add
									begin
										StoredVal = StoredVal + Stepper;
										if (StoredVal > max)
											if (wrap == 1)
												StoredVal = min;
											else
												StoredVal = max;
									end // subtract
									else
									begin
										StoredVal = StoredVal - Stepper;
										if (StoredVal[bits] == 1 | StoredVal < min) // negative
											if (wrap == 1)
												StoredVal = max;
											else
												StoredVal = min;
									end
									if (ClockSync == 0)
										Step = B;
								end
						end
					B: 
						begin
							if (!(in1 ^ in2))
								begin
									Step = A;
								end
						end
					default 
						begin
							Step = A;
							StoredVal = 0;
						end
				endcase
			end
			
			
	assign out = StoredVal;
	//assign out2 = StoredVal/100;
	//assign out1 = StoredVal/10 - out2*10;
	//assign out0 = StoredVal - out2*100 - out1*10;
endmodule