module Timer_PWM_IP(
inout [15 : 0] Dbus,
input [21 : 0] Addr,
input nAs,
input RnW,
input nWait,
input nRST,
input clk,
input [1:0] nBE,
input CS,
input Gate,
output signal_PWM,
output [31 : 0] Timer_Value,
output signal_TO,
output nIT_Timer
);

wire [15 : 0] Config , RC_PWM; 
wire validation_PWM;
wire [31 : 0] Init_To , Int_Timer_Value;
wire Int_clk , nIT_Timer1 , nIT_Timer2; 

assign Int_clk = clk;
assign Timer_Value = Int_Timer_Value;
assign nIT_Timer = nIT_Timer1 | nIT_Timer2 ; 

Timer Timer_Block (Config , Init_To , Int_clk , Gate , 
                   nRST , nIT_Timer1 , signal_TO , Int_Timer_Value);
                   
PWM PWM_Block (Int_clk , RC_PWM , validation_PWM , nRST , signal_PWM , nIT_Timer2);

Read_IF Read_IF_Block (Addr , Int_clk , RnW , Int_Timer_Value ,
                       nAs , nBE , nRST , nWait , CS , Dbus);
                       
Write_IF Write_IF_Block (Addr , Int_clk , RnW , nAS , nBE , nRST , nWait , Config ,
                         Init_To , RC_PWM , validation_PWM , Dbus , CS);

endmodule
