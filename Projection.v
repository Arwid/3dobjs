module Projection (X, Y, Z, X2, Y2);
	input X, Y, Z;
	output X2, Y2;
	
	parameter vanishingPnt = -10;
	
	function [32:0] projectedX;
		input [32:0] x1, y1, z1;
		input [32:0] x2, y2, z2; // vanishing point
		input [32:0] zDistance;
		input [10:0] precision;
		
		projectedX = (power(10,precision)*x1*z2)/(z1+zDistance+z2);
	endfunction
	
	function [32:0] projectedY;
		input [32:0] x1, y1, z1;
		input [32:0] x2, y2, z2; // vanishing point
		input [32:0] zDistance;
		input [10:0] precision;
		
		projectedY = (power(10,precision)*y1*z2)/(z1+zDistance+z2);
	endfunction
	
	function [31:0] power;
		input [10:0] x;
		input [10:0] p;
		reg [5:0] index;
		
		power = 1;
		for (index = 1; index <= 30; index = index + 1)
			if (index <= p)
				power = power * x;
	endfunction
endmodule