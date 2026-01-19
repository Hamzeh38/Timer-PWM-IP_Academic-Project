LIBRARY ieee;
USE ieee.std_logic_1164. all ;

PACKAGE IP_Package IS
--Constantes pour les types
constant AddrBusSize : integer := 22 ;
constant DataBusSize : integer := 16 ;
constant TimerValueSize : integer := 32 ;
constant nBESize : integer := 2 ;

--Data type for the project
subtype DefAddr is std_logic_vector (AddrBusSize- 1 downto 0 );
subtype Defdata is std_logic_vector (DataBusSize- 1 downto 0 );
subtype DefBit is std_logic ;
subtype DefRam is std_logic_vector (DataBusSize- 1 downto 0 );
subtype DefValue is std_logic_vector (TimerValueSize- 1 downto 0 );
subtype DefnBE is std_logic_vector (nBESize- 1 downto 0 );

--Constants of the project
constant TriState : Defdata := ( others => 'Z' );
constant InitTimerValue : DefValue :=
"00000000000010100000000000000000" ; -- égal à 000A0000
constant InitConfig : Defdata := "0000000011110001" ;
constant InitRCPWM : Defdata := "0000001010110010" ;

--Définition des adresses
--Adresse de base = "0000000001000000000000"
constant AddrInit_TO_LSB : DefAddr := "0000000001000000000000" ;
constant AddrInit_TO_MSB : DefAddr := "0000000001000000000001" ;
constant AddrConfig : DefAddr := "0000000001000000000010" ;
constant AddrRCPWM : DefAddr := "0000000001000000000011" ;
constant AddrValidationPWM : DefAddr := "0000000001000000000100" ;
constant AddrTimerValueLSB : DefAddr := "0000000001000000000101" ;
constant AddrTimerValueMSB : DefAddr := "0000000001000000000110" ;
END IP_Package;