-------------------------------
-- MAR                        -          
-- 16 bit                     -
-- Output 9 bits              -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WHARWOOD_MAR IS
GENERIC(
	P:NATURAL:=16;
	MW:NATURAL:=9
	);
PORT(
	CLK:IN STD_LOGIC;
	RST:IN STD_LOGIC;
	EN:IN STD_LOGIC;
	BUS_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	MAR_OUT: OUT STD_LOGIC_VECTOR(MW-1 DOWNTO 0));
END WHARWOOD_MAR;

ARCHITECTURE BEH_ARCH OF WHARWOOD_MAR IS
SIGNAL TEMPQ: STD_LOGIC_VECTOR(MW-1 DOWNTO 0);

BEGIN
MAR_PROCESS:PROCESS(CLK)
BEGIN
	IF(CLK='1'AND CLK'EVENT)THEN
		IF(RST='1')THEN
		  TEMPQ<=(OTHERS=>'Z');
		ELSIF(EN='1')THEN
		  TEMPQ<=BUS_IN(MW-1 DOWNTO 0);
		ELSE
		  TEMPQ<=(OTHERS=>'Z');
		END IF;
	ELSE
	 
	END IF;
END PROCESS;
MAR_OUT<=TEMPQ;
END BEH_ARCH;

-------------------------------
-- MDR                        -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY WHARWOOD_MDR IS
GENERIC(
	P:NATURAL
	);
PORT(
	CLK:IN STD_LOGIC;
	RST:IN STD_LOGIC;
	EN:IN STD_LOGIC;
	BUS_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	MEM_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	MDR_OUT: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END WHARWOOD_MDR;

ARCHITECTURE BEH_ARCH OF WHARWOOD_MDR IS
SIGNAL TEMPQ: STD_LOGIC_VECTOR(P-1 DOWNTO 0); --- When enable is 1 write to memory when enable is 0 read from memory
BEGIN
MAR_PROCESS:PROCESS(CLK)
BEGIN
	IF(CLK='1'AND CLK'EVENT)THEN
		IF(RST='1')THEN
		  TEMPQ<=(OTHERS=>'Z');
		ELSIF(EN='1')THEN
		  TEMPQ<=BUS_IN(P-1 DOWNTO 0);
		ELSIF(EN='0')THEN
		  TEMPQ<=MEM_IN(P-1 DOWNTO 0);
		ELSE
		  TEMPQ<=(OTHERS=>'Z');
		END IF;
	ELSE
	END IF;
END PROCESS;
MDR_OUT<=TEMPQ;
END BEH_ARCH;

-------------------------------
-- RAM                        -          
-- 9 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;


entity WHARWOOD_RAM is
generic(P: natural:=16;
	MW: natural:=9);
port(	CLK: in std_logic;
	MEM_ADD : in std_logic_vector(MW-1 downto 0);
	DATA_IN : in std_logic_vector(P-1 downto 0);
	READ_WRITE_ENABLE  : in std_logic;
	MEM_ENABLE: in std_logic;
	DATA_OUT: out std_logic_vector(P-1 downto 0)
	
);
end WHARWOOD_RAM;

architecture RAM_ARCH of WHARWOOD_RAM is
type data_array is array (integer range <>) of std_logic_vector(P-1 downto 0);
signal data: data_array(0 to ((2**MW)-1)):=(
"0010000000001010", -- LOAD VALUE FROM ADDRESS 12(9) TO REG 0
"1010011000001010", -- LOAD(INDIRECT) FROM ADDRESS 13(5) TO REG 3
"0001010011000000", -- ADD FROM REG0 AND REG3 AND STORE IN REG 2
"0001101000100000", -- immediate add and write to dr 5
"1011101000001111", -- indirect store contents of register 5
"0101111010000011", -- and the contents of reg 2 and 3 and store in reg 0
"1001000111111111", -- not of reg 0 stored in reg 7
"0011010000001001", -- STORE VALUE IN REG 2 LOCAATION 14
"0000000000000000",
"0000000000000000",
"0000000000001001",
"0000000000001001",
"0000000000001110",
"0000000000000101",
"0000000000000101",
others=>"0000000000000000");
signal Sdata_out: std_logic_vector(P-1 downto 0);


begin
--data_array:=("0000000000000000");
process(CLK, READ_WRITE_ENABLE)
begin 

if (CLK'event and CLK='1')then

if (MEM_ENABLE = '1') then

if (READ_WRITE_ENABLE = '1') then

data(to_integer(unsigned(mem_add))) <= DATA_IN;
Sdata_out <= (others=>'Z');

else

Sdata_out <= data(to_integer(unsigned(mem_add)));
data<=data;

end if;

else

Sdata_out <= (others=>'Z');
data<=data;

end if;

else

Sdata_out <= Sdata_out;
data<=data;

end if;

end process;

DATA_OUT<=Sdata_out;

end RAM_ARCH;


-------------------------------
-- TRI-STATE                  -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library IEEE;
use ieee.std_logic_1164.all;

entity WHARWOOD_TRI_STATE IS
GENERIC(P:INTEGER:=16);
PORT(CLK:IN STD_LOGIC;
     EN: IN STD_LOGIC;
     OP_A:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
     OP_Q:OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
end WHARWOOD_TRI_STATE;

architecture sel_arch of WHARWOOD_TRI_STATE is
SIGNAL Sgate:std_logic_vector(P-1 downto 0);
begin
PROCESS(CLK)
BEGIN 
	IF(CLK='1' AND CLK'EVENT)THEN
		IF(EN='1')THEN
		  Sgate<= OP_A;
		ELSE
		 Sgate<=(OTHERS=>'Z');
		END IF;
	ELSE
	END IF;
END PROCESS;
OP_Q<=Sgate;
end sel_arch;

-------------------------------
-- Reg array                  -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Wharwood_Sixteen_Bit_Reg is

GENERIC(
	P:integer:=16
	);

 PORT(	CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	IR_EN: IN STD_LOGIC;
	BUS_IN: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	IR_OUT: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END Wharwood_Sixteen_Bit_Reg;

ARCHITECTURE BEHAVIOR OF Wharwood_Sixteen_Bit_Reg IS
	SIGNAL TEMP_Q:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
BEGIN
REG_CLK:PROCESS(CLK)
	BEGIN
	  IF(CLK='1' AND CLK'EVENT)THEN
	     IF(RESET='1')THEN
		TEMP_Q<="0000000000000000";
	     ELSIF(IR_EN='1')THEN
		TEMP_Q<=BUS_IN;
	     ELSE
		TEMP_Q<=TEMP_Q;
	     END IF;
	  ELSE
		TEMP_Q<=TEMP_Q;
	  END IF;
	END PROCESS REG_CLK;
IR_OUT<=TEMP_Q;
END BEHAVIOR;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Wharwood_Reg_array is
generic( P: INTEGER:=16;
	 W: INTEGER:=3;
	 E:NATURAL:=8);
port( CLK: in std_logic;
      RST: in std_logic;
      LD_REG: in std_logic;
      OP_A: in std_logic_vector(P-1 downto 0);
      DR: in std_logic_vector(W-1 downto 0);
      SR1: in std_logic_vector(W-1 downto 0);
      SR2: in std_logic_vector(W-1 downto 0);
      OP_Q: out std_logic_vector(P-1 downto 0);
      OP_Q2: out std_logic_vector(P-1 downto 0));
end Wharwood_Reg_array;

architecture GEN of Wharwood_Reg_array is

type regary is array(E-1 downto 0) of std_logic_vector(P-1 downto 0);
signal sEN: std_logic_vector(E-1 downto 0);
signal sFF:regary;

component Wharwood_Sixteen_Bit_Reg
generic(P: INTEGER:=16);
port( CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	IR_EN: IN STD_LOGIC;
	BUS_IN: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	IR_OUT: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
end component;

begin
 p0: PROCESS(DR,LD_REG)
 begin
  sEN <= (sEN'range=>'0');
  sEN(to_integer(unsigned(DR))) <= LD_REG;
end PROCESS;

g0: for j in 0 to (E-1) generate
 regh0: Wharwood_Sixteen_Bit_Reg
  port map(CLK,RST,sEN(j),OP_a,sFF(j));
end generate;

OP_q <= sFF(to_integer(unsigned(SR1)));
OP_q2 <= sFF(to_integer(unsigned(SR2)));

end GEN;

-------------------------------
-- NZP                        -          
-- 16 bit                     -
-- Output 3  bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity WHARWOOD_NZP is
GENERIC (
	P:integer:= 16;
	W:integer:= 3
	);
  PORT(
	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0)
	);
end WHARWOOD_NZP;

architecture process_arch of WHARWOOD_NZP is
SIGNAL TEMP_Q: STD_LOGIC_VECTOR(W-1 DOWNTO 0);

BEGIN
PROCESS(CLK)
	BEGIN
	  IF(CLK='1'AND CLK'EVENT)THEN
			IF(RST='1')THEN
		  		TEMP_Q <= "000";
			ELSIF(EN='1')THEN
		  		IF(OP_A="0000000000000000")THEN
		   			TEMP_Q <= "010";
		  		ELSIF(OP_A(P-1)='0')THEN
		   			TEMP_Q <= "001";
		  		ELSE 
		   			TEMP_Q <= "100";
		  		END IF;
			ELSE
		 		 TEMP_Q <= TEMP_Q;
			END IF;
	  ELSE
	    TEMP_Q <= TEMP_Q;
	  END IF;
	END PROCESS;
OP_Q <= TEMP_Q;
END process_arch;


-------------------------------
-- NTEEN-BIT REGISTER         -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity WHARWOOD_TEEN_BIT_REG is

GENERIC(
	W :integer
	);

 PORT(	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(W-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0));
END WHARWOOD_TEEN_BIT_REG;

ARCHITECTURE BEHAVIORAL OF WHARWOOD_TEEN_BIT_REG IS
	SIGNAL TEMP_Q:STD_LOGIC_VECTOR(W-1 DOWNTO 0);
BEGIN
REG_CLK:PROCESS(CLK)
	BEGIN
	  IF(CLK='1' AND CLK'EVENT)THEN
	     IF(RST='1')THEN
		TEMP_Q<="0000000000000000";
	     ELSIF(EN='1')THEN
		TEMP_Q<=OP_A;
	     ELSE
		TEMP_Q<=TEMP_Q;
	     END IF;
	  ELSE
		TEMP_Q<=TEMP_Q;
	  END IF;
	END PROCESS REG_CLK;
OP_Q<=TEMP_Q;
END BEHAVIORAL;


-------------------------------
-- PC COUNTER                 -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
entity WHARWOOD_PC_CNT is
GENERIC (
	P: integer
	);
  PORT(
	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	OP_Q2: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0)
	);
end WHARWOOD_PC_CNT;

ARCHITECTURE BEHAVIOR OF WHARWOOD_PC_CNT IS
SIGNAL PC_DATA: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL PC_DATA_PLUS: STD_LOGIC_VECTOR(P-1 DOWNTO 0);

BEGIN
LOAD_PC:PROCESS(CLK)

  BEGIN
	IF(CLK='1' AND CLK'EVENT) THEN
		IF (RST='1')THEN
		  PC_DATA<=(OTHERS =>'0');
		  PC_DATA_PLUS<= "0000000000000001";
		ELSIF(EN='1')THEN
		  PC_DATA<=OP_A;
	  	  PC_DATA_PLUS<=OP_A +'1';
		ELSE
		  PC_DATA<=PC_DATA;
	  	  PC_DATA_PLUS<=PC_DATA_PLUS;
		END IF;
	ELSE
	  PC_DATA<=PC_DATA;
	  PC_DATA_PLUS<=PC_DATA_PLUS;
	END IF;
END PROCESS;

OP_Q<=PC_DATA;
OP_Q2<=PC_DATA_PLUS;

END BEHAVIOR;

-------------------------------
-- ONE-BIT REGISTER           -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity WHARWOOD_ONE_BIT_REG is



 PORT(	CLK: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	EN: IN STD_LOGIC;
	OP_A: IN STD_LOGIC;
	OP_Q: OUT STD_LOGIC);
END WHARWOOD_ONE_BIT_REG;

ARCHITECTURE BEHAVIORAL OF WHARWOOD_ONE_BIT_REG IS
	SIGNAL TEMP_Q:STD_LOGIC;
BEGIN
REG_CLK:PROCESS(CLK)
	BEGIN
	  IF(CLK='1' AND CLK'EVENT)THEN
	     IF(RST='1')THEN
		TEMP_Q<='0';
	     ELSIF(EN='1')THEN
		TEMP_Q<=OP_A;
	     ELSE
		TEMP_Q<=TEMP_Q;
	     END IF;
	  ELSE
		TEMP_Q<=TEMP_Q;
	  END IF;
	END PROCESS REG_CLK;
OP_Q<=TEMP_Q;
END BEHAVIORAL;


-------------------------------
-- ALU                        -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity WHARWOOD_ALU is
GENERIC(
	P:INTEGER:=16);
port( 
     SR1_IN:in std_logic_vector(P-1 downto 0);	
     SR2_IN:in std_logic_vector(P-1 downto 0);
     SEl_ALU:in std_logic_vector(1 downto 0);
     OP_Q :out std_logic_vector (P-1 downto 0));

end WHARWOOD_ALU;

architecture sel_arch of WHARWOOD_ALU is

SIGNAL SALU:std_logic_vector(P-1 downto 0);

begin

SALU <=(SR1_IN+SR2_IN)WHEN(SEL_ALU="00")ELSE
	SR1_IN WHEN (SEL_ALU="01") ELSE
	(SR1_IN and SR2_IN) WHEN (SEL_ALU="10") ELSE 
	not SR1_IN;

OP_Q<= SALU;

end sel_arch;

-------------------------------
-- COMBO-ADDER                -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;

entity Wharwood_Combo_Adder is
GENERIC(
	P:INTEGER:=16);
  port(
	OP_A:in std_logic_vector(P-1 downto 0);
	OP_B:in std_logic_vector(P-1 downto 0);
	OP_Q:out std_logic_vector(P-1 downto 0));
end Wharwood_Combo_Adder;

architecture add_arch of Wharwood_Combo_Adder is

SIGNAL SALU:std_logic_vector(15 downto 0);

begin

SALU <=(OP_A+OP_B);
OP_Q<= SALU;
end add_arch;


-------------------------------
-- Shift Mode                 -          
-- 16 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------


library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_shift3mode is 
port ( 
	a: in std_logic_vector (7 downto 0) ; 
	lar : in std_logic_vector (1 downto 0) ; 
	amt : in std_logic_vector (2 downto 0) ; 
	OP_Q: out std_logic_vector (7 downto 0) ); 
end WHARWOOD_shift3mode ; 
 
architecture direct_arch of WHARWOOD_shift3mode is 
	signal logic_result , arith_result , rot_result :
		std_logic_vector (7 downto 0) ; 
begin 
   with amt select
	rot_result <=
	  a				when "000",
	  a(0) & a(7 downto 1)  	when "001",
	  a(1 downto 0) & a(7 downto 2) when "010",
	  a(2 downto 0) & a(7 downto 3) when "011",
	  a(3 downto 0) & a(7 downto 4) when "100",
	  a(4 downto 0) & a(7 downto 5) when "101",
	  a(5 downto 0) & a(7 downto 6) when "110",
	  a(6 downto 0) & a(7) when others;
  with amt select
	logic_result <=
	  a				when "000",
	  "0"	 & a(7 downto 1)  	when "001",
	  "00"		& a(7 downto 2) when "010",
	  "000" 	& a(7 downto 3) when "011",
	  "0000"	& a(7 downto 4) when "100",
	  "00000"	& a(7 downto 5) when "101",
	  "000000"	& a(7 downto 6) when "110",
	  "0000000"	& a(7) when others;

  with amt select
	arith_result<=
	  a				  when "000",
	  a(7) & a(7 downto 1)  	  when "001",
	  a(7) &a(7)    & a(7 downto 2)   when "010",
	  a(7) &a(7) &a(7) & a(7 downto 3) when "011",
	  a(7) &a(7) &a(7) &a(7) & a(7 downto 4) when "100",
	  a(7) &a(7) &a(7) &a(7) & a(7) & a(7 downto 5) when "101",
	  a(7) &a(7) &a(7) &a(7) &a(7) & a(7) & a(7 downto 6) when "110",
	  a(7) &a(7) &a(7) &a(7) &a(7) & a(7) &a(7)  & a(7) when others;

  with lar select
	OP_Q<=logic_result when"00",
	   arith_result when"01",
	   rot_result   when others;

end direct_arch;

architecture shared_arch of WHARWOOD_shift3mode is 
	signal shift_in: std_logic_vector (7 downto 0);
begin 
  with lar select 
	shift_in <= (others=>'0')  when "00", 
	    	    (others=>a(7)) when "01", 
	   	     a              when others; 
  with amt select 
	OP_Q <= a 			         when "000",
	     shift_in(0)          & a(7 downto 1) when "001", 
	     shift_in(1 downto 0) & a(7 downto 2) when "010", 
	     shift_in(2 downto 0) & a(7 downto 3) when "011", 
	     shift_in(3 downto 0) & a(7 downto 4) when "100", 
	     shift_in(4 downto 0) & a(7 downto 5) when "101", 
	     shift_in(5 downto 0) & a(7 downto 6) when "110", 
	     shift_in(6 downto 0) & a(7)          when others; 
end shared_arch; 

-------------------------------
-- Sign Extender5             -          
-- 5  bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------
library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_Sign_Extender is
GENERIC(
	P:INTEGER:=16); 
port ( 
	IR_OUT: in std_logic_vector (4 downto 0) ;  
	SEXT5: out std_logic_vector (P-1 downto 0) ); 
end WHARWOOD_Sign_Extender;

architecture sel_arch of WHARWOOD_Sign_Extender is

SIGNAL sOnes :STD_LOGIC_VECTOR(10 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(10 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(P-1 downto 0);

begin 
	WITH IR_OUT(4) SELECT
	
	sQ <= sOnes (10 downto 0) &IR_OUT(4 downto 0) WHEN '1',
	      sZeros (10 downto 0) &IR_OUT(4 downto 0) WHEN OTHERS;
	SEXT5 <= sQ;

end sel_arch;

-------------------------------
-- Sign Extender6             -          
--  6 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------
library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_Sign_Extender6 is 
GENERIC(
	P:INTEGER:=16); 
port ( 
	IR_OUT: in std_logic_vector (5 downto 0) ;  
	SEXT6: out std_logic_vector (P-1 downto 0) ); 
end WHARWOOD_Sign_Extender6;

architecture sel_arch of WHARWOOD_Sign_Extender6 is

SIGNAL sOnes :STD_LOGIC_VECTOR(9 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(9 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH IR_OUT(5) SELECT
	
	sQ <= sOnes (9 downto 0) &IR_OUT(5 downto 0) WHEN '1',
	      sZeros (9 downto 0) &IR_OUT(5 downto 0) WHEN OTHERS;
	SEXT6 <= sQ;

end sel_arch;

-------------------------------
-- Sign Extender9             -          
--  9 bit                     -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_Sign_Extender9 is 
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (8 downto 0) ;  
	SEXT9: out std_logic_vector (P-1 downto 0) ); 
end WHARWOOD_Sign_Extender9;

architecture sel_arch of WHARWOOD_Sign_Extender9 is

SIGNAL sOnes :STD_LOGIC_VECTOR(6 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(6 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH IR_OUT(8) SELECT
	
	sQ <= sOnes (6 downto 0) &IR_OUT(8 downto 0) WHEN '1',
	      sZeros (6 downto 0) &IR_OUT(8 downto 0) WHEN OTHERS;
	SEXT9 <= sQ;

end sel_arch;

-------------------------------
-- Sign Extender11            -          
--  11 bit                    -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_Sign_Extender11 is 
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (10 downto 0) ;  
	SEXT11: out std_logic_vector (P-1 downto 0) ); 
end WHARWOOD_Sign_Extender11;

architecture sel_arch of WHARWOOD_Sign_Extender11 is

SIGNAL sOnes :STD_LOGIC_VECTOR(4 downto 0):=(OTHERS=>'1');
SIGNAL sZeros :STD_LOGIC_VECTOR(4 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH IR_OUT(10) SELECT
	
	sQ <= sOnes (4 downto 0) &IR_OUT(10 downto 0) WHEN '1',
	      sZeros (4 downto 0) &IR_OUT(10 downto 0) WHEN OTHERS;
	SEXT11 <= sQ;

end sel_arch;

-------------------------------
-- Zero Extender              -          
--  8  bit                    -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee;
use ieee.std_logic_1164.all ; 
entity WHARWOOD_Zero_Extender is 
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (7 downto 0) ;  
	ZEROEXT: out std_logic_vector (15 downto 0) ); 
end WHARWOOD_Zero_Extender;

architecture Z_arch of WHARWOOD_Zero_Extender is

SIGNAL sZeros :STD_LOGIC_VECTOR(7 downto 0):=(OTHERS=>'0');
SIGNAL sQ :STD_LOGIC_VECTOR(15 downto 0);

begin 
	WITH IR_OUT(7) SELECT
	
	sQ <= sZeros (7 downto 0) &IR_OUT(7 downto 0) WHEN OTHERS;
	ZEROEXT <= sQ;

end z_arch;

-------------------------------
-- MUX    4-1                 -          
--  16  bit                   -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee ; 
use ieee. std_logic_1164. all ; 
entity WHARWOOD_MUX4_1 is
GENERIC(
	P:INTEGER:=16); 
port ( 
	SEXT11,SEXT9,SEXT6,ZERO: in std_logic_vector(P-1 downto 0); 
	LD_ADDR2: in std_logic_vector (1 downto 0) ; 
	ADDR2_OUT: out std_logic_vector (P-1 downto 0) 
); 
end WHARWOOD_MUX4_1; 
architecture cond_arch of WHARWOOD_MUX4_1 is 
begin 
ADDR2_OUT <= SEXT11 when (LD_ADDR2="00") else 
     SEXT9 when (LD_ADDR2="01") else 
     SEXT6 when (LD_ADDR2="10") else 
     ZERO; 
end cond_arch ; 

-------------------------------
-- MUX   2-1                  -          
--  16  bit                   -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee ; 
use ieee. std_logic_1164. all ; 
entity WHARWOOD_MUX2_1 is 
GENERIC(
	P:INTEGER:=16);
port ( 
	OP_A,OP_B: in std_logic_vector(P-1 downto 0); 
	s: in std_logic ; 
	OP_Q: out std_logic_vector (P-1 downto 0) 
); 
end WHARWOOD_MUX2_1; 
architecture cond_arch of WHARWOOD_MUX2_1 is 
begin 
OP_Q <= OP_A when (S='0') else 
     OP_B;
     
end cond_arch; 

-------------------------------
-- MUX   3-1                  -          
--  16  bit                   -
-- Output 16 bits             -
-- Juwon Wharwood             -
--- LC3                       -
----Advanced Digital Systems  -
-------------------------------
-------------------------------

library ieee ; 
use ieee. std_logic_1164. all ; 
entity WHARWOOD_MUX3_1 is
GENERIC(
	P:INTEGER:=16); 
port ( 
	OP_A,OP_B,OP_C: in std_logic_vector(15 downto 0); 
	s: in std_logic_vector (1 downto 0) ; 
	OP_Q: out std_logic_vector (15 downto 0) 
); 
end WHARWOOD_MUX3_1; 
architecture cond_arch of WHARWOOD_MUX3_1 is 
begin 
OP_Q <= OP_A when (S="00") else 
     OP_B when (s="01") else 
     OP_C;
end cond_arch ; 

-----------------------------
--- FSM
--- LC3 CONTROLLER
--- Juwon Wharwood
---LC3
--- Advanced Digital Systems
-----------------------------
-----------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY LC3_FSM IS
GENERIC(P:INTEGER:=16;
	W:INTEGER:=3);
PORT(
	CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	FROM_IR: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	FROM_NZP: IN STD_LOGIC_VECTOR(W-1 DOWNTO 0);
	LD_IR: OUT STD_LOGIC;
	LD_MARMUX: OUT STD_LOGIC;
	LD_REG: OUT STD_LOGIC;
	LD_PC: OUT STD_LOGIC;
	LD_MAR: OUT STD_LOGIC;
	LD_MDR: OUT STD_LOGIC;
	LD_CC: OUT STD_LOGIC;
	READ_WRITE_ENABLE: OUT STD_LOGIC;
	MEM_EN: OUT STD_LOGIC;
	GATE_PC: OUT STD_LOGIC;
	GATE_MARMUX: OUT STD_LOGIC;
	GATE_ALU: OUT STD_LOGIC;
	GATE_MDR: OUT STD_LOGIC;
	LD_ADDR1MUX: OUT STD_LOGIC;
	LD_SR2MUX: OUT STD_LOGIC;
	LD_PCMUX: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	LD_ALU: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	LD_ADDR2MUX: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	LD_SR1: OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0);
	LD_SR2: OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0);
	LD_DR: OUT STD_LOGIC_VECTOR(W-1 DOWNTO 0)

);
END LC3_FSM;

ARCHITECTURE BEH OF LC3_FSM IS

TYPE LC3_STATE_TYPE IS (S0,S1,S2,S2A,S2B,S2C,S2D,S2E,S_DECD,LOAD_A,LOAD_B,LOAD_C,LOAD_D,
LOAD_E,LOAD_F,ILOAD_A,ILOAD_B,ILOAD_C,ILOAD_D,ILOAD_E,ILOAD_F,ILOAD_G,ILOAD_H,ILOAD_I,
STORE_A,STORE_B,STORE_C,STORE_D,STORE_E,ISTORE_A,ISTORE_B,ISTORE_C,ISTORE_D,ISTORE_E,
ISTORE_F,ISTORE_G,ISTORE_H,ISTORE_I,ADD_A);

SIGNAL CPU_STATE: LC3_STATE_TYPE;
SIGNAL NEXT_STATE: LC3_STATE_TYPE;

CONSTANT ADD: STD_LOGIC_VECTOR(3 DOWNTO 0):= "0001";-- ADD
CONSTANT ANDL: STD_LOGIC_VECTOR(3 DOWNTO 0):= "0101";-- AND
CONSTANT LOAD: STD_LOGIC_VECTOR(3 DOWNTO 0):= "0010";-- LOAD
CONSTANT ILOAD: STD_LOGIC_VECTOR(3 DOWNTO 0):= "1010";-- INDIRECT LOAD
CONSTANT NOTL: STD_LOGIC_VECTOR(3 DOWNTO 0):= "1001";-- NOT
CONSTANT STORE: STD_LOGIC_VECTOR(3 DOWNTO 0):= "0011";-- STORE IN MEMEORY
CONSTANT ISTORE: STD_LOGIC_VECTOR(3 DOWNTO 0):= "1011";-- INDIRECT STORE

BEGIN


NEXTSTATELOGIC:PROCESS(CLK)
BEGIN
	IF(CLK' EVENT AND CLK='1')THEN
		IF(RESET='1')THEN
		  CPU_STATE<=S0;
		ELSE
		  CPU_STATE<=NEXT_STATE;
		END IF;
	END IF;
END PROCESS;

PROCESS(FROM_IR,FROM_NZP,CPU_STATE,NEXT_STATE)

VARIABLE TRAPVECTOR:STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE OPCODE:STD_LOGIC_VECTOR(3 DOWNTO 0);
VARIABLE PC_OFFSET: STD_LOGIC_VECTOR(10 DOWNTO 0);
VARIABLE SR1IN:STD_LOGIC_VECTOR(2 DOWNTO 0);
VARIABLE SR2IN:STD_LOGIC_VECTOR(2 DOWNTO 0);
VARIABLE DRIN:STD_LOGIC_VECTOR(2 DOWNTO 0);
VARIABLE IR_5:STD_LOGIC;
VARIABLE IMMEDIATE:STD_LOGIC_VECTOR(4 DOWNTO 0);
VARIABLE BASEREG:STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
--------------------------------------------------------
-------- INITIALIZE
--------------------------------------------------------

CASE CPU_STATE IS
 	WHEN S0=>
		LD_IR<='0';
		LD_MARMUX<='0';
		LD_REG<='0';
		LD_PC<='0';
		LD_MAR<='0';
		LD_MDR<='0';
		LD_CC<='0';
		READ_WRITE_ENABLE<='0';
		GATE_PC<='0';
		GATE_MARMUX<='0';
		GATE_ALU<='0';
		GATE_MDR<='0';
		LD_ADDR2MUX<=(OTHERS=>'0');
		LD_ADDR1MUX<='0';
		LD_SR1<=(OTHERS=>'0');
		LD_SR2<=(OTHERS=>'0');
		LD_DR<=(OTHERS=>'0');
		LD_SR2MUX<='0';
		LD_PCMUX<=(OTHERS=>'0');
		LD_ALU<=(OTHERS=>'0');
		MEM_EN<='0';
		NEXT_STATE<=S1;
	
	WHEN S1=>
		GATE_MARMUX<='0';
		GATE_MDR<='0';
		LD_CC<='0';
		LD_PC<='0';----changed it to zero because we don't want the increment
		LD_MAR<='0';
		GATE_PC<='1';
		LD_PCMUX<="10";
		MEM_EN<='0';
		NEXT_STATE<=S2;

	WHEN S2=>
		LD_MAR<='0';
		NEXT_STATE<=S2A;
	
	WHEN S2A=>
		LD_MAR<='1';
		GATE_PC<='0';
		NEXT_STATE<=S2B;

	WHEN S2B=>
		MEM_EN<='1';
		LD_MAR<='0';
		NEXT_STATE<=S2C;
			
	WHEN S2C=>
		MEM_EN<='0';
		READ_WRITE_ENABLE<='0';
		LD_MDR<='0';
		NEXT_STATE<=S2D;
	WHEN S2D=>
		GATE_MDR<='1';
		MEM_EN<='0';
		NEXT_STATE<=S2E;

	WHEN S2E=>
		LD_IR<='1';
		GATE_MDR<='0';
		NEXT_STATE<=S_DECD;

	WHEN S_DECD=>
		OPCODE   := FROM_IR(15 DOWNTO 12);
		IR_5     := FROM_IR(5);
		DRIN   := FROM_IR(11 DOWNTO 9);
		SR1IN  := FROM_IR(8 DOWNTO 6);
		SR2IN  := FROM_IR(2 DOWNTO 0);
		PC_OFFSET:= FROM_IR(10 DOWNTO 0);
		
			CASE OPCODE IS
			WHEN ADD=>
				IF(IR_5<='1') THEN
				LD_IR<='0';
				LD_SR1<=SR1IN;
				LD_SR2MUX<='0';
				GATE_MARMUX<='0';
				GATE_ALU<='1';
				NEXT_STATE<=ADD_A;
				ELSE
				LD_IR<='0';
				LD_SR2MUX<='1';
				LD_SR1<=SR1IN;
				LD_SR2<=SR2IN;
				GATE_MARMUX<='0';
				GATE_ALU<='1';
				NEXT_STATE<=ADD_A;
				END IF;

			WHEN LOAD=>
				LD_IR<='0';
				LD_ADDR1MUX<='1';
				LD_ADDR2MUX<="10";
				LD_MARMUX<='1';
				GATE_MARMUX<='1';
				NEXT_STATE<=LOAD_A;
			
			WHEN ILOAD=>
				LD_IR<='0';
				LD_ADDR1MUX<='1';
				LD_ADDR2MUX<="10";
				LD_MARMUX<='1';
				GATE_MARMUX<='1';
				NEXT_STATE<=ILOAD_A;

			WHEN STORE=>
				LD_IR<='0';
				LD_ADDR1MUX<='1';
				LD_ADDR2MUX<="10";
				LD_MARMUX<='1';
				GATE_MARMUX<='1';
				NEXT_STATE<=STORE_A;


			WHEN ISTORE=>
				--LD_MAR<='1';
				LD_IR<='0';
				LD_ADDR1MUX<='1';
				LD_ADDR2MUX<="10";
				LD_MARMUX<='1';
				GATE_MARMUX<='1';
				GATE_ALU<='0';
				NEXT_STATE<=ISTORE_A;
			
			WHEN ANDL=>
				LD_IR<='0';
				LD_SR1<=SR1IN;
				LD_SR2<=SR2IN;
				LD_SR2MUX<='1';
				LD_ALU<="10";
				GATE_ALU<='1';
				GATE_MARMUX<='0';
				NEXT_STATE<=ADD_A;
			
			WHEN NOTL=>
				LD_IR<='0';
				LD_SR1<=SR1IN;
				LD_SR2MUX<='1';
				LD_ALU<="11";
				GATE_ALU<='1';
				GATE_MARMUX<='0';
				NEXT_STATE<=ADD_A;

			WHEN OTHERS=>
			NEXT_STATE<=S0;
		END CASE;
	
	WHEN LOAD_A=>
		LD_MAR<='1';
		GATE_MARMUX<='0';
		LD_ADDR1MUX<='0';
		LD_ADDR2MUX<="00";
		LD_MARMUX<='0';
		NEXT_STATE<=LOAD_B;

	WHEN LOAD_B=>
		MEM_EN<='1';
		LD_MAR<='0';
		READ_WRITE_ENABLE<='0';
		NEXT_STATE<=LOAD_C;

	WHEN LOAD_C=>
		MEM_EN<='0';
		NEXT_STATE<=LOAD_D;

	WHEN LOAD_D=>
		GATE_MDR<='1';
		NEXT_STATE<=LOAD_E;
	
	WHEN LOAD_E=>
		LD_REG<='1';
		LD_DR<=DRIN;
		GATE_MDR<='0';
		LD_PCMUX<="10";
		NEXT_STATE <=LOAD_F;

	WHEN LOAD_F=>
		LD_REG<='0';
		LD_DR<="000";
		LD_PC<='1';
		NEXT_STATE<=S1;

	WHEN ILOAD_A=>
		LD_MAR<='1';
		GATE_MARMUX<='0';
		LD_ADDR1MUX<='0';
		LD_ADDR2MUX<="00";
		LD_MARMUX<='0';
		NEXT_STATE<=ILOAD_B;

	WHEN ILOAD_B=>
		MEM_EN<='1';
		LD_MAR<='0';
		READ_WRITE_ENABLE<='0';
		NEXT_STATE<=ILOAD_C;

	WHEN ILOAD_C=>
		MEM_EN<='0';
		NEXT_STATE<=ILOAD_D;

	WHEN ILOAD_D=>
		GATE_MDR<='1';
		NEXT_STATE<=ILOAD_E;

	WHEN ILOAD_E=>
		GATE_MDR<='0';
		LD_MAR<='1';
		NEXT_STATE<=ILOAD_F;

	WHEN ILOAD_F=>
		LD_MAR<='0';
		MEM_EN<='1';
		READ_WRITE_ENABLE<='0';
		NEXT_STATE<= ILOAD_G;

	WHEN ILOAD_G=>
		MEM_EN<='0';
		NEXT_STATE<=ILOAD_H;

	WHEN ILOAD_H=>
		GATE_MDR<='1';
		NEXT_STATE<= ILOAD_I;

	WHEN ILOAD_I=>
		GATE_MDR<='0';
		LD_REG<='1';
		LD_DR<=DRIN;
		LD_PCMUX<="10";
		NEXT_STATE<=LOAD_F;

	WHEN STORE_A=>
		GATE_MARMUX<='0';
		LD_MAR<='1';
		NEXT_STATE<=STORE_B;

	WHEN STORE_B=>
		LD_MAR<='0';
		LD_SR1<=DRIN;
		LD_ALU<="10";
		GATE_ALU<='1';
		NEXT_STATE<=STORE_C;

	WHEN STORE_C=>
		GATE_ALU<='0';
		LD_MDR<='1';
		NEXT_STATE<=STORE_D;

	WHEN STORE_D=>
		LD_MDR<='0';
		MEM_EN<='1';
		READ_WRITE_ENABLE<='1';
		LD_PCMUX<="10";
		NEXT_STATE<=STORE_E;

	WHEN STORE_E=>
		MEM_EN<='0';
		READ_WRITE_ENABLE<='0';
		NEXT_STATE<=S1;

	WHEN ISTORE_A=>
		GATE_MARMUX<='0';
		LD_MAR<='1';
		NEXT_STATE<=ISTORE_B;

	WHEN ISTORE_B=>
		LD_MAR<='0';
		MEM_EN<='1';
		READ_WRITE_ENABLE<='0';
		NEXT_STATE<=ISTORE_C;

	WHEN ISTORE_C=>
		MEM_EN<='0';
		LD_MDR<='0';
		NEXT_STATE<=ISTORE_D;

	WHEN ISTORE_D =>
		GATE_MDR<='1';
		NEXT_STATE<=ISTORE_E;

	WHEN ISTORE_E =>
		GATE_MDR<='0';
		LD_MAR<='1';
		NEXT_STATE<=ISTORE_F;

	WHEN ISTORE_F =>
		LD_MAR<='0';
		LD_SR1<=DRIN;
		LD_ALU<="01";
		GATE_ALU<='1';
		NEXT_STATE<=ISTORE_G;

	WHEN ISTORE_G=>
		LD_MDR<='1';
		LD_SR1<="000";
		LD_ALU<="00";
		GATE_ALU<='0';
		NEXT_STATE<=ISTORE_H;

	WHEN ISTORE_H =>
		LD_MDR<='0';
		MEM_EN<='1';
		READ_WRITE_ENABLE<='1';
		LD_PCMUX<="10";
		NEXT_STATE<=ISTORE_I;

	WHEN ISTORE_I =>
		MEM_EN<='0';
		READ_WRITE_ENABLE<='0';
		LD_PC<='1';
		NEXT_STATE<=S1;
	
	WHEN ADD_A=>
		LD_REG<='1';
		LD_DR<=DRIN;
		LD_SR1<="000";
		LD_SR2<="000";
		LD_PCMUX<="10";
		GATE_ALU<='0';
		NEXT_STATE<=LOAD_F;

	WHEN OTHERS =>
	NEXT_STATE<=S0;

END CASE;

END PROCESS;

END BEH;

	



			