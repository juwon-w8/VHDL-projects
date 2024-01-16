------------------------------------------------------------------
--Floating Point Adder
------------------------------------------------------------------
--Inputs: clk, rst, EnL, EnR, OP_A, OP_B
------------------------------------------------------------------
--Outputs: Q, DONE
------------------------------------------------------------------
-- Juwon Wharwood & Marvin Atwell
-- Floating Point Adder
-- Computer Systems Architechture
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
entity FPA is  
	port (
		clk, rst, EnR,EnL: in std_logic;
		OP_A, OP_B: in std_logic_vector (31 downto 0);
		OP_Q: out std_logic_vector (31 downto 0);
		DONE: out std_logic
); 
end FPA;

architecture arch_FPA of FPA is

--Component Declaration
component CompareExp is
	port(
		clk: in std_logic;
		rst: in std_logic;
		EnR: in std_logic;
		EnL: in std_logic;
		OP_A: in std_logic_vector(31 downto 0);
		OP_B: in std_logic_vector(31 downto 0);
		LExp: out std_logic_vector(7 downto 0);
		SExp: out std_logic_vector(7 downto 0);
		LMan: out std_logic_vector(22 downto 0);
		SMan: out std_logic_vector(22 downto 0);
		LSign: out std_logic;
		SSign: out std_logic;
		RunO: out std_logic
	); 
end component;

component ComputeShift is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		LExp: in std_logic_vector(7 downto 0);
		SExp: in std_logic_vector(7 downto 0);
		LMan: in std_logic_vector(22 downto 0);
		SMan: in std_logic_vector(22 downto 0);
		LSign: in std_logic;
		SSign: in std_logic;
		LExpP: out std_logic_vector(7 downto 0);
		SExpP: out std_logic_vector(7 downto 0);
		LManP: out std_logic_vector(22 downto 0);
		SManP: out std_logic_vector(22 downto 0);
		LSignP: out std_logic;
		SSignP: out std_logic;
		shiftdistance: out std_logic_vector(4 downto 0);
		RunO: out std_logic
	);
end component;

component ShiftMan is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		shiftdistance: in std_logic_vector(4 downto 0);
		LExp: in std_logic_vector(7 downto 0);
		SExp: in std_logic_vector(7 downto 0);
		LMan: in std_logic_vector(22 downto 0);
		SMan: in std_logic_vector(22 downto 0);
		LSign: in std_logic;
		SSign: in std_logic;
		LExpP: out std_logic_vector(7 downto 0);
		LManP: out std_logic_vector(24 downto 0);
		SManP: out std_logic_vector(24 downto 0);
		LSignP: out std_logic;
		SSignP: out std_logic;
		RunO: out std_logic
	);
end component;

component CompareMan is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		LSign: in std_logic;
		LExp: in std_logic_vector(7 downto 0);
		LMan: in std_logic_vector(24 downto 0);
		SSign: in std_logic;
		SMan: in std_logic_vector(24 downto 0);
		Exp: out std_logic_vector(7 downto 0);
		LMan1: out std_logic_vector(24 downto 0);
		SMan1: out std_logic_vector(24 downto 0);
		Sign: out std_logic;
		AddSub: out std_logic;
		RunO: out std_logic
	);
end component;

component AddSubMan is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		Sign: in std_logic;
		AddSub: in std_logic;
		Exp: in std_logic_vector(7 downto 0);
		LMan: in std_logic_vector(24 downto 0);
		SMan: in std_logic_vector(24 downto 0);
		UExp: out std_logic_vector(8 downto 0);
		UMan: out std_logic_vector(25 downto 0);
		RunO: out std_logic
	);
end component;

component Norm1 is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		UMan: in std_logic_vector(25 downto 0);
		UExp: in std_logic_vector(8 downto 0);
		ExpCor: out std_logic_vector(7 downto 0);
		ShftDst: out std_logic_vector(4 downto 0);
		OMan: out std_logic_vector(25 downto 0);
		OExp: out std_logic_vector(8 downto 0);
		RunO: out std_logic
	);
end component;

component Norm2 is
	port(
		clk: in std_logic;
		rst: in std_logic;
		run: in std_logic;
		ExpCor: in std_logic_vector(7 downto 0);
		ShftDst: in std_logic_vector(4 downto 0);
		UExp: in std_logic_vector(8 downto 0);
		UMan: in std_logic_vector(25 downto 0);
		Q: out std_logic_vector(31 downto 0);
		RunO: out std_logic
	);
end component;

COMPONENT reg_a is

port ( 
	clk: in std_logic;
	rst: in std_logic;
	run: in std_logic;
	Sign: in std_logic;
	AddSub: in std_logic;
	Exp: in std_logic_vector(7 downto 0);
	LMan: in std_logic_vector(24 downto 0);
	SMan: in std_logic_vector(24 downto 0);
	RUN_O:OUT STD_LOGIC;
	SIGN_O:OUT STD_LOGIC;
	ADDSUB_O:OUT STD_LOGIC;
	SMAN_O:OUT STD_LOGIC_VECTOR(24 DOWNTO 0);
	LMAN_O:OUT STD_LOGIC_VECTOR(24 DOWNTO 0);
	EXP_O:OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	
 );

end component reg_a;




signal SLSign, SSSign, R1, SLSignP, SSSignP, R2, SLSignPP, SSSignPP, R3, SSign, SAddSub, R4, R5, R6, R7,R8: std_logic := '0';
signal SLExp, SSExp, SLExpP, SSExpP, SLExpPP, SExp, SExpCor : std_logic_vector (7 downto 0) := (others => '0');
signal SLMan, SSMan, SLManP, SSManP : std_logic_vector (22 downto 0) := (others => '0');
signal Sshiftdistance, SShftDst: std_logic_vector (4 downto 0) := (others => '0');
signal SLManPP, SSManPP, SLMan1, SSMan1 : std_logic_vector (24 downto 0) := (others => '0');
signal SUExp, SOExp: std_logic_vector (8 downto 0) := (others => '0');
signal SUMan, SOMan: std_logic_vector (25 downto 0) := (others => '0');
signal SQ: std_logic_vector (31 downto 0) := (others => '0');
SIGNAL SIGN_OS, ADDSUB_OS: STD_LOGIC:='0';
SIGNAL SMAN_OS: STD_LOGIC_VECTOR(24 DOWNTO 0):= (others => '0');
SIGNAL LMAN_OS: STD_LOGIC_VECTOR(24 DOWNTO 0):= (others => '0');
SIGNAL EXP_OS: STD_LOGIC_VECTOR(7 DOWNTO 0):= (others => '0');

begin

Inst1_CompareExp: CompareExp port map (clk, rst, EnR, EnL, OP_A, OP_B, SLExp, SSExp, SLMan, SSMan, SLSign, SSSign, R1);

Inst2_ComputeShift: ComputeShift port map (clk, rst, R1,SLExp, SSExp, SLMan, SSMan, SLSign, SSSign, SLExpP, SSExpP, SLManP, SSManP, SLSignP, SSSignP, Sshiftdistance, R2);

Inst3_ShiftMan: ShiftMan port map (clk, rst, R2, Sshiftdistance, SLExpP, SSExpP, SLManP, SSManP, SLSignP, SSSignP, SLExpPP, SLManPP, SSManPP, SLSignPP, SSSignPP, R3);

Inst4_CompareMan: CompareMan port map (clk, rst, R3, SLSignPP, SLExpPP, SLManPP, SSSignPP, SSManPP, SExp, SLMan1, SSMan1, SSign, SAddSub, R4);

Inst5_reg_a: reg_a port map (clk, rst, R4, SSign, SAddSub, SExp, SLMan1, SSMan1, r5, SIGN_OS, ADDSUB_OS,SMAN_OS,LMAN_OS,EXP_OS);

Inst6_AddSubMan: AddSubMan port map (clk, rst, R5, SIGN_OS, ADDSUB_OS, EXP_OS, LMAN_OS, SMAN_OS, SUExp, SUMan, R6);

Inst7_Norm1: Norm1 port map (clk, rst, R6, SUMan, SUExp, SExpCor, SShftDst, SOMan, SOExp, R7);

Inst8_Norm2: Norm2 port map (clk, rst, R7, SExpCor, SShftDst, SOExp, SOMan, SQ, R8);

OP_Q <= SQ;
DONE <= R7;

end arch_FPA;


