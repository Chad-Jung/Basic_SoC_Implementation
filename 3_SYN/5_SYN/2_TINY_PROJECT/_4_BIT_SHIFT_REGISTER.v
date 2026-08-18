`timescale 1ns / 1ps

module _4_BIT_SHIFT_REGISTER (
	// port list
	clr_n		, // active low(negative) reset
	clk		, // clock signal
	i_s		, // 2-bit mode select input (S1, S0)
	i_d		, // 4-bit parallel data input
	i_sr		, // 1-bit shift right serial input
	i_sl		, // 1-bit shift left serial input
	o_q		  // 4-bit data output
); 

// port declaration and IO direction
input 		clr_n		;
input 		clk		;
input 	[1:0] 	i_s		; 
input 	[3:0] 	i_d		; 
input 		i_sr		;
input 		i_sl		;
output 	[3:0] 	o_q		;

// type overriding
reg 	[3:0] 	o_q		;

// local parameters for FSM states
localparam S_HOLD = 2'b00	; // Hold data
localparam S_SHR  = 2'b01	; // Shift Right
localparam S_SHL  = 2'b10	; // Shift Left
localparam S_LOAD = 2'b11	; // Parallel Load

// FSM state registers: state (current) / next_state (combinational)
reg 	[1:0] 	state		;
reg 	[1:0] 	next_state	;

// datapath next-value evaluation variable
reg 	[3:0] 	next_q		;

// -----------------------------------------------------------------
// Process 1: FSM state register (sequential)
// Updates the current state on the rising edge of clk
// -----------------------------------------------------------------
always @(posedge clk or negedge clr_n)
begin
	if	( ~clr_n ) state	<= S_HOLD	; // active low | async reset to HOLD state
	else	state			<= next_state	; // move to the evaluated next state
end

// -----------------------------------------------------------------
// Process 2: next-state logic (combinational)
// Directly maps the mode select input i_s to the next state
// -----------------------------------------------------------------
always @(*)
begin
	next_state = i_s; // mode select input determines the next state
end

// -----------------------------------------------------------------
// Process 3: datapath next-value logic (combinational, ASIC style)
// Determines next_q based on the current FSM state
// -----------------------------------------------------------------
always @(*) 
begin
	next_q = o_q; // default assignment (prevents unintended latch inference)
	case ( state )
		S_HOLD	: next_q = o_q			; // keep current value
		S_SHR	: next_q = {i_sr, o_q[3:1]}	; // load i_sr into MSB, shift right
		S_SHL	: next_q = {o_q[2:0], i_sl}	; // load i_sl into LSB, shift left
		S_LOAD	: next_q = i_d			; // load 4-bit parallel data
		default	: next_q = o_q			; // keep current value on exception
	endcase
end

// -----------------------------------------------------------------
// Process 4: datapath register (sequential)
// Latches the evaluated next_q into o_q on the rising edge of clk
// -----------------------------------------------------------------
always @(posedge clk or negedge clr_n) 
begin
	if	( ~clr_n ) o_q	<= 4'b0000		; // active low | async reset to 0000
	else	o_q		<= next_q		; // update o_q with next_q on clock edge
end
	
endmodule
