module Hex(clock, resetn, X,Y,Z,R1,R2,R3,f0,f1,f2,f3,f4,f5,f6,change);
	input [39:0] X, Y, Z;
	input [9:0] R1, R2, R3;
	input clock, resetn, change; //change setting
	output f0, f1, f2, f3, f4, f5, f6;
	
	reg [3:0] value = 3b'00;//-(R1/10)*10;
	//HexDisplay(value[3],value[2],value[1],value[0],f0,f1,f2,f3,f4,f5,f6);
	
endmodule


module HexDisplay(x3, x2, x1, x0, f0, f1, f2, f3, f4, f5, f6);

	input x3, x2, x1, x0;
	output f0, f1, f2, f3, f4, f5, f6;
	
	// 0
	// (!x3&!x2&!x1&!x0)|
	// 1
	// (!x3&!x2&!x1&x0)|
	// 2
	// (!x3&!x2&x1&!x0)|
	// 3
	// (!x3&!x2&x1&x0)|
	// 4
	// (!x3&x2&!x1&!x0)|
	// 5
	// (!x3&x2&!x1&x0)|
	// 6
	// (!x3&x2&x1&!x0)|
	// 7
	// (!x3&x2&x1&x0)|
	// 8
	// (x3&!x2&!x1&!x0)|
	// 9
	// (x3&!x2&!x1&x0)|
	// A
	// (x3&!x2&x1&!x0)|
	// b
	// (x3&!x2&x1&x0)|
	// C
	// (x3&x2&!x1&!x0)|
	// d
	// (x3&x2&!x1&x0)|
	// E
	// (x3&x2&x1&!x0)|
	// F
	// (x3&x2&x1&x0)|
	
	// 0: 1, 4, b, d, 
	// 1: 5, 6, b, C, E, F
	// 2: 2, C, E, F
	// 3: 1, 4, 7, 9, A, F
	// 4: 1, 3, 4, 5, 7, 9, 
	// 5: 1, 2, 3, 7, d, 
	// 6: 0, 1, 7, C, 
	
	assign f0 = (!x3&!x2&!x1&x0)|(!x3&x2&!x1&!x0)|(x3&!x2&x1&x0)|(x3&x2&!x1&x0);
	assign f1 = (!x3&x2&!x1&x0)|(!x3&x2&x1&!x0)|(x3&!x2&x1&x0)|(x3&x2&!x1&!x0)|(x3&x2&x1&!x0)|(x3&x2&x1&x0);
	assign f2 = (!x3&!x2&x1&!x0)|(x3&x2&!x1&!x0)|(x3&x2&x1&!x0)|(x3&x2&x1&x0);
	assign f3 = (!x3&!x2&!x1&x0)|(!x3&x2&!x1&!x0)|(!x3&x2&x1&x0)|(x3&!x2&!x1&x0)|(x3&!x2&x1&!x0)|(x3&x2&x1&x0);
	assign f4 = (!x3&!x2&!x1&x0)|(!x3&!x2&x1&x0)|(!x3&x2&!x1&!x0)|(!x3&x2&!x1&x0)|(!x3&x2&x1&x0)|(x3&!x2&!x1&x0);
	assign f5 = (!x3&!x2&!x1&x0)|(!x3&!x2&x1&!x0)|(!x3&!x2&x1&x0)|(!x3&x2&x1&x0)|(x3&x2&!x1&x0);
	assign f6 = (!x3&!x2&!x1&!x0)|(!x3&!x2&!x1&x0)|(!x3&x2&x1&x0)|(x3&x2&!x1&!x0);

endmodule

