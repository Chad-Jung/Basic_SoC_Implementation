
//input ports
add mapped point clr_n clr_n -type PI PI
add mapped point clk clk -type PI PI
add mapped point i_s[1] i_s[1] -type PI PI
add mapped point i_s[0] i_s[0] -type PI PI
add mapped point i_d[3] i_d[3] -type PI PI
add mapped point i_d[2] i_d[2] -type PI PI
add mapped point i_d[1] i_d[1] -type PI PI
add mapped point i_d[0] i_d[0] -type PI PI
add mapped point i_sr i_sr -type PI PI
add mapped point i_sl i_sl -type PI PI

//output ports
add mapped point o_q[3] o_q[3] -type PO PO
add mapped point o_q[2] o_q[2] -type PO PO
add mapped point o_q[1] o_q[1] -type PO PO
add mapped point o_q[0] o_q[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point o_q[0]/q o_q_reg[0]/Q -type DFF DFF
add mapped point o_q[1]/q o_q_reg[1]/Q -type DFF DFF
add mapped point o_q[3]/q o_q_reg[3]/Q -type DFF DFF
add mapped point o_q[2]/q o_q_reg[2]/Q -type DFF DFF
add mapped point state[1]/q state_reg[1]/Q -type DFF DFF
add mapped point state[0]/q state_reg[0]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
