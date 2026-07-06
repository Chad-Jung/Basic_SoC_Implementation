`timescale 1ns / 1ps

module simple_register #(
	parameter BIT = 32
)(
	// port list
	clk		,
	rst_n		,
	wen		,
	i_wdata		,
	o_rdata
);

// port declaration
input	clk			;
input	rst_n			;
input	wen			;
input	[BIT-1:0]	i_wdata		;
output	[BIT-1:0]	o_rdata		;

// 32-bit internal register
reg	r_reg32			;

// modeling
always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
	   r_reg32 <= 32'b0	;
	end else if (wen) begin
	   r_reg32 <= i_wdata	;
	end
end


assign o_rdata = r_reg32	;

endmodule
	

