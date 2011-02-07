module TrigFactorial(input [10:0] data, output [31:0] result, output [31:0] result2);
	parameter precision = 6;
	
	assign result = sin(data);
	assign result2 = sin(data)/power(10,precision);
	
	function [31:0] multiply;
		input [31:0] x;
		input [31:0] y;
		multiply = x * y;
	endfunction
	
	//assign result = data*power(10,6) - (power(10,6)*power(data,3))/factorial(3);
	//assign result2 = result + (power(10,6)*power(data,5))/factorial(5);
	function [31:0] sin;
		parameter precision = 6;
		parameter pi = (power(10,precision)*3.141592654)+0.5;
	
		input [10:0] x;
		reg [4:0] n;
		reg [0:0] sign;
		reg [31:0] rad;
		rad = multiply(x,pi)/180; // radian angle
		
		sin = rad;
		sign = 1;
		/*
		for (n = 1; n <= 2; n = n + 1)
			//if (n <= precision) 
			begin
				sign = -1*sign;
				if (sign == 1'b1)
					sin = sin + ((power(rad,2*n+1)/factorial(2*n+1))/power(power(10,precision),2*n));
				else
					sin = sin - ((power(rad,2*n+1)/factorial(2*n+1))/power(power(10,precision),2*n));
			end
		*/
		//sin = sine / power(10,6);
	endfunction
		
	
	function [31:0] power;
		input [10:0] x;
		input [10:0] p;
		reg [3:0] index;
		
		power = 1;
		for (index = 1; index <= 8; index = index + 1)
			if (index <= p)
				power = power * x;
	endfunction
	
	function [31:0] factorial;
	// compute factorials 2! to 8!
		input [10:0] x;
		reg [4:0] index;
		
		factorial = x ? 1 : 0;
		for (index = 2; index <= 8; index = index + 1) 
			if (index <= x)
				factorial = index*factorial;
	endfunction
	

endmodule