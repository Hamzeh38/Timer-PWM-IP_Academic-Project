LIBRARY ieee;
USE ieee.std_logic_1164. all ;
USE ieee.std_logic_arith. all ;
LIBRARY xil_defaultlib ;
USE xil_defaultlib.IP_Package.all ;


ENTITY TestBench IS

PORT (
DBus : INOUT Defdata;
Addr : OUT DefAddr;
CLK : OUT DefBit;
RnW : OUT DefBit;
nAS : OUT DefBit;
nBE0_nBE1 : OUT DefnBE;
nRST : OUT DefBit;
nWAIT : OUT DefBit;
Gate : OUT DefBit;
CS : OUT DefBit
);
END TestBench ;

ARCHITECTURE ArchTestBench OF TestBench IS
-- Declaration des signaux internes
Signal ClkInt, RstInt : DefBit ;
BEGIN
-- Affectations permanentes
CLK <= ClkInt;
nRST <= RstInt;

-- Processus signal nRST
ResetGenerator : process
begin
RstInt <= '0' ;
wait for 50 ns;
RstInt <= '1' ;
wait for 50 ns;
RstInt <= '0' ;
wait ;
end process ResetGenerator;

-- Processus génération d’horloge
ClockGenerator : process
begin
ClkInt <= '0' ;
wait for 10 ns;
ClkInt <= '1' ;
wait for 10 ns;
end process ClockGenerator;

GateValue : process
begin
Gate <= '0' ;
wait for 30 ns;
Gate <= '1' ;
wait for 40 ns;
end process GateValue;


-- Processus de test des cycles
CPUonlyBehavior : process (RstInt,ClkInt)
variable TimerValue : DefValue;
variable Config : Defdata;
variable RCPWM : Defdata;
--Initialisation des états
type DefState is (idle, WritingInit_TO_1, EndWritingInit_TO_1,
WritingInit_TO_2, EndWritingInit_TO_2, WritingConfig,
EndWritingConfig, WritingRCPWM, EndWritingRCPWM,
WritingValidationPWM, EndWritingValidationPWM, Reading1, EndReading1,
Reading2, EndReading2);
variable State : DefState;
begin
--Initialisation des variables de notre process
if RstInt = '1' then
Addr <= ( others => '0' );
DBus <= ( others => 'Z' );
RnW <= '0' ;
CS <= '0' ;
State := Idle;
--Initialisation des constants et début des cycles
elsif rising_edge (ClkInt) then
Case State is
when idle =>
TimerValue := InitTimerValue;
Config := InitConfig;
RCPWM := InitRCPWM;
State := WritingInit_TO_1;
--Cycle d'écriture de la première partie de Init_TO
when WritingInit_TO_1 =>
Addr <= AddrInit_TO_LSB ;
DBus <= TimerValue(DataBusSize- 1 downto 0 );
RnW <= '0' ;
CS <= '1' ;
State := EndWritingInit_TO_1;
when EndWritingInit_TO_1 =>
DBus <= TriState;
CS <= '0' ;
State := WritingInit_TO_2;
--Cycle d'écriture de la deuxième partie de Init_TO
when WritingInit_TO_2 =>
Addr <= AddrInit_TO_MSB;
DBus(TimerValueSize- 1 -DataBusSize downto 0 ) <=
TimerValue(TimerValueSize- 1 downto DataBusSize);
RnW <= '0' ;
CS <= '1' ;
State := EndWritingInit_TO_2;
when EndWritingInit_TO_2 =>
DBus <= TriState;
CS <= '0' ;
State := WritingConfig;
--Cycle d'écriture de Config
when WritingConfig =>
Addr <= AddrConfig ;
DBus <= Config;
RnW <= '0' ;
CS <= '1' ;
State := EndWritingConfig;
when EndWritingConfig =>
DBus <= TriState;
CS <= '0' ;
State := WritingRCPWM;
--Cycle d'écriture du rapport cyclique
when WritingRCPWM =>
Addr <= AddrRCPWM ;
DBus <= RCPWM; -- à initialiser un constante RCPWM
RnW <= '0' ;
CS <= '1' ;
State := EndWritingRCPWM;
when EndWritingRCPWM =>
DBus <= TriState;
CS <= '0' ;
State := WritingValidationPWM;
--Cycle d'écriture du signal de validation de PWM
when WritingValidationPWM =>
Addr <= AddrValidationPWM ;
DBus <= "0000000000000001" ;
RnW <= '0' ;
CS <= '1' ;
State := EndWritingValidationPWM;
when EndWritingValidationPWM =>
DBus <= TriState;
CS <= '0' ;
State := Reading1;
--Cycle de lecture du premier partie de Timer_value
when Reading1 =>
Addr <= AddrTimerValueLSB;
RnW <= '1' ;
CS <= '1' ;
State := EndReading1;
when EndReading1 =>
TimerValue(DataBusSize- 1 downto 0 ) := DBus;
CS <= '0' ;
State := EndReading2;
--Cycle de lecture de la deuxième partie de Timer_value
when Reading2 =>
Addr <= AddrTimerValueMSB;
RnW <= '1' ;
CS <= '1' ;
State := EndReading2;
when EndReading2 =>
TimerValue(TimerValueSize- 1 downto DataBusSize) :=
DBus(TimerValueSize- 1 -DataBusSize downto 0 );
CS <= '0' ;
State := Reading1;
end case ;
end if ;
end process CPUonlyBehavior;
END ARCHITECTURE ArchTestBench;

