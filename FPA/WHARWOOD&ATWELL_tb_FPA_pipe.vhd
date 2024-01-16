

-- Juwon Wharwood , Marvin Atwell
-- Description: Test Bench Floating Point Adder
--------------------------------------------------------------


LIBRARY IEEE;
USE work.CLOCKS.all;   -- Entity that uses CLOCKS
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
USE std.textio.all;
USE work.txt_util.all;

ENTITY tb_FPA IS
END;

ARCHITECTURE TESTBENCH OF tb_FPA IS
---------------------------------------------------------------
-- COMPONENTS
---------------------------------------------------------------

component FPA is  
	port (
		clk, rst, EnR,EnL: in std_logic;
		OP_A, OP_B: in std_logic_vector (31 downto 0);
		OP_Q: out std_logic_vector (31 downto 0)
); 
end component;

COMPONENT CLOCK
	port(CLK: out std_logic);
END COMPONENT;

---------------------------------------------------------------
-- Read/Write FILES
---------------------------------------------------------------


FILE in_file : TEXT open read_mode is 	"WHARWOOD&ATWELL_FPA_INPUT.txt";   -- Inputs, reset
FILE exo_file : TEXT open read_mode is 	"WHARWOOD&ATWELL_FPA_EXP_OUTPUT.txt";   -- Expected output (binary) 
FILE out_file : TEXT open  write_mode is  "FPA_dataout_dacus.txt";
FILE xout_file : TEXT open  write_mode is "FPA_TestOut_dacus.txt";
FILE hex_out_file : TEXT open  write_mode is "FPA_hex_out_dacus.txt";

---------------------------------------------------------------
-- SIGNALS 
---------------------------------------------------------------
  SIGNAL CLK: STD_LOGIC;
  SIGNAL RST: STD_LOGIC;
  SIGNAL EnR: STD_LOGIC;
  SIGNAL EnL: STD_LOGIC;
  SIGNAL OP_A: STD_LOGIC_VECTOR(31 downto 0):=(others=> 'X');
  SIGNAL OP_B: STD_LOGIC_VECTOR(31 downto 0):=(others=> 'X');
  SIGNAL OP_Q : STD_LOGIC_VECTOR(31 downto 0):= (others => 'X');
  SIGNAL Exp_Op_Q : STD_LOGIC_VECTOR(31 downto 0):= (others => 'X');
  SIGNAL Test_Out_Q : STD_LOGIC:= 'X';
  SIGNAL LineNumber: integer:=0;

---------------------------------------------------------------
-- BEGIN 
---------------------------------------------------------------

BEGIN

---------------------------------------------------------------
-- Instantiate Components 
---------------------------------------------------------------


U0: CLOCK port map (CLK);
InstFPA: FPA port map (clk,rst,EnR,EnL, OP_A,OP_B, OP_Q);


---------------------------------------------------------------
-- PROCESS 
---------------------------------------------------------------
PROCESS

variable in_line, exo_line, out_line, xout_line : LINE;
variable comment, xcomment : string(1 to 128);
variable i : integer range 1 to 128;
variable simcomplete : boolean;



variable vrst : std_logic := 'X';
variable vEnR : std_logic := 'X';
variable vEnL : std_logic := 'X';
variable vOP_A: std_logic_vector (31 downto 0) := (others => '0');
variable vOP_B: std_logic_vector (31 downto 0) := (others => '0');
variable vOP_Q  : std_logic_vector(31 downto 0):= (OTHERS => 'X');
variable vExp_Op_Q : std_logic_vector(31 downto 0):= (others => 'X');
variable vTest_Out_Q : std_logic := 'X';


variable vlinenumber: integer;

BEGIN

simcomplete := false;

while (not simcomplete) LOOP
  
	if (not endfile(in_file) ) then
		readline(in_file, in_line);
	else
		simcomplete := true;
	end if;

	if (not endfile(exo_file) ) then
		readline(exo_file, exo_line);
	else
		simcomplete := true;
	end if;
	
	if (in_line(1) = '-') then  --Skip comments
		next;
	elsif (in_line(1) = '.')  then  --exit Loop
	  Test_Out_Q <= 'Z';
		simcomplete := true;
	elsif (in_line(1) = '#') then        --Echo comments to out.txt
	  i := 1;
	  while in_line(i) /= '.' LOOP
		comment(i) := in_line(i);
		i := i + 1;
	  end LOOP;

	elsif (exo_line(1) = '-') then  --Skip comments
		next;
	elsif (exo_line(1) = '.')  then  --exit Loop
	  	  Test_Out_Q  <= 'Z';
		   simcomplete := true;
	elsif (exo_line(1) = '#') then        --Echo comments to out.txt
	     i := 1;
	   while exo_line(i) /= '.' LOOP
		 xcomment(i) := exo_line(i);
		 i := i + 1;
	   end LOOP;

	
	  write(out_line, comment);
	  writeline(out_file, out_line);
	  
	  write(xout_line, xcomment);
	  writeline(xout_file, xout_line);

	  
	ELSE      --Begin processing


		read(in_line, vrst );
		rst  <= vrst;

		read(in_line, vEnR );
		EnR  <= vEnR;

		read(in_line, vEnL );
		EnL  <= vEnL;

 		read(in_line, vOP_A );
		OP_A  <= vOP_A;

		read(in_line, vOP_B );
		OP_B  <= vOP_B;
	
		read(exo_line, vExp_Op_Q );
		Exp_Op_Q  <= vExp_Op_Q;

		
    vlinenumber :=LineNumber;

    write(out_line,vlinenumber);
    write(out_line, STRING'("."));
    write(out_line, STRING'("    "));



    CYCLE(1,CLK);
   
      
    if (Exp_OP_Q = OP_Q) then
      Test_Out_Q <= '0';
    else
      Test_Out_Q <= 'X';
    end if;

          		
		write(out_line, vOP_Q, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab

		write(out_line,vTest_Out_Q, left, 5);                           --ht is ascii for horizontal tab
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		write(out_line, vexp_OP_Q, left, 32);
		write(out_line, STRING'("       "));                           --ht is ascii for horizontal tab
		writeline(out_file, out_line);
		print(xout_file,    str(LineNumber)& "." & "    " &    str(OP_Q) & "       " &   str(Exp_OP_Q)  & "     " & str(Test_Out_Q));
	
	END IF;
	LineNumber<= LineNumber+1;

	END LOOP;
	WAIT;
	
	END PROCESS;

END TESTBENCH;


CONFIGURATION cfg_tb_FPA_pipe OF tb_FPA IS
	FOR TESTBENCH
		FOR InstFPA: FPA
			use entity work.FPA(arch_FPA);
		END FOR;
	END FOR;
END;


