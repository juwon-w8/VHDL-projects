LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY WHARWOOD_LC3 IS
GENERIC( P:INTEGER:=16;
	 MW:INTEGER:=9;
	 W:INTEGER:=3;
	 E:NATURAL:=8);

PORT(
	CLK:IN STD_LOGIC;
	RESET:IN STD_LOGIC
	
);
END WHARWOOD_LC3;

ARCHITECTURE STRUCTURAL OF WHARWOOD_LC3 IS

---------------------------------------------------------------------------------------
--PATH COMPONENTS
---------------------------------------------------------------------------------------

COMPONENT WHARWOOD_MAR 
GENERIC(
	P:INTEGER:=16;
	MW:INTEGER:=9
	);
PORT(
	CLK:IN STD_LOGIC;
	RST:IN STD_LOGIC;
	EN:IN STD_LOGIC;
	BUS_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	MAR_OUT: OUT STD_LOGIC_VECTOR(MW-1 DOWNTO 0));
END COMPONENT;

COMPONENT WHARWOOD_MDR 
GENERIC(
	P:INTEGER:=16
	);
PORT(
	CLK:IN STD_LOGIC;
	RST:IN STD_LOGIC;
	EN:IN STD_LOGIC;
	BUS_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);--FROM BUS(WRITE)
	MEM_IN:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);-- FROM MEM(READ)
	MDR_OUT: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));-- TO BUS
END COMPONENT;

COMPONENT WHARWOOD_RAM 
generic(P: INTEGER:=16;
	MW: INTEGER:=9);
port(	CLK: in std_logic;
	MEM_ENABLE: in std_logic;
	READ_WRITE_ENABLE  : in std_logic;
	MEM_ADD : in std_logic_vector(MW-1 downto 0);
	DATA_IN : in std_logic_vector(P-1 downto 0);
	DATA_OUT: out std_logic_vector(P-1 downto 0)
	
);
end COMPONENT;

COMPONENT WHARWOOD_TRI_STATE
GENERIC(P:INTEGER:=16);
PORT(CLK:IN STD_LOGIC;
     EN: IN STD_LOGIC;
     OP_A:IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
     OP_Q:OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END COMPONENT;

COMPONENT Wharwood_Sixteen_Bit_Reg 

GENERIC(
	P:integer:=16
	);

 PORT(	CLK: IN STD_LOGIC;
	RESET: IN STD_LOGIC;
	IR_EN: IN STD_LOGIC;
	BUS_IN: IN STD_LOGIC_VECTOR(P-1 DOWNTO 0);
	IR_OUT: OUT STD_LOGIC_VECTOR(P-1 DOWNTO 0));
END COMPONENT;

COMPONENT WHARWOOD_Sign_Extender 

GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (4 downto 0) ;  
	SEXT5: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT WHARWOOD_Sign_Extender;

COMPONENT WHARWOOD_Sign_Extender6  
GENERIC(
	P:INTEGER:=16); 
port ( 
	IR_OUT: in std_logic_vector (5 downto 0) ;  
	SEXT6: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT WHARWOOD_Sign_Extender6;

COMPONENT WHARWOOD_Sign_Extender9 
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (8 downto 0) ;  
	SEXT9: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT WHARWOOD_Sign_Extender9;

COMPONENT WHARWOOD_Sign_Extender11  
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (10 downto 0) ;  
	SEXT11: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT WHARWOOD_Sign_Extender11;

COMPONENT WHARWOOD_Zero_Extender  
GENERIC(
	P:INTEGER:=16);
port ( 
	IR_OUT: in std_logic_vector (7 downto 0) ;  
	ZEROEXT: out std_logic_vector (P-1 downto 0) ); 
END COMPONENT WHARWOOD_Zero_Extender;

COMPONENT WHARWOOD_MUX4_1 
GENERIC(
	P:INTEGER:=16);
port ( 
	SEXT11,SEXT9,SEXT6,ZERO: in std_logic_vector(P-1 downto 0); 
	LD_ADDR2: in std_logic_vector (1 downto 0) ; 
	ADDR2_OUT: out std_logic_vector (P-1 downto 0) 
); 
END COMPONENT WHARWOOD_MUX4_1; 

COMPONENT WHARWOOD_MUX2_1 
GENERIC(
	P:INTEGER:=16); 
port ( 
	OP_A,OP_B: in std_logic_vector(P-1 downto 0); 
	s: in std_logic ; 
	OP_Q: out std_logic_vector (P-1 downto 0) 
); 
END COMPONENT WHARWOOD_MUX2_1;

COMPONENT Wharwood_Combo_Adder 
GENERIC(
	P:INTEGER:=16);
  port(
	OP_A:in std_logic_vector(P-1 downto 0);
	OP_B:in std_logic_vector(P-1 downto 0);
	OP_Q:out std_logic_vector(P-1 downto 0));
END COMPONENT Wharwood_Combo_Adder;

COMPONENT Wharwood_Reg_array 
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
END COMPONENT Wharwood_Reg_array;

COMPONENT WHARWOOD_ALU 
GENERIC(
	P:INTEGER:=16);
port( 
     SR1_IN:in std_logic_vector(P-1 downto 0);	
     SR2_IN:in std_logic_vector(P-1 downto 0);
     SEl_ALU:in std_logic_vector(1 downto 0);
     OP_Q :out std_logic_vector (P-1 downto 0));

END COMPONENT WHARWOOD_ALU;

COMPONENT WHARWOOD_MUX3_1 
GENERIC(
	P:INTEGER:=16); 
port ( 
	OP_A,OP_B,OP_C: in std_logic_vector(P-1 downto 0); 
	s: in std_logic_vector (1 downto 0) ; 
	OP_Q: out std_logic_vector (P-1 downto 0) 
); 
END COMPONENT WHARWOOD_MUX3_1; 

COMPONENT WHARWOOD_PC_CNT is
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
END COMPONENT WHARWOOD_PC_CNT;

COMPONENT WHARWOOD_NZP 
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
END COMPONENT WHARWOOD_NZP;

COMPONENT LC3_FSM IS
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
END COMPONENT;

SIGNAL S_MAR_OUT: STD_LOGIC_VECTOR(MW-1 DOWNTO 0);--READ/WRITE ADRESS TO MEM
SIGNAL S_MDR_BUS: STD_LOGIC_VECTOR(P-1 DOWNTO 0); --DATA FROM MDR TO BUS/MEM
SIGNAL S_MEM_OUT: STD_LOGIC_VECTOR(P-1 DOWNTO 0); --DATA FROM MEM TO MDR

SIGNAL S_IR_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);--- DATA FROM IR TO S-EXTEMDERS ETC
SIGNAL S_SEXT5: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SEXT6: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SEXT9: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SEXT11: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_ZEROEXT: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_ZERO:STD_LOGIC_VECTOR(P-1 DOWNTO 0):=(OTHERS=>'0');
SIGNAL S_ADDR2_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SR1_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_PC_PLUS:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_ADDR1_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SR2_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_SR2_MUX_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_COMBO_ADD_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_MAR_MUX_OUT:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_BUS:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_ALU_OUT: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_PC_MUX_OUT: STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_PC:STD_LOGIC_VECTOR(P-1 DOWNTO 0);
SIGNAL S_NZP_OUT:STD_LOGIC_VECTOR(W-1 DOWNTO 0);


SIGNAL S_LD_IR: STD_LOGIC;
SIGNAL S_LD_MARMUX:  STD_LOGIC;
SIGNAL S_LD_REG:  STD_LOGIC;
SIGNAL S_LD_PC:  STD_LOGIC;
SIGNAL S_LD_MAR:  STD_LOGIC;
SIGNAL S_LD_MDR:  STD_LOGIC;
SIGNAL S_LD_CC:  STD_LOGIC;
SIGNAL S_READ_WRITE_ENABLE:  STD_LOGIC;
SIGNAL S_MEM_EN:  STD_LOGIC;
SIGNAL S_GATE_PC:  STD_LOGIC;
SIGNAL S_GATE_MARMUX:  STD_LOGIC;
SIGNAL S_GATE_ALU:  STD_LOGIC;
SIGNAL S_GATE_MDR:  STD_LOGIC;
SIGNAL S_LD_ADDR1MUX:  STD_LOGIC;
SIGNAL S_LD_SR2MUX:  STD_LOGIC;
SIGNAL S_LD_PCMUX:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL S_LD_ALU:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL S_LD_ADDR2MUX:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL S_LD_SR1:  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
SIGNAL S_LD_SR2:  STD_LOGIC_VECTOR(W-1 DOWNTO 0);
SIGNAL S_LD_DR:  STD_LOGIC_VECTOR(W-1 DOWNTO 0);

	



BEGIN

----------------------------------------------------------------------------------------------------
--INSTANTIATIONS
----------------------------------------------------------------------------------------------------

-------------RAM

Inst1_MAR:WHARWOOD_MAR GENERIC MAP(P,MW)PORT MAP(CLK , RESET , S_LD_MAR , S_BUS , S_MAR_OUT);
Inst2_RAM:WHARWOOD_RAM GENERIC MAP(P,MW)PORT MAP(CLK, S_MEM_EN , S_READ_WRITE_ENABLE , S_MAR_OUT , S_MDR_BUS , S_MEM_OUT);
Inst3_MDR:WHARWOOD_MDR GENERIC MAP(P)PORT MAP(CLK,RESET,S_LD_MDR,S_BUS,S_MEM_OUT,S_MDR_BUS);
Inst4_GATE_MDR:WHARWOOD_TRI_STATE GENERIC MAP(P)PORT MAP(CLK,S_GATE_MDR,S_MDR_BUS,S_BUS);

-----------------------------------------------------------------------------------------------------
------------- INSTRUCTION REGISTER
Inst5_IR:Wharwood_Sixteen_Bit_Reg GENERIC MAP(P)PORT MAP(CLK,RESET,S_LD_IR,S_BUS,S_IR_OUT);
-----------------------------------------------------------------------------------------------------
-------------- SIGN EXTENDERS
Inst6_SEXT5:WHARWOOD_Sign_Extender GENERIC MAP(P)PORT MAP (S_IR_OUT(4 DOWNTO 0),S_SEXT5);
Inst7_SEXT6:WHARWOOD_Sign_Extender6 GENERIC MAP(P)PORT MAP (S_IR_OUT(5 DOWNTO 0),S_SEXT6);
Inst8_SEXT9:WHARWOOD_Sign_Extender9 GENERIC MAP(P)PORT MAP (S_IR_OUT(8 DOWNTO 0),S_SEXT9);
Inst9_SEXT11:WHARWOOD_Sign_Extender11 GENERIC MAP(P)PORT MAP (S_IR_OUT(10 DOWNTO 0),S_SEXT11);
Inst10_ZEROEXT:WHARWOOD_Zero_Extender GENERIC MAP(P)PORT MAP (S_IR_OUT(7 DOWNTO 0),S_ZEROEXT);
-----------------------------------------------------------------------------------------------------
-------------MUXES
Inst11_ADDR2_MUX:WHARWOOD_MUX4_1 GENERIC MAP(P)PORT MAP (S_SEXT11,S_SEXT9,S_SEXT6,S_ZERO,S_LD_ADDR2MUX,S_ADDR2_OUT);
Inst12_ADDR1_MUX:WHARWOOD_MUX2_1 GENERIC MAP(P)PORT MAP (S_SR1_OUT,S_PC_PLUS,S_LD_ADDR1MUX,S_ADDR1_OUT);
Inst13_SR2_MUX:WHARWOOD_MUX2_1 GENERIC MAP(P)PORT MAP (S_SEXT5,S_SR2_OUT,S_LD_SR2MUX,S_SR2_MUX_OUT);
Inst14_COMBO_ADD:Wharwood_Combo_Adder GENERIC MAP(P) PORT MAP (S_ADDR2_OUT,S_ADDR1_OUT,S_COMBO_ADD_OUT);
Inst15_MAR_MUX:WHARWOOD_MUX2_1 GENERIC MAP(P)PORT MAP (S_ZEROEXT,S_COMBO_ADD_OUT,S_LD_MARMUX,S_MAR_MUX_OUT);
Inst16_GATE_MARMUX:WHARWOOD_TRI_STATE GENERIC MAP(P)PORT MAP(CLK,S_GATE_MARMUX,S_MAR_MUX_OUT,S_BUS);
-------------------------------------------------------------------------------------------------------
------------- REG FILE
Isnt17_REG_FILE:Wharwood_Reg_array GENERIC MAP(P,W,E)PORT MAP(CLK,RESET,S_LD_REG,S_BUS,S_LD_DR,S_LD_SR1,S_LD_SR2,S_SR1_OUT,S_SR2_OUT);
--------------------------------------------------------------------------------------------------------
------------- ALU
Inst18_ALU:WHARWOOD_ALU GENERIC MAP(P) PORT MAP (S_SR2_OUT,S_SR1_OUT,S_LD_ALU,S_ALU_OUT);
Inst19_GATE_ALU:WHARWOOD_TRI_STATE GENERIC MAP(P)PORT MAP(CLK,S_GATE_ALU,S_ALU_OUT,S_BUS);
--------------------------------------------------------------------------------------------------------
------------ PC COUNTER
Inst20_PC_MUX:WHARWOOD_MUX3_1 GENERIC MAP(P) PORT MAP (S_BUS,S_COMBO_ADD_OUT,S_PC_PLUS,S_LD_PCMUX,S_PC_MUX_OUT);
Inst21_PC_CNT:WHARWOOD_PC_CNT GENERIC MAP(P) PORT MAP (CLK,RESET,S_LD_PC,S_PC_MUX_OUT,S_PC,S_PC_PLUS);
Inst22_GATE_PC:WHARWOOD_TRI_STATE GENERIC MAP(P)PORT MAP(CLK,S_GATE_PC,S_PC,S_BUS);
---------------------------------------------------------------------------------------------------------
------------N Z P
Inst23_NZP:WHARWOOD_NZP GENERIC MAP (P) PORT MAP (CLK,RESET,S_LD_CC,S_BUS,S_NZP_OUT);
---------------------------------------------------------------------------------------------------------
------------F S M
Inst24_FSM:LC3_FSM GENERIC MAP(P,W) PORT MAP (CLK,RESET,S_IR_OUT,S_NZP_OUT,S_LD_IR,S_LD_MARMUX,S_LD_REG,S_LD_PC,
S_LD_MAR,S_LD_MDR,S_LD_CC,S_READ_WRITE_ENABLE,S_MEM_EN,S_GATE_PC,S_GATE_MARMUX,S_GATE_ALU,S_GATE_MDR,
S_LD_ADDR1MUX,S_LD_SR2MUX,S_LD_PCMUX,S_LD_ALU,S_LD_ADDR2MUX,S_LD_SR1,S_LD_SR2,S_LD_DR);
---------------------------------------------------------------------------------------------------------
END STRUCTURAL;

