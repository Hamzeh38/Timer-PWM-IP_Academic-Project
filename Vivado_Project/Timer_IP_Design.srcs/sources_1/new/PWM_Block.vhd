LIBRARY ieee;
USE ieee.std_logic_1164. all ;
USE ieee.std_logic_unsigned. all ;
USE ieee.numeric_std. ALL ;
LIBRARY xil_defaultlib ;
USE xil_defaultlib.IP_Package.all ;

ENTITY PWM IS
PORT (
CLK : IN DefBit;
RC_PWM : IN Defdata; -- Duty cycle and frequency of the signal
Validation_PWM : IN DefBit; -- Activation of the Generation of the PWM signal from the processor
nRST : IN DefBit;
Signal_PWM : OUT DefBit; -- PWM output signal
IT : OUT DefBit -- Interruption signal
);
END PWM ;

ARCHITECTURE PWM_Arch OF PWM IS
Signal Tmax: STD_LOGIC_VECTOR ( 7 DOWNTO 0 ); -- Frequncy of the PWM signal
BEGIN

PWM_Generation: PROCESS (CLK, nRST)
VARIABLE Rapport_Cyclique : STD_LOGIC_VECTOR ( 6 DOWNTO 0 );
variable counter: STD_LOGIC_VECTOR ( 8 DOWNTO 0 );
VARIABLE S_Horloge : DefBit;
VARIABLE OutPWM : DefBit;
BEGIN

-- Permanent assign 
Rapport_Cyclique := RC_PWM( 6 DOWNTO 0 );
Tmax <= RC_PWM( 14 DOWNTO 7 );
S_Horloge := RC_PWM( 15 );

IF nRST = '1' THEN
Signal_PWM <= '0' ;
counter:=( OTHERS => '0' );
ELSIF RISING_EDGE(CLK) THEN
IF Validation_PWM = '1' THEN

--Formula used : Count = (RapportCyclique/100) * Tmax
if (to_integer( unsigned (counter)) <=
(to_integer( unsigned (Rapport_Cyclique)) * to_integer( unsigned (Tmax)) / 100 )) then
OutPWM:= '1' ;
else
OutPWM:= '0' ;
END IF ;

if counter=Tmax then
counter:=( OTHERS => '0' );
else
counter:= counter+ 1 ;
end if ;
END IF ;
Signal_PWM<=OutPWM;
END IF ;
END PROCESS PWM_Generation;
END ARCHITECTURE PWM_Arch;