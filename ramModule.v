module ramModule (
			resetn,
			CLOCK_50,
			x, //0-159
			y, //0-119
			writeEn);
	parameter COLOR_CHANNEL_DEPTH = 1;
	
	input resetn;
	input CLOCK_50;
	wire [(COLOR_CHANNEL_DEPTH*3-1):0] color;
	
	parameter VERT_NUM  = 8'd160;
	parameter HORZ_NUM  = 8'd120;

	input [7:0] x; //0-159
	input [6:0] y; //0-119
	input writeEn;
	
	/*
	reg [9:0] xCounter, yCounter;
	
	//- Horizontal Counter
	wire xCounter_clear;
	assign xCounter_clear = (xCounter == (HORZ_NUM-1));

	always @(posedge CLOCK_50 or negedge resetn)
	begin
		if (!resetn)
			xCounter <= 10'd0;
		else if (xCounter_clear)
			xCounter <= 10'd0;
		else
		begin
			xCounter <= xCounter + 1'b1;
		end
	end
	
	//- Vertical Counter
	wire yCounter_clear;
	assign yCounter_clear = (yCounter == (VERT_NUM-1)); 

	always @(posedge CLOCK_50 or negedge resetn)
	begin
		if (!resetn)
			yCounter <= 10'd0;
		else if (xCounter_clear && yCounter_clear)
			yCounter <= 10'd0;
		else if (xCounter_clear)		//Increment when x counter resets
			yCounter <= yCounter + 1'b1;
	end
	
	wire [(COLOR_CHANNEL_DEPTH*3)-1:0] readData;
	
		
	//--- Frame buffer
	//Dual port RAM read at 25 MHz, written at 50 MHZ (synchronous with rest of circuit)
	wire [14:0] writeAddr;
	wire [14:0] readAddr;
	
	assign writeAddr = {y[6:0], x[7:0]};
	assign readAddr = {yCounter[8:2], xCounter[9:2]};
	
	
	altsyncram	frameBufferRam (
				.wren_a (writeEn),
				.clock0 (CLOCK_50), // write clock
				.clock1 (CLOCK_50), // read clock
				.address_a (writeAddr),
				.address_b (readAddr),
				.data_a (color), // data in
				.q_b (readData)	// data out
				);
	defparam		
	frameBufferRam.width_a = COLOR_CHANNEL_DEPTH*3,
	frameBufferRam.width_b = COLOR_CHANNEL_DEPTH*3,
	frameBufferRam.intended_device_family = "Cyclone II",
	frameBufferRam.operation_mode = "DUAL_PORT",
	frameBufferRam.widthad_a = 15,
	frameBufferRam.widthad_b = 15,
	frameBufferRam.outdata_reg_b = "CLOCK1",
	frameBufferRam.address_reg_b = "CLOCK1",
	frameBufferRam.clock_enable_input_a = "BYPASS",
	frameBufferRam.clock_enable_input_b = "BYPASS",
	frameBufferRam.clock_enable_output_b = "BYPASS";
	//frameBufferRam.power_up_uninitialized = "FALSE"
	//frameBufferRam.init_file = BACKGROUND_IMAGE;
	
	function clearDisplay;
		input [(COLOR_CHANNEL_DEPTH*3-1):0] colr;
		
	endfunction*/
endmodule