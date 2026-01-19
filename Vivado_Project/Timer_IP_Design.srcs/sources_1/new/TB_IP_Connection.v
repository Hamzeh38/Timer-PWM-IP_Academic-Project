`timescale 1ns / 1ps

module TB_IP_Connection;
wire [15:0] DBus;
wire [22:0] Addr;
wire nAS , RnW , nWAIT , nRST , CLK , nBE0_nBE1 , CS , Gate ;
wire signal_PWM , signal_TO , nIT_Timer;
wire [31 : 0] Timer_Value;

Timer_PWM_IP Timer_PWM_IP_TestBlock (DBus , Addr , nAS , RnW , nWAIT , nRST ,
                                     CLK , nBE0_nBE1 , CS , Gate , signal_PWM , 
                                     Timer_Value , signal_TO , nIT_Timer);

TestBench TestBench_Block (DBus , Addr , CLK , RnW , nAS , nBE0_nBE1 , nRST , 
                           nWAIT , Gate , CS);

endmodule
