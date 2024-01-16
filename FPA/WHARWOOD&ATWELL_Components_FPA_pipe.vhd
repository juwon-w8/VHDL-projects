------------------------------------------------------------------
--Floating Point Adder Components
------------------------------------------------------------------
--Components:
--Shift Mantissa
--ComputeShift
--Compare Exponent
--Compare Mantissa
--AddSub Mantissa
--Norm1
--Norm2
------------------------------------------------------------------
--Inputs: clk, rst, EnL, EnR, OP_A, OP_B
------------------------------------------------------------------
--Outputs: Q, RunO
------------------------------------------------------------------
-- Juwon Wharwood Marvin Atwell
-- Floating Point Adder
-- Computer Architecture
------------------------------------------------------------------

------------------------------------------------------------------
--Shift Mantissa
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.">";
use ieee.std_logic_unsigned.SHR;
use ieee.std_logic_unsigned.CONV_INTEGER;
use ieee.std_logic_misc.OR_REDUCE;
use ieee.std_logic_arith.all;

entity ShiftMan is
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
end ShiftMan;

architecture rtl of ShiftMan is
begin 

	process(clk,rst)
		variable manA,manB: std_logic_vector(24 downto 0);
		variable bitA,bitB: std_logic;
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				LExpP <= (others=> '0');
				LManP <= (others=> '0');
				SManP <= (others=> '0');
				LSignP <= '0';
				SSignP <= '0';
				RunO <= '0';
			else
				RunO <= run;
				if (run = '1') then
					bitA:=LSign OR OR_REDUCE(LMan) OR OR_REDUCE(Lexp);
					manA:=bitA & LMan(22 downto 0) & '0';
					bitB:=SSign OR OR_REDUCE(Sman) OR OR_REDUCE(Sexp);
					manB:=bitB & SMan(22 downto 0) & '0';
					SManP <= SHR(manB,shiftdistance);
					LExpP <= LExp;
					LManP <= manA;
					LSignP <= LSign;
					SSignP <= SSign;
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Compute Shift
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned.">";
use ieee.std_logic_unsigned.SHR;
use ieee.std_logic_unsigned.CONV_INTEGER;
use ieee.std_logic_misc.OR_REDUCE;
use ieee.std_logic_arith.all;

entity ComputeShift is
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
end ComputeShift;

architecture rtl of ComputeShift is
begin
	process(clk,rst)
		variable sdistance: std_logic_vector(7 downto 0);
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				LExpP <= (others=> '0');
				SExpP <= (others=> '0');
				LManP <= (others=> '0');
				SManP <= (others=> '0');
				LSignP <= '0';
				SSignP <= '0';
				shiftdistance <= (others=> '0');
				RunO <= '0';
			else
				RunO <= Run;
				if (Run = '1') then
					sdistance := LExp - SExp;
					LExpP <= LExp;
					SExpP <= SExp;
					LManP <= LMan;
					SManP <= SMan;
					LSignP <= LSign;
					SSignP <= SSign;
					shiftdistance <= sdistance(4 downto 0);
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Compare Exponent
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity CompareExp is
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
end CompareExp;

architecture rtl of CompareExp is
begin
	process(clk,rst)
		variable expA,expB: std_logic_vector(8 downto 0);
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				LExp <= (others=> '0');
				SExp <= (others=> '0');
				LMan <= (others=> '0');
				SMan <= (others=> '0');
				LSign <= '0';
				SSign <= '0';
				RunO <= '0';
			else
				RunO <= EnR and EnL;
				if (EnR = '1' and EnL = '1') then
					expA:= '0' & OP_A(30 downto 23);
					expB:= '0' & OP_B(30 downto 23);
					if (expA > expB) then
						SSign <= OP_B(31);
						SExp <= OP_B(30 downto 23);
						SMan <= OP_B(22 downto 0);
						LSign <= OP_A(31);
						LExp <= OP_A(30 downto 23);
						LMan <= OP_A(22 downto 0);
					else
						SSign <= OP_A(31);
						SExp <= OP_A(30 downto 23);
						SMan <= OP_A(22 downto 0);
						LSign <= OP_B(31);
						LExp <= OP_B(30 downto 23);
						LMan <= OP_B(22 downto 0);
					end if;
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Compare Mantissa
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned.SHL;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity CompareMan is
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
end CompareMan;

architecture rtl of CompareMan is
begin
	process(clk,rst)
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				Exp <= (others=> '0');
				LMan1 <= (others=> '0');
				SMan1 <= (others=> '0');
				Sign <= '0';
				AddSub <= '0';
				RunO <= '0';
			else
				RunO <= run;
				if (Run = '1') then
					if (LSign = SSign) then
						Sign <= LSign;
						LMan1 <= LMan;
						SMan1 <= Sman;
						AddSub <= '0';
					else
						if (Lman > SMan) then
							Sign <= LSign;
							AddSub <= '1';
							LMan1 <= LMan;
							SMan1 <= SMan;
						else
							Sign <= SSign;
							AddSub <= '1';
							LMan1 <= SMan;
							SMan1 <= LMan;
						end if;
					end if;
					Exp <= LExp;
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Add/Sub Mantissa
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned.">";
use ieee.std_logic_unsigned.SHL;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity AddSubMan is
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
end AddSubMan;

architecture rtl of AddSubMan is
begin
	process (clk,rst)
		variable NewMan: std_logic_vector(25 downto 0);
		variable manA,manB:std_logic_vector(25 downto 0);
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				UExp <= (others=> '0');
				UMan <= (others=> '0');
				RunO <= '0';
			else
				RunO <= run;
				if (Run = '1') then
					manA := '0' & LMan;
					manB := '0' & SMan;
					if (AddSub = '0') then
						NewMan := manA+manB;
					else
						NewMan := manA-manB;
					end if;
					UExp(7 downto 0) <= Exp;
					UMan <= NewMan;
					UExp(8) <= Sign;
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Norm 1
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned.">";
use ieee.std_logic_unsigned.SHL;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity Norm1 is
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
end Norm1;

architecture rtl of Norm1 is
begin
	process (clk,rst)
		variable ExpCorrect: std_logic_vector(7 downto 0);
		variable ShiftDistance: std_logic_vector(4 downto 0);
	begin
		if (clk='1' and clk'event)then
			if (rst = '1') then
				ExpCor <= (others=> '0');
				ShftDst <= (others=> '0');
				OMan <= (others=> '0');
				OExp <= (others=> '0');
				RunO <= '0';
			else
				RunO <= run;
				if (Run = '1') then
					OMan <= UMan;
					if (UMan(25)='1')then
						ExpCorrect := "00000001";
						ShiftDistance := "00000";
						OExp <= UExp;
					elsif (UMan(24)='1')then
						ExpCorrect := "00000000";
						ShiftDistance := "00001";
						OExp <= UExp;
					elsif (UMan(23)='1')then
						ExpCorrect := "11111111";
						ShiftDistance := "00010";
						OExp <= UExp;
					elsif (UMan(22)='1')then
						ExpCorrect := "11111110";
						ShiftDistance := "00011";
						OExp <= UExp;
					elsif (UMan(21)='1')then
						ExpCorrect := "11111101";
						ShiftDistance := "00100";
						OExp <= UExp;
					elsif (UMan(20)='1')then
						ExpCorrect := "11111100";
						ShiftDistance := "00101";
						OExp <= UExp;
					elsif (UMan(19)='1')then
						ExpCorrect := "11111011";
						ShiftDistance := "00110";
						OExp <= UExp;
					elsif (UMan(18)='1')then
						ExpCorrect := "11111010";
						ShiftDistance := "00111";
						OExp <= UExp;
					elsif (UMan(17)='1')then
						ExpCorrect := "11111001";
						ShiftDistance := "01000";
						OExp <= UExp;
					elsif (UMan(16)='1')then
						ExpCorrect := "11111000";
						ShiftDistance := "01001";
						OExp <= UExp;
					elsif (UMan(15)='1')then
						ExpCorrect := "11110111";
						ShiftDistance := "01010";
						OExp <= UExp;
					elsif (UMan(14)='1')then
						ExpCorrect := "11110110";
						ShiftDistance := "01011";
						OExp <= UExp;
					elsif (UMan(13)='1')then
						ExpCorrect := "11110101";
						ShiftDistance := "01100";
						OExp <= UExp;
					elsif (UMan(12)='1')then
						ExpCorrect := "11110100";
						ShiftDistance := "01101";
						OExp <= UExp;
					elsif (UMan(11)='1')then
						ExpCorrect := "11110011";
						ShiftDistance := "01110";
						OExp <= UExp;
					elsif (UMan(10)='1')then
						ExpCorrect := "11110010";
						ShiftDistance := "01111";
						OExp <= UExp;
					elsif (UMan(9)='1')then
						ExpCorrect := "11110001";
						ShiftDistance := "10000";
						OExp <= UExp;
					elsif (UMan(8)='1')then
						ExpCorrect := "11110000";
						ShiftDistance := "10001";
						OExp <= UExp;
					elsif (UMan(7)='1')then
						ExpCorrect := "11101111";
						ShiftDistance := "10010";
						OExp <= UExp;
					elsif (UMan(6)='1')then
						ExpCorrect := "11101110";
						ShiftDistance := "10011";
						OExp <= UExp;
					elsif (UMan(5)='1')then
						ExpCorrect := "11101101";
						ShiftDistance := "10100";
						OExp <= UExp;
					elsif (UMan(4)='1')then
						ExpCorrect := "11101100";
						ShiftDistance := "10101";
						OExp <= UExp;
					elsif (UMan(3)='1')then
						ExpCorrect := "11101011";
						ShiftDistance := "10110";
						OExp <= UExp;
					elsif (UMan(2)='1')then
						ExpCorrect := "11101010";
						ShiftDistance := "10111";
						OExp <= UExp;
					elsif (UMan(1)='1')then
						ExpCorrect := "11101001";
						ShiftDistance := "11000";
						OExp <= UExp;
					else
						ExpCorrect := "00000000";
						ShiftDistance := "00000";
						OExp <= UExp;
					end if;
					ExpCor <= ExpCorrect;
					ShftDst <= ShiftDistance;
				end if;
			end if;
		end if;
	end process;
end rtl;

------------------------------------------------------------------
--Norm 2
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned."-";
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned.">";
use ieee.std_logic_unsigned.SHL;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity Norm2 is
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
end Norm2;

architecture rtl of Norm2 is
signal QQ: std_logic_vector(31 downto 0);
begin
	process (clk,rst)
		variable exp: std_logic_vector(7 downto 0);
		variable ManOut, ManA: std_logic_vector(25 downto 0);
		variable RoundMan: std_logic_vector(25 downto 0);
	begin
		if (clk='1' and clk'event) then
			if (rst = '1') then
				Q <= (others=> '0');
				RunO <= '0';
			else
				RunO <= run;
				if (Run = '1') then
					exp := UExp(7 downto 0);
					ManA := UMan;
					exp := exp + ExpCor;
					ManOut := SHL(ManA,ShftDst);
					RoundMan := '0' & ManOut(24 downto 0);
					if ((RoundMan(1)='1') and (RoundMan(2)='1')) then
						RoundMan := RoundMan + "00000000000000000000000010";
					end if;
					if (RoundMan(25)='1') then
						exp := exp + 1;
					end if;
					QQ(31) <= UExp(8);
					QQ(30 downto 23) <= exp;
					QQ(22 downto 0) <= RoundMan(24 downto 2);
				end if;
			end if;
		Q <= QQ;
		end if;
	end process;
end rtl;


----------------------------------------------
--Register
----------------------------------------------
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned."+";
use IEEE.std_logic_unsigned."-";
use IEEE.std_logic_unsigned.">";
use IEEE.std_logic_unsigned.SHL;
use IEEE.std_logic_arith.CONV_STD_LOGIC_VECTOR;
use IEEE.numeric_std.all;
entity reg_a is

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

end reg_a;

architecture sim of reg_a is

 begin

process(clk) is

   begin

 if rising_edge(clk) then

if(RUN='1') then 
RUN_O<=RUN; 
SIGN_O<=SIGN;
ADDSUB_O<=ADDSUB;
SMAN_O<=SMAN;
LMAN_O<=LMAN;
EXP_O<=EXP;


  elsif(rst='1') then
	RUN_O<='X';
	SIGN_O<='X';
 	ADDSUB_O<='X';
	SMAN_O<="XXXXXXXXXXXXXXXXXXXXXXXXX";
	LMAN_O<="XXXXXXXXXXXXXXXXXXXXXXXXX";
	EXP_O<="XXXXXXXX";          

end if;

      end if;

        end process;

end sim; 


