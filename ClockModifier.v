module ClockModifier(clock, reset, newClock);
	parameter hertz = 25000000;
	parameter size = 25;
	
	input clock, reset;
	output newClock;
	reg [size-1:0] count;
	reg newClock;
	
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			count = 5'b0;
			newClock = 0;
		end
		else begin
			if (count == hertz-1) begin
				count <= 5'b0;
				newClock = !newClock;
			end
			else
				count <= count + 5'b1;
		end
	end
endmodule