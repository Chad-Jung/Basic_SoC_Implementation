`timescale 1ns / 1ps

module d_latch(
	// port list
	clk	,
	i_d	,
	o_q
);

// port declaration
input	i_d		;
input	clk		;
output	o_q		;

// modeling
reg	o_q			;
always @(*) begin
	if( clk ) o_q <= i_d	;
end

endmodule
