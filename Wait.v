module Wait(clock, resetn, enable, done);
	parameter cycles = 25000000;
	parameter size = 40;
	
	input clock, enable, resetn;
	output reg done;
	reg [size-1:0] count;
	reg newClock;
	
	always @(posedge clock or negedge enable or negedge resetn) begin
		if (!resetn) begin
			count = 5'b0;
			done <= 1'b0;
		end else begin
			if (!enable) begin
				done <= 1'b0;
				count <= 5'b0;
			end else begin
				if (count == cycles-1) begin
					count <= 5'b0;
					done <= 1'd1;
				end
				else
					count <= count + 5'b1;
			end
		end
	end
endmodule