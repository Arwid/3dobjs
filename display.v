module display(clock, resetn, enable, enableClear, doneClear, enableForeground, doneForeground, enableWait, doneWait);
	input clock;
	input resetn;
	parameter COLOR_CHANNEL_DEPTH = 2;
	reg [3*COLOR_CHANNEL_DEPTH-1:0] color;
	//output reg [7:0] x;
	//output reg [6:0] y;
	//output writeEn;
	
	output reg enableClear, enableForeground, enableWait;
	
	input enable;
	input doneClear, doneForeground, doneWait;
	
	reg done = 1'd0;
	reg [3*COLOR_CHANNEL_DEPTH-1:0]index;
	reg [8:1] State;
	parameter [8:1] A=8'b00000001, // clear screen
					B=8'b00000010, // wait
					C=8'b00000100, // draw foreground
					D=8'b00001000, // wait
					E=8'b00010000, // back to A
					F=8'b00100000,
					G=8'b01000000,
					H=8'b10000000;
	
	always @(posedge clock or negedge resetn) begin
		if (!resetn) begin// Reset All
			enableClear <= 0;
			enableForeground <= 0;
			enableWait <= 0;
		end else begin
			
			case (State)
				A: 
				begin
					if (enable == 1)
						State <= B;
					else begin
						enableClear <= 0;
						enableForeground <= 0;
						enableWait <= 0;
					end
				end
				B:  // start clear
				begin 
					enableClear <= 1;
					State <= C;
				end
				C:  // wait for clear
				begin
					if (doneClear == 1) begin
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
					if (doneForeground == 1) begin
						enableForeground <= 0;
						State <= F;
					end else begin
						//enableForeground <= 1;
						State <= E;
					end
				end
				F: // start Wait
				begin
					enableWait <= 1;
					State <= G;
				end
				G: // wait for Wait
				begin
					if (doneWait == 1) begin
						enableWait <= 0;
						State <= H;
					end else begin
						State <= G;
					end
				end
				H:
				begin
					State <= A;
				end
				default State <= A;
			endcase
			
		end
	end
	
endmodule