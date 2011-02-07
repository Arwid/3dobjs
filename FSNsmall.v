module FSNsmall(Clock, resetn, in1, in2, out, changing);
	input Clock, resetn, in1, in2;
	parameter bits = 9;
	parameter wrap = 1; // 1 - true, 0 - false
	parameter ClockSync = 1; // 1- true, 0 - false
	output [bits:0] out;
	output reg changing;
	parameter min = 0; // >= 0
	parameter max = 5;
	parameter [2:1] Stepper = 2'b01;
	
	reg [bits:0] StoredVal;
	reg [2:1] Step;
	parameter [2:1] A=2'b00, B=2'b01;
	
	initial begin
		StoredVal = min;
		changing = 0;
	end
	
	always @(posedge Clock or posedge resetn)
		if (resetn) // Reset All
			begin
				StoredVal = min;
				changing = 0;
			end
		else
			begin
				case(Step)
					A:
						begin
							if (in1 ^ in2)
								begin
									changing = 1;
									if (in1) // add
									begin
										StoredVal = StoredVal + Stepper;
										if (StoredVal > max) begin
											changing = 0;
											if (wrap == 1)
												StoredVal = min;
											else
												StoredVal = max;
										end
									end // subtract
									else
									begin
										StoredVal = StoredVal - Stepper;
										if (StoredVal[bits] == 1 | StoredVal < min) begin // negative
											changing = 0;
											if (wrap == 1)
												StoredVal = max;
											else
												StoredVal = min;
										end
									end
									if (ClockSync == 0)
										Step = B;
								end
							else
								changing = 0;
						end
					B: 
						begin
							changing = 0;
							if (!(in1 ^ in2))
								begin
									Step = A;
								end
						end
					default 
						begin
							Step = A;
							StoredVal = 0;
							changing = 0;
						end
				endcase
			end
			
			
	assign out = StoredVal;
	//assign out2 = StoredVal/100;
	//assign out1 = StoredVal/10 - out2*10;
	//assign out0 = StoredVal - out2*100 - out1*10;
endmodule