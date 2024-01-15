LIBRARY IEEE;
USE work.CLOCKS.all;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_textio.all;
USE std.textio.all;
USE work.txt_util.all;
ENTITY tb_WHARWOOD_PRIO_ENCODER IS
END;

ARCHITECTURE TESTBENCH OF tb_WHARWOOD_PRIO_ENCODER IS

COMPONENT WHARWOOD_PRIO_ENCODER	
 PORT ( OP_A:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	OP_Q:OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	ACTIVE:OUT STD_LOGIC
);

END COMPONENT;


COMPONENT CLOCK
 port(  CLK:out std_logic);
END COMPONENT;

FILE in_file:TEXT open read_mode is "WHARWOOD_PRIO_ENCODER4_INPUT.txt";
FILE exo_file:TEXT open read_mode is"WHARWOOD_PRIO_ENCODER4_OUTPUT.txt";
FILE out_file:TEXT open read_mode is"WHARWOOD_PRIO_ENCODER4_dataout_dacus.txt";
FILE xout_file:TEXT open read_mode is"WHARWOOD_PRIO_ENCODER4_TestOut_dacus.txt";
FILE hex_out_file:TEXT open read_mode is"WHARWOOD_PRIO_ENCODER4_hex_out_dacus.txt";


------------------------------------------------------------------------------------------------------------------------
-------SIGNALS----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


SIGNAL OP_A:STD_LOGIC_VECTOR(3 downto 0):="XXXX";
SIGNAL CLK:STD_LOGIC;
SIGNAL OP_Q:STD_LOGIC_VECTOR(1 downto 0):="XX";
SIGNAL ACTIVE: STD_LOGIC:='X';
SIGNAL Exp_Op_Q:STD_LOGIC_VECTOR(1 downto 0):="XX";
SIGNAL Test_Out_Q:STD_LOGIC:='X';
SIGNAL LineNumber:integer:=0;


BEGIN
------------------------------------------------------------------------------------------------------------------------
-------Instantiate Components-------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
U0:CLOCK port map(CLK);
InstWHARWOOD_PRIO_ENCODER4_LAB7:WHARWOOD_PRIO_ENCODER port map (OP_A,OP_Q,ACTIVE);

------------------------------------------------------------------------------------------------------------------------
-------PROCESS----------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

PROCESS

variable in_line,exo_line,out_line,xout_line:LINE;
variable comment,xcomment:string(1 to 128);
variable i: integer range 1 to 128;
variable simcomplete:boolean;

variable vOp_A:std_logic_vector(3 downto 0):=(OTHERS=>'X');
variable vOp_Q:std_logic_vector(1 downto 0):=(OTHERS=>'X');
variable vactive:std_logic:='X';
variable vExp_Op_Q:std_logic_vector(1 downto 0):=(OTHERS=>'X');
variable vTest_Out_Q:std_logic:='0';
variable vlinenumber:integer;

BEGIN

simcomplete:=false;
while(not simcomplete)LOOP

	if (not endfile(in_file))then
		readline(in_file,in_line);
	else
		simcomplete:=true;
	end if;

	if(not endfile(exo_file))then
		readline(exo_file,exo_line);
	else
		simcomplete:=true;
	end if;
	if(in_line(1)='-')then
		next;
	elsif(in_line(1)='.')then
		Test_Out_Q<='Z';
		simcomplete:=true;
	elsif(in_line(1)='#')then
		i:=1;
	while in_line(i)/='.'LOOP
		comment(i):=in_line(i);
		i:=i+1;
	end LOOP;

	elsif(exo_line(1)='-')then
		next;
	elsif(exo_line(1)='.')then
		Test_Out_Q<='Z';
		simcomplete:=true;
	elsif(exo_line(1)='#')then
		i:=1;
	while exo_line(i)/='.'LOOP
		xcomment(i):=exo_line(i);
		i:=i+1;
	end LOOP;

  		write(out_line, comment);
		writeline(out_file, out_line);

		write(xout_line, xcomment);
		writeline(xout_file, xout_line);

	ELSE

		read(in_line,vOp_A);
		Op_A  <=vOp_A;

		read(exo_line,vexp_Op_Q);
		read(exo_line,vTest_Out_Q);

	vlinenumber:=LineNumber;

	write(out_line,vlinenumber);
	write(out_line,STRING'("."));
	write(out_line,STRING'("   "));

	CYCLE(1,CLK);

	Exp_Op_Q  <=vexp_Op_Q;

	if(Exp_Op_Q=Op_Q)then
	 Test_Out_Q<='0';
	else
	 Test_Out_Q<='X';
	end if;

		vOp_Q:=Op_Q;
		vTest_Out_Q:=Test_Out_Q;

		
	END IF;
	LineNumber<=LineNumber+1;
	END LOOP;
	WAIT;
	END PROCESS;

END TESTBENCH;

CONFIGURATION cfg_tb_WHARWOOD_PRIO_ENCODER4_LAB7 OF tb_WHARWOOD_PRIO_ENCODER IS
 FOR TESTBENCH
   FOR InstWHARWOOD_PRIO_ENCODER4_LAB7:WHARWOOD_PRIO_ENCODER
      use entity work.WHARWOOD_PRIO_ENCODER(sel_arch);
   END FOR;
 END FOR;
END;