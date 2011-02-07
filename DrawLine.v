module DrawLine(Clock, resetn, enable, writeEn, done, x0_in, x1_in, y0_in, y1_in, xf, yf, ystep);
	input Clock, resetn, enable;
	output writeEn;
	output done;
	parameter INPUT_SIZE = 9;
	input [INPUT_SIZE:0] x0_in, x1_in, y0_in, y1_in;
	reg [INPUT_SIZE:0] x0, x1, y0, y1;
	reg [INPUT_SIZE:0] x, y;
	output reg [INPUT_SIZE:0] xf, yf;
	reg [1:0] steep;
	reg [INPUT_SIZE:0] temp;
	parameter horizontal = 8;
	parameter vertical = 7;
	reg [horizontal:0] xCount;
	
	reg starting, done;
	reg [INPUT_SIZE:0] deltax, deltay;
	reg [INPUT_SIZE:0] error;
	output reg [INPUT_SIZE:0] ystep;
	
	always @(negedge Clock or negedge resetn) begin
		if (!resetn) begin
			starting <= 1;
			done <= 0;
		end else if (enable) begin
			if (starting && !done) begin
				xCount <= x0_in;
				starting <= 0;
				done <= 0;
				
				x0 = x0_in;
				x1 = x1_in;
				y0 = y0_in;
				y1 = y1_in;
				
				steep = abs(y1-y0) > abs(x1-x0);
				
				if (steep) begin
					// swap x0, y0
					temp = x0;
					x0 = y0;
					y0 = temp;
					// swap x1, y1
					temp = x1;
					x1 = y1;
					y1 = temp;
				end
				
				if (greaterThan(x0,x1)) begin
					// swap x0, x1
					temp = x0;
					x0 = x1;
					x1 = temp;
					// swap y0, y1
					temp = y0;
					y0 = y1;
					y1 = temp;
				end
				
				deltax = x1 - x0;
				deltay = abs(y1-y0);
				error = 0;
				
				x = x0;
				y = y0;
				//ystep = (y0 < y1) ? 1 : -1;
				ystep = !greaterThan(y0,y1)&&!(y0==y1) ? 1 : -1;
				
				if (steep) begin
					// plot(y,x);
					xf = y;
					yf = x;
				end else begin
					// plot(x,y);
					xf = x;
					yf = y;
				end
			end else if (!done) begin
				if (!greaterThan(x+1,x1)) begin//x + 1 <= x1_in) begin
					x = x + 1;
					if (steep) begin
						// plot(y,x);
						xf = y;
						yf = x;
					end else begin
						// plot(x,y);
						xf = x;
						yf = y;
					end
					error = error + deltay;
					if (!greaterThan(deltax,2*(error))) begin //2*(error) >= deltax) begin
						y = y + ystep;
						error = error - deltax;
					end
				
					//x <= x + 1;
				end else begin
					x = x1;
					y = y1;
					done <= 1;
				end
			end else if (done) begin
				//starting <= 1;
			end
		end else begin
			starting <= 1;
			done <= 0; 
		end
	end
	
	assign writeEn = enable && resetn && !starting && !done;
	
	function [INPUT_SIZE:0] abs;
		input [INPUT_SIZE:0] value;
		if (value[INPUT_SIZE] == 1)
			abs = ~value + 1'd1;
		else
			abs = value;
	endfunction
	
	function [0:0] greaterThan;
		input [INPUT_SIZE:0] x, y;
		reg [INPUT_SIZE:0] posx, posy;
		reg [0:0] isposx, isposy;
		isposx = !x[INPUT_SIZE];
		isposy = !y[INPUT_SIZE];
		posx = abs(x);
		posy = abs(y);
		
		if (isposx && isposy) 			greaterThan = (posx > posy);	
		else if (!isposx && !isposy) 	greaterThan = (posx < posy);
		else 							greaterThan = (isposx);
	endfunction
	
endmodule