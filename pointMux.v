module pointMux(x0, y0, color0, x1, y1, color1, x, y, color, write0, write1, writeEn);
	input [7:0] x0, x1;
	input [6:0] y0, y1;
	parameter COLOR_CHANNEL_DEPTH = 2;
	input [(3*COLOR_CHANNEL_DEPTH - 1):0] color0;
	input [(3*COLOR_CHANNEL_DEPTH - 1):0] color1;
	
	input write0, write1;
	output reg writeEn;
	output reg [7:0] x;
	output reg [6:0] y;
	
	output reg [(3*COLOR_CHANNEL_DEPTH - 1):0] color;
	
	always @(*) begin
		writeEn = write0 ^ write1;
		if (writeEn) begin
			if (write0) begin
				x[7:0] = x0[7:0];
				y[6:0] = y0[6:0];
				color = color0;
			end else begin
				x[7:0] = x1[7:0];
				y[6:0] = y1[6:0];
				color = color1;
			end
		end else begin
			x = 0;
			y = 0;
			color = 0;
		end
	end
endmodule