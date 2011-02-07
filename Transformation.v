module Transformation(Tx, Ty, Tz, Sx, Sy, Sz, sinRx, cosRx, sinRy, cosRy, sinRz, cosRz, Xf, Yf, Zf);
	parameter size = 9;
	parameter output_size = 9;
	input [size:0] Tx, Ty, Tz, Sx, Sy, Sz;
	reg [20:0] Xf0, Yf0, Zf0;
	parameter X0 = 0, Y0 = 0, Z0 = 1;
	
	reg [20:0] X, Y, Z;
	input[20:0] sinRx, cosRx, sinRy, cosRy, sinRz, cosRz;
	parameter p = 3;
	output reg [output_size:0] Xf, Yf, Zf;
	
	always @(*) begin
		
		/// scaling
		
		Xf0 = Sx*X0;
		Yf0 = Sy*Y0;
		Zf0 = Sz*Z0;
		
		/*
		Xf0 = X0;
		Xf1 = X1;
		Xf2 = X2;
		
		Yf0 = Y0;
		Yf1 = Y1;
		Yf2 = Y2;
		
		Zf0 = Z0;
		Zf1 = Z1;
		Zf2 = Z2;
		*/
		
		/// rotations
		// about z
		X = Xf0;
		Y = Yf0;
		Z = Zf0;
		
		Xf0 = devide(((X*cosRz)-(Y*sinRz)),power(10,p));
		Yf0 = devide(((X*sinRz)+(Y*cosRz)),power(10,p));
		Zf0 = Z;
		
		// about x
		X = Xf0;
		Y = Yf0;
		Z = Zf0;
		
		Xf0 = X;
		Yf0 = devide((Y*cosRx-Z*sinRx),power(10,p));
		Zf0 = devide((Y*sinRx+Z*cosRx),power(10,p));
		
		// about y
		X = Xf0;
		Y = Yf0;
		Z = Zf0;
		
		Xf0 = devide((X*cosRy+Z*sinRy),power(10,p));
		Yf0 = Y;
		Zf0 = devide((-X*sinRy+Z*cosRy),power(10,p));
		
		/// translations
		
		Xf0 = Xf0 + resize(Tx);
		Yf0 = Yf0 + resize(Ty);
		Zf0 = Zf0 + resize(Tz);
		
		Xf = resize2(Xf0);
		Yf = resize2(Yf0);
		Zf = resize2(Zf0);
	end
	
	function [20:0] resize;
		input [size:0] x;
		reg [size:0] xo;
		reg [20:0] ro;
		if (x[size]==1) begin
			xo = (~x + 1'd1);
			ro = xo;
			resize = (~ro + 1'd1);
		end else
			resize = x;
	endfunction
	
	function [output_size:0] resize2;
		input [20:0] x;
		reg [20:0] xo;
		reg [output_size:0] ro;
		if (x[20]==1) begin
			xo = (~x + 1'd1);
			ro = xo;
			resize2 = (~ro + 1'd1);
			resize[output_size] = 1;
		end else
			resize2 = x;
	endfunction
	
	function [20:0] devide;
		input [20:0] x;
		input [20:0] d;
		reg [20:0] pos;
		if (x[20] == 1) pos = ~x + 1'd1;
		else			pos = x;
		pos = pos / d;
		
		devide = pos;
		if (x[20] == 1)	devide = ~devide + 1'd1;
	endfunction
	
	function [20:0] power;
		input [10:0] x;
		input [10:0] p;
		reg [5:0] index;
		
		power = 1;
		for (index = 1; index <= 10; index = index + 1)
			if (index <= p)
				power = power * x;
	endfunction
endmodule