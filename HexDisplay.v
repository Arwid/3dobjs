module HexDisplay(x3, x2, x1, x0, f0, f1, f2, f3, f4, f5, f6);

	input x3, x2, x1, x0;
	output f0, f1, f2, f3, f4, f5, f6;
	
	
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
	// X
	// (x3&!x2&x1&!x0)|
	// Y
	// (x3&!x2&x1&x0)|
	// Z
	// (x3&x2&!x1&!x0)|
	// R
	// (x3&x2&!x1&x0)|
	// S
	// (x3&x2&x1&!x0)|
	// T
	// (x3&x2&x1&x0)|
	
	// 0: 1, 4, X, Y, R
	// 1: 5, 6, S, R, T 
	// 2: 2, Z, R, T
	// 3: 1, 4, 7, 9, X, R, T
	// 4: 1, 3, 4, 5, 7, 9, Y, S
	// 5: 1, 2, 3, 7, Z, R,
	// 6: 0, 1, 7, T
	
	assign f0 = (!x3&!x2&!x1&x0)|(!x3&x2&!x1&!x0)|(x3&!x2&x1&!x0)|(x3&!x2&x1&x0)|(x3&x2&!x1&x0);
	assign f1 = (!x3&x2&!x1&x0)|(!x3&x2&x1&!x0)|(x3&x2&x1&!x0)|(x3&x2&!x1&x0)|(x3&x2&x1&x0);
	assign f2 = (!x3&!x2&x1&!x0)|(x3&x2&!x1&!x0)|(x3&x2&!x1&x0)|(x3&x2&x1&x0);
	assign f3 = (!x3&!x2&!x1&x0)|(!x3&x2&!x1&!x0)|(!x3&x2&x1&x0)|(x3&!x2&!x1&x0)|(x3&!x2&x1&!x0)|(x3&x2&!x1&x0)|(x3&x2&x1&x0);
	assign f4 = (!x3&!x2&!x1&x0)|(!x3&!x2&x1&x0)|(!x3&x2&!x1&!x0)|(!x3&x2&!x1&x0)|(!x3&x2&x1&x0)|(x3&!x2&!x1&x0)|(x3&!x2&x1&x0)|(x3&x2&x1&!x0);
	assign f5 = (!x3&!x2&!x1&x0)|(!x3&!x2&x1&!x0)|(!x3&!x2&x1&x0)|(!x3&x2&x1&x0)|(x3&x2&!x1&!x0)|(x3&x2&!x1&x0);
	assign f6 = (!x3&!x2&!x1&!x0)|(!x3&!x2&!x1&x0)|(!x3&x2&x1&x0)|(x3&x2&x1&x0);

endmodule

