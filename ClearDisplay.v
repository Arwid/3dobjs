module ClearDisplay(
	clk, 
	resetn,
	color,
	x,
	y,
	writeEn,
	enable,
	done
	);
	
	input clk;
	input resetn;
	parameter COLOR_CHANNEL_DEPTH = 2;
	output reg [3*COLOR_CHANNEL_DEPTH-1:0] color;
	output reg [7:0] x;
	output reg [6:0] y;
	output writeEn;
	input enable;
	output reg done = 1'd0;
	reg [3*COLOR_CHANNEL_DEPTH-1:0]index;
	
	//--- pixel counters
	wire xCount;
	wire yCount;
	reg [17:0] slowCount;
	assign xCount = 1'b1;
	
	wire xClear;
	assign xClear = (x == 8'd159); 
	
	always @(posedge clk or negedge enable or negedge resetn)
	begin
		if (!resetn) 
			x <= 8'd0;
		else begin
			if (!enable)
				x <= 8'd0;
			else if (xCount && !done)
			begin
				if (xClear)	x <= 8'd0;
				else		x <= x + 1'b1;
			end
		end
	end
	
	
	wire yClear;
	assign yClear = (y == 7'd119);

	always @(posedge clk or negedge enable or negedge resetn)
	begin
		if (!resetn) 
			y <= 7'd0;
		else begin
			if (!enable)
				y <= 7'd0;
			else if (xCount && !done)
			begin
				if (xClear && yClear)	y <= 7'd0; //New frame
				else if (xClear)		y <= y + 1'b1;
			end
		end
	end


	always @(posedge clk or negedge enable or negedge resetn)
	begin
		if (!resetn) begin
			slowCount <= 18'd0;
			done <= 1'b0;
		end else begin
			if (!enable) begin
				done <= 1'b0;
			end
			else if (xCount && !done)
			begin
				if (xClear && yClear) begin
					slowCount <= slowCount + 1'b1; //New frame
					done = 1'd1;
				end
			end
		end
	end


	//--- Color generator
/*
	assign color[2:0] = (x[2:0] ^ y[2:0]) ^ (slowCount[13:11]);
	assign color[5:3] = (x[3:1] ^ y[3:1]) ^ (slowCount[13:11]);
	assign color[8:6] = (x[4:2] ^ y[4:2]) ^ (slowCount[13:11]);
*/	
	
	//assign color[2:0] = x[2:0] ^ y[2:0];
	//assign color[5:3] = x[3:1] ^ y[3:1];
	//assign color[8:6] = x[4:2] ^ y[4:2];
	/*
	assign color[0] = 0;
	assign color[1] = 0;
	assign color[2] = 0;
	*/
	//assign color[3*COLOR_CHANNEL_DEPTH-1:0] = 0;
	always @(*) begin
		//color[3*COLOR_CHANNEL_DEPTH-1:0] = 0;
		//color[0] = 1; // blue
		color = 6'b010111;
		/*
		for (index = 1'd0; index < (3*COLOR_CHANNEL_DEPTH-1); index = index + 1'd1) begin
			if (index == slowCount)
				color[index] = 1;
			else
				color[index] = 0;
		end
		*/
	end
	assign writeEn = enable && !done;
endmodule