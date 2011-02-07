module Trig(angle, sine, cosine);
	
	parameter precise = 3;
	input[9:0] angle;
	output[20:0] sine;
	output[20:0] cosine;
	
	assign sine = sin(angle,precise);
	assign cosine = cos(angle,precise);
	
	function [20:0] cos;
		input[9:0] value;
		input[9:0] precision;
		cos = sin(90-value,precision);
	endfunction
	
	function [20:0] sin;
		input[9:0] value;
		input[9:0] precision;
		reg [9:0] temp;
		reg [4:0] index, index2;
		reg [1:0] sign, POS, NEG;
		POS = 1; NEG = 0; sign = POS;
		
		for (index = 1; index <= 2; index = index + 1) begin
			
			if (value[9] == 1'b0 && value > 9'd90)
				value = 9'd180-value;
			
			if (value[9] == 1'b1) begin // make it positive
				value = ~value + 1'b1;
				sign = (sign == POS) ? NEG : POS;
			end
		end
		
		case (value)
			0: sin = 0;
			1: sin = 0.017452406*power(10,precision);
			2: sin = 0.034899497*power(10,precision);
			3: sin = 0.052335956*power(10,precision);
			4: sin = 0.069756474*power(10,precision);
			5: sin = 0.087155743*power(10,precision);
			6: sin = 0.104528463*power(10,precision);
			7: sin = 0.121869343*power(10,precision);
			8: sin = 0.139173101*power(10,precision);
			9: sin = 0.156434465*power(10,precision);
			10: sin = 0.173648178*power(10,precision);
			11: sin = 0.190808995*power(10,precision);
			12: sin = 0.207911691*power(10,precision);
			13: sin = 0.224951054*power(10,precision);
			14: sin = 0.241921896*power(10,precision);
			15: sin = 0.258819045*power(10,precision);
			16: sin = 0.275637356*power(10,precision);
			17: sin = 0.292371705*power(10,precision);
			18: sin = 0.309016994*power(10,precision);
			19: sin = 0.325568154*power(10,precision);
			20: sin = 0.342020143*power(10,precision);
			21: sin = 0.35836795*power(10,precision);
			22: sin = 0.374606593*power(10,precision);
			23: sin = 0.390731128*power(10,precision);
			24: sin = 0.406736643*power(10,precision);
			25: sin = 0.422618262*power(10,precision);
			26: sin = 0.438371147*power(10,precision);
			27: sin = 0.4539905*power(10,precision);
			28: sin = 0.469471563*power(10,precision);
			29: sin = 0.48480962*power(10,precision);
			30: sin = 0.5*power(10,precision);
			31: sin = 0.515038075*power(10,precision);
			32: sin = 0.529919264*power(10,precision);
			33: sin = 0.544639035*power(10,precision);
			34: sin = 0.559192903*power(10,precision);
			35: sin = 0.573576436*power(10,precision);
			36: sin = 0.587785252*power(10,precision);
			37: sin = 0.601815023*power(10,precision);
			38: sin = 0.615661475*power(10,precision);
			39: sin = 0.629320391*power(10,precision);
			40: sin = 0.64278761*power(10,precision);
			41: sin = 0.656059029*power(10,precision);
			42: sin = 0.669130606*power(10,precision);
			43: sin = 0.68199836*power(10,precision);
			44: sin = 0.69465837*power(10,precision);
			45: sin = 0.707106781*power(10,precision);
			
			46: sin = 0.7193398*power(10,precision);
			47: sin = 0.731353702*power(10,precision);
			48: sin = 0.743144825*power(10,precision);
			49: sin = 0.75470958*power(10,precision);
			50: sin = 0.766044443*power(10,precision);
			51: sin = 0.777145961*power(10,precision);
			52: sin = 0.788010754*power(10,precision);
			53: sin = 0.79863551*power(10,precision);
			54: sin = 0.809016994*power(10,precision);
			55: sin = 0.819152044*power(10,precision);
			56: sin = 0.829037573*power(10,precision);
			57: sin = 0.838670568*power(10,precision);
			58: sin = 0.848048096*power(10,precision);
			59: sin = 0.857167301*power(10,precision);
			60: sin = 0.866025404*power(10,precision);
			61: sin = 0.874619707*power(10,precision);
			62: sin = 0.882947593*power(10,precision);
			63: sin = 0.891006524*power(10,precision);
			64: sin = 0.898794046*power(10,precision);
			65: sin = 0.906307787*power(10,precision);
			66: sin = 0.913545458*power(10,precision);
			67: sin = 0.920504853*power(10,precision);
			68: sin = 0.927183855*power(10,precision);
			69: sin = 0.933580426*power(10,precision);
			70: sin = 0.939692621*power(10,precision);
			71: sin = 0.945518576*power(10,precision);
			72: sin = 0.951056516*power(10,precision);
			73: sin = 0.956304756*power(10,precision);
			74: sin = 0.961261696*power(10,precision);
			75: sin = 0.965925826*power(10,precision);
			76: sin = 0.970295726*power(10,precision);
			77: sin = 0.974370065*power(10,precision);
			78: sin = 0.978147601*power(10,precision);
			79: sin = 0.981627183*power(10,precision);
			80: sin = 0.984807753*power(10,precision);
			81: sin = 0.987688341*power(10,precision);
			82: sin = 0.990268069*power(10,precision);
			83: sin = 0.992546152*power(10,precision);
			84: sin = 0.994521895*power(10,precision);
			85: sin = 0.996194698*power(10,precision);
			86: sin = 0.99756405*power(10,precision);
			87: sin = 0.998629535*power(10,precision);
			88: sin = 0.999390827*power(10,precision);
			89: sin = 0.999847695*power(10,precision);
			90: sin = 1*power(10,precision);
			default sin = 0;
		endcase
		
		if (sign == NEG)
			sin = ~sin + 1'b1;
			
	endfunction
	
	function [20:0] power;
		input [10:0] x;
		input [10:0] p;
		integer index;
		
		power = 1;
		for (index = 1; index <= 10; index = index + 1)
			if (index <= p)
				power = power * x;
	endfunction
endmodule