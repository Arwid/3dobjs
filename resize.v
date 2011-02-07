module resize(writeEnIn, writeEnOut, x_in, y_in, x, y);
	parameter INPUT_SIZE = 9;
	parameter HORIZONTAL = 8;
	parameter VERTICAL = 7;
	input [INPUT_SIZE:0] x_in, y_in;
	output reg [HORIZONTAL:0] x;
	output reg [VERTICAL:0] y;
	input writeEnIn;
	output reg writeEnOut;
	
	// disable if out of bounds
	always @(*) begin
		if (writeEnIn) begin
			x = x_in;
			y = y_in;
			if (y_in[INPUT_SIZE]) y[VERTICAL] = 1;
			if (x_in[INPUT_SIZE]) x[HORIZONTAL] = 1;
			
			x = x + 80;
			y = 120 - (y + 60);
			if (x >= 0 && x < 160 && y >= 0 && y < 120)
				writeEnOut = 1;
			else
				writeEnOut = 0;
		end else begin
			writeEnOut = 0;
		end
	end
endmodule