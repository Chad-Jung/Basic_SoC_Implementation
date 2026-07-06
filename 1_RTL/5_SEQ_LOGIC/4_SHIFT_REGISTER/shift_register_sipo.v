`timescale 1ns / 1ps

module shift_register_sipo #(
	parameter WIDTH = 32
)(
	// port list
	clk			,
	rst_n			,
	i_serial_in		,
	o_parallel_out
);

// port declaration
input clk			;
input rst_n			;
input i_serial_in	;
output [WIDTH-1:0] o_parallel_out	;

// modeling
reg [WIDTH-1:0] o_parallel_out	;
always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		o_parallel_out <= 32'b0;
	end else begin
		o_parallel_out <= {o_parallel_out[30:0], i_serial_in};
	end
end

endmodule

