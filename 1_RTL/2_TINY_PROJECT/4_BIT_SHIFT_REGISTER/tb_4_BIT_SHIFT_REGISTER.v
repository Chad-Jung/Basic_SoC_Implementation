`timescale 1ns / 1ps

module tb_4_BIT_SHIFT_REGISTER;

// stimulus signal
reg             clk             ;
reg             clr_n           ;
reg     [1:0]   i_s             ;
reg     [3:0]   i_d             ;
reg             i_sr            ;
reg             i_sl            ;

// monitor signal
wire    [3:0]   o_q             ;

// DUT instantiation
_4_BIT_SHIFT_REGISTER uut(
        .clr_n  (clr_n  )       ,
        .clk    (clk    )       ,
        .i_s    (i_s    )       ,
        .i_d    (i_d    )       ,
        .i_sr   (i_sr   )       ,
        .i_sl   (i_sl   )       ,
        .o_q    (o_q    )
);

// dumpfile gen
initial begin
        $dumpfile("./_4_BIT_SHIFT_REGISTER.vcd")         ;
        $dumpvars(0, tb_4_BIT_SHIFT_REGISTER)        ;
end

// clock generation
always #5 clk = ~clk;

// apply stimulus
initial begin
        // monitoring
        // NOTE: uut.state is added to the monitor because this DUT has a
        // real FSM state register. Since "state" is registered from i_s
        // (1-cycle delay) and o_q is registered from "state" (1 more
        // cycle delay), o_q always reflects i_s from TWO clock edges ago.
        // Watching uut.state alongside i_s/o_q makes this pipeline
        // behavior visible and lets you confirm the FSM is really
        // driven by a stored state, not by i_s directly.
        $monitor("Time=%0t | clk=%b | clr_n=%b | i_s=%b | state=%b | i_d=%b | i_sr=%b | i_sl=%b | o_q=%b",
                $time, clk, clr_n, i_s, uut.state, i_d, i_sr, i_sl, o_q);
	// init
        clk             = 1'b0          ;
        clr_n           = 1'b0          ;
        i_s             = 2'b00         ;
        i_d             = 4'b0000       ;
        i_sr            = 1'b0          ;
        i_sl            = 1'b0          ;
	// release async reset
        #12 clr_n       = 1'b1          ;
        
	// ---------------------------------------------------------
        // S_LOAD: parallel-load 4'b1010
        // Held for 2 cycles: 1 cycle for i_s to settle into "state",
        // 1 more cycle for that state to actually load into o_q.
	// ---------------------------------------------------------
        #10 i_s         = 2'b11         ; i_d  = 4'b1010 ;
        #10 ;   // settle cycle: state is now catching up to S_LOAD
        #10 ;   // o_q should now show the loaded value 4'b1010
        
	// ---------------------------------------------------------
        // S_HOLD: verify o_q stays unchanged
        // ---------------------------------------------------------
        #10 i_s         = 2'b00         ;
        #10 ;   // extra hold cycle to confirm o_q does not change

        // ---------------------------------------------------------
        // S_SHR: shift right, feeding i_sr = 1,0,1,0 in sequence
        // i_s is held at 2'b01 across this whole block so that once
        // "state" settles to S_SHR, every following clock edge
        // performs one real shift using the i_sr value present at
        // that edge.
        // ---------------------------------------------------------
        #10 i_s         = 2'b01         ; i_sr = 1'b1   ; // state settling to S_SHR
        #10 i_sr        = 1'b0          ;                 // first real shift happens here (uses i_sr=1)
        #10 i_sr        = 1'b1          ;                 // second real shift (uses i_sr=0)
        #10 i_sr        = 1'b0          ;                 // third real shift (uses i_sr=1)
        #10 ;                                              // fourth real shift (uses i_sr=0)

        // ---------------------------------------------------------
        // S_SHL: shift left, feeding i_sl = 1,0,1 in sequence
        // Same settle-then-shift pattern as S_SHR above.
        // ---------------------------------------------------------
        #10 i_s         = 2'b10         ; i_sl = 1'b1   ; // state settling to S_SHL
        #10 i_sl        = 1'b0          ;                 // first real shift (uses i_sl=1)
        #10 i_sl        = 1'b1          ;                 // second real shift (uses i_sl=0)
        #10 ;                                              // third real shift (uses i_sl=1)

        // ---------------------------------------------------------
        // S_HOLD: return to hold and confirm final value is stable
        // ---------------------------------------------------------
        #10 i_s         = 2'b00         ;
        #10 ;

        #20 $finish                     ;
end

endmodule
