module DisplayLinesR(clock, resetn, enable, ready, complete, x0, y0, z0, x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, x5, y5, z5, x6, y6, z6, x7, y7, z7, x0_out, y0_out, z0_out, x1_out, y1_out, z1_out, color, request, dontShow);//clock, resetn, enable, enableClear, doneClear, enableForeground, doneForeground);
	// Connect:
	//0 - 1, 1 - 2, 2 - 3, 3 - 4, 4 - 0;
	
	input clock;
	parameter COLOR_CHANNEL_DEPTH = 2;
	input resetn;
	input enable;
	input ready;
	input [9:0] x0, x1, x2, x3, x4, x5, x6, x7;
	input [9:0] y0, y1, y2, y3, y4, y5, y6, y7;
	input [9:0] z0, z1, z2, z3, z4, z5, z6, z7;
	output reg [3*COLOR_CHANNEL_DEPTH-1:0] color;
	
	output reg [9:0] x0_out, x1_out;
	output reg [9:0] y0_out, y1_out;
	output reg [9:0] z0_out, z1_out;
	
	output reg dontShow;
	
	//output reg writeEn;
	//output reg done;
	output reg request;
	output reg complete;
	
	reg [4:0] State;
	parameter [4:0] A=4'b0000,
					B=4'b0001,
					C=4'b0010,
					D=4'b0011,
					E=4'b0100,
					F=4'b0101,
					G=4'b0110,
					H=4'b0111,
					I=4'b1000,
					J=4'b1001,
					K=4'b1010,
					L=4'b1011;
	
	reg started;
	
	reg [9:0] furthestZ;
	
	wire [5:0] 	COLOR_1a = 6'b111111, COLOR_1b = 6'b101010, COLOR_1c = 6'b010101, COLOR_1d = 6'b000000, // white - black
				COLOR_2a = 6'b010111, COLOR_2b = 6'b000011, COLOR_2c = 6'b000010, COLOR_2d = 6'b000001, // lblue - dblue
				COLOR_3a = 6'b110101, COLOR_3b = 6'b110000, COLOR_3c = 6'b100000, COLOR_3d = 6'b010000, // lred - dred
				COLOR_4a = 6'b011101, COLOR_4b = 6'b001100, COLOR_4c = 6'b001000, COLOR_4d = 6'b000100; // lgreen - dgreen
				
	reg [4:0] Stage;
	
	initial begin	
		request = 0;
		Stage = A;
		State = A;
		dontShow = 0;
	end
	
	function [9:0] greatest;
		input [9:0] x, y;
		reg [9:0] posx, posy;
		reg [0:0] isposx, isposy;
		isposx = !x[9];
		isposy = !y[9];
		posx = abs(x);
		posy = abs(y);
		
		if (isposx && isposy) 			greatest = (posx > posy) ? x : y;	
		else if (!isposx && !isposy) 	greatest = (posx < posy) ? x : y;
		else 							greatest = (isposx) ? x : y;
	endfunction
	
	function [9:0] abs;
		input [9:0] value;
		if (value[9] == 1)
			abs = ~value + 1'd1;
		else
			abs = value;
	endfunction
	
	always @(posedge clock or negedge resetn) begin
		if (!resetn) begin
			State <= A;
			Stage <= A;
			started <= 0;
			request <= 0;
			complete <= 0;
			furthestZ <= 0;
			dontShow <= 0;
		end else begin
			case (Stage)
				A:
				begin
					if (enable) begin
						request <= 1;
						Stage <= B;
						State <= A;
						complete <= 0;
						dontShow <= 0;
						furthestZ = greatest(greatest(greatest(greatest(greatest(greatest(greatest(z0,z1),z2),z3),z4),z5),z6),z7);
					end else begin
						complete <= 0;
						request <= 0;
						dontShow <= 0;
					end
				end
				B:
				begin
					if (ready) begin
						request <= 0;
						if (State != L) begin
							State <= State + 1'b1;
							Stage <= C;
						end else begin
							Stage <= D;
							complete <= 1;
							State <= A;
						end
					end else begin
						Stage <= B;
						request <= 1;
					end
				end
				C:
				begin
					if (!ready) begin
						request <= 1;
						Stage <= B;
					end else  begin
						Stage <= C;
						request <= 0;
					end
				end
				D:
				begin
					request <= 0;
					Stage <= A;
				end
				default Stage <= A;
			endcase
			case (State)
				A: // first square
				begin
					x0_out <= x0;
					y0_out <= y0;
					x1_out <= x1;
					y1_out <= y1;
					z0_out <= z0;
					z1_out <= z1;
					//color[0] <= 1;
					//color[1] <= 1;
					//color[2] <= 1;
					if (z0 == furthestZ || z1 == furthestZ) begin // don't show
						color <= COLOR_1c;
						dontShow <= 1;
					end else begin
						color <= COLOR_1a;
						dontShow <= 0;
					end
					//color <= COLOR_1a;
					//color <= 1;
				end
				B:
				begin
					x0_out <= x1;
					y0_out <= y1;
					x1_out <= x2;
					y1_out <= y2;
					z0_out <= z1;
					z1_out <= z2;
					if (z1 == furthestZ || z2 == furthestZ) begin // don't show
						color <= COLOR_1d;
						dontShow <= 1;
					end else begin
						color <= COLOR_1b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				C:
				begin
					x0_out <= x2;
					y0_out <= y2;
					x1_out <= x3;
					y1_out <= y3;
					z0_out <= z2;
					z1_out <= z3;
					if (z2 == furthestZ || z3 == furthestZ) begin // don't show
						color <= COLOR_1c;
						dontShow <= 1;
					end else begin
						color <= COLOR_1a;
						dontShow <= 0;
					end
					//color <= 1;
				end
				D:
				begin
					x0_out <= x3;
					y0_out <= y3;
					x1_out <= x0;
					y1_out <= y0;
					z0_out <= z3;
					z1_out <= z0;
					if (z3 == furthestZ || z0 == furthestZ) begin // don't show
						color <= COLOR_1d;
						dontShow <= 1;
					end else begin
						color <= COLOR_1b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				E: // second square
				begin
					x0_out <= x4;
					y0_out <= y4;
					x1_out <= x5;
					y1_out <= y5;
					z0_out <= z4;
					z1_out <= z5;
					if (z4 == furthestZ || z5 == furthestZ) begin // don't show
						color <= COLOR_3c;
						dontShow <= 1;
					end else begin
						color <= COLOR_3a;
						dontShow <= 0;
					end
					//color <= 1;
				end
				F:
				begin
					x0_out <= x5;
					y0_out <= y5;
					x1_out <= x6;
					y1_out <= y6;
					z0_out <= z5;
					z1_out <= z6;
					if (z5 == furthestZ || z6 == furthestZ) begin // don't show
						color <= COLOR_3d;
						dontShow <= 1;
					end else begin
						color <= COLOR_3b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				G:
				begin
					x0_out <= x6;
					y0_out <= y6;
					x1_out <= x7;
					y1_out <= y7;
					z0_out <= z6;
					z1_out <= z7;
					if (z6 == furthestZ || z7 == furthestZ) begin // don't show
						color <= COLOR_3c;
						dontShow <= 1;
					end else begin
						color <= COLOR_3a;
						dontShow <= 0;
					end
					//color <= 1;
				end
				H:
				begin
					x0_out <= x7;
					y0_out <= y7;
					x1_out <= x4;
					y1_out <= y4;
					z0_out <= z7;
					z1_out <= z4;
					if (z7 == furthestZ || z4 == furthestZ) begin // don't show
						color <= COLOR_3d;
						dontShow <= 1;
					end else begin
						color <= COLOR_3b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				I:// rest (between)
				begin
					x0_out <= x0;
					y0_out <= y0;
					x1_out <= x4;
					y1_out <= y4;
					z0_out <= z0;
					z1_out <= z4;
					if (z0 == furthestZ || z4 == furthestZ) begin // don't show
						color <= COLOR_4c;
						dontShow <= 1;
					end else begin
						color <= COLOR_4a;
						dontShow <= 0;
					end
					//color <= 1;
				end
				J:
				begin
					x0_out <= x1;
					y0_out <= y1;
					x1_out <= x5;
					y1_out <= y5;
					z0_out <= z1;
					z1_out <= z5;
					if (z1 == furthestZ || z5 == furthestZ) begin // don't show
						color <= COLOR_4c;
						dontShow <= 1;
					end else begin
						color <= COLOR_4a;
						dontShow <= 0;
					end
					//color <= 1;
				end
				K:
				begin
					x0_out <= x2;
					y0_out <= y2;
					x1_out <= x6;
					y1_out <= y6;
					z0_out <= z2;
					z1_out <= z6;
					if (z2 == furthestZ || z6 == furthestZ) begin // don't show
						color <= COLOR_4d;
						dontShow <= 1;
					end else begin
						color <= COLOR_4b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				L:
				begin
					x0_out <= x3;
					y0_out <= y3;
					x1_out <= x7;
					y1_out <= y7;
					z0_out <= z3;
					z1_out <= z7;
					if (z3 == furthestZ || z7 == furthestZ) begin // don't show
						color <= COLOR_4d;
						dontShow <= 1;
					end else begin
						color <= COLOR_4b;
						dontShow <= 0;
					end
					//color <= 1;
				end
				default State <= A;
			endcase
			//////////
		end
	end
endmodule