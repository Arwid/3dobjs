module displayPoints(clock, resetn, enable, writeEn0, writeEn1, writeEn2, writeEn3, writeEn4, writeEn5, writeEn6, writeEn7, x0, y0, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x, y, color, writeEn, done);//clock, resetn, enable, enableClear, doneClear, enableForeground, doneForeground);
	parameter COLOR_CHANNEL_DEPTH = 1;
	input clock;
	input resetn;
	input enable;
	input writeEn0, writeEn1, writeEn2, writeEn3, writeEn4, writeEn5, writeEn6, writeEn7;
	input [7:0] x0, x1, x2, x3, x4, x5, x6, x7;
	input [6:0] y0, y1, y2, y3, y4, y5, y6, y7;
	output reg [3*COLOR_CHANNEL_DEPTH-1:0] color;
	
	output reg [7:0] x;
	output reg [6:0] y;
	output reg writeEn;
	output reg done;
	
	reg [4:0] State;
	parameter [4:0] A=4'b0000, // clear screen
					B=4'b0001, // wait
					C=4'b0010, // draw foreground
					D=4'b0011, // wait
					E=4'b0100, // back to A
					F=4'b0101,
					G=4'b0110,
					H=4'b0111,
					I=4'b1000,
					J=4'b1001,
					K=4'b1010;
	
	always @(posedge clock) begin
		if (!resetn) begin
			done <= 0;
			writeEn <= 0;
			x <= 0;
			y <= 0;
		end else begin
			case (State)
				A:
				begin
					color <= 1;
					done <= 0;
					if (enable == 1)
						State <= B;
					else
						State <= A;
				end
				B:
				begin
					// display point 1
					if (writeEn0) begin
						writeEn <= 1;
						x <= x0;
						y <= y0;
						color[0] <= 1;
						color[1] <= 1;
						color[2] <= 1;
						//color <= 1;//3'b001;
					end else writeEn <= 0;
					done <= 0;
					State <= C;
				end
				C:
				begin
					// display point 2
					if (writeEn1) begin
						writeEn <= 1;
						x <= x1;
						y <= y1;
						//color <= 3'b010;
					end else writeEn <= 0;
					State <= D;
				end
				D:
				begin
					// display point 3
					if (writeEn2) begin
						writeEn <= 1;
						x <= x2;
						y <= y2;
						//color <= 3'b011;
					end else writeEn <= 0;
					State <= E;
				end
				E:
				begin
					// display point 4
					if (writeEn3) begin
						writeEn <= 1;
						x <= x3;
						y <= y3;
						//color <= 3'b100;
					end else writeEn <= 0;
					State <= F;
				end
				F:
				begin
					// display point 5
					if (writeEn4) begin
						writeEn <= 1;
						x <= x4;
						y <= y4;
						//color <= 3'b01;//3'b101;
					end else writeEn <= 0;
					State <= G;
				end
				G:
				begin
					// display point 6
					if (writeEn5) begin
						writeEn <= 1;
						x <= x5;
						y <= y5;
						//color <= 3'b110;
					end else writeEn <= 0;
					State <= H;
				end
				H:
				begin
					// display point 7
					if (writeEn6) begin
						writeEn <= 1;
						x <= x6;
						y <= y6;
						//color <= 3'b111;
					end else writeEn <= 0;
					State <= I;
				end
				I:
				begin
					// display point 8
					if (writeEn7) begin
						writeEn <= 1;
						x <= x7;
						y <= y7;
						//color <= 3'b100;//3'b001;
					end else writeEn <= 0;
					State <= J;
				end
				J:
				begin
					State <= K;
					done <= 1;
					writeEn <= 0;
				end
				K:
				begin
					State <= A;
					done <= 0;
				end
				default State <= A;
			endcase
		end
	end
	
	/*
	//output reg [7:0] x;
	//output reg [6:0] y;
	//output writeEn;
	
	output reg enableClear, enableForeground;
	
	input enable;
	input doneClear, doneForeground;
	
	reg done = 1'd0;
	reg [3*COLOR_CHANNEL_DEPTH-1:0]index;
	reg [2:0] State;
	parameter [2:0] A=3'b000, // clear screen
					B=3'b001, // wait
					C=3'b010, // draw foreground
					D=3'b011, // wait
					E=3'b100, // back to A
					F=3'b101;
	
	always @(posedge clock or negedge resetn) begin
		if (!resetn) begin// Reset All
			enableClear <= 0;
			enableForeground <= 0;
		end else begin
			
			case (State)
				A: 
				begin
					if (enable)
						State <= B;
					else begin
						enableClear <= 0;
						enableForeground <= 0;
					end
				end
				B:  // start clear
				begin 
					enableClear <= 1;
					State <= B;
				end
				C:  // wait for clear
				begin
					if (doneClear) begin
						enableClear <= 0;
						State <= D;
					end else begin
						enableClear <= 1;
						State <= C;
					end
				end
				D:  // start foreground
				begin
					enableForeground <= 1;
					State <= E;
				end
				E:  // wait for foreground
				begin
					if (doneForeground) begin
						enableForeground <= 0;
						State <= F;
					end else begin
						enableForeground <= 1;
						State <= E;
					end
				end
				F:
				begin
					State <= A;
				end
				default State <= A;
			endcase
			
		end
	end
	*/
endmodule