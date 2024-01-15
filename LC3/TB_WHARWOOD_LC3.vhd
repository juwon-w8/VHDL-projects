------------------------------------------------------------
--File Name:		LC3_data_path_all_tb_Wharwood.vhd
--VHDL Source File:	A very simple test bench
-- 				
--Components: 		see lc3_parts_all_Wharwood.vhd
-- 			     requires lc3_datapath_all_amoo
--Comments: 		behavioral testbench description
--Juwon Wharwood
--ADvanced Digital Design
--Fall 2021
-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.all;

entity DATAPATH_ALL_TB is
end DATAPATH_ALL_TB;


architecture WHARWOOD_LC3_TB of DATAPATH_ALL_TB is

component WHARWOOD_LC3 is
port (
	CLK: in std_logic;  
	Reset: in std_logic
     );
end component WHARWOOD_LC3;

signal	CLKtb		: std_logic; 				
signal	RSTntb	: std_logic;				

begin

CLK_GEN: process 
begin 
while now <= 10000 ns loop 
CLKtb <='0'; wait for 5 ns; CLKtb <='1'; wait for 5 ns; 
end loop; 
wait; 
end process; 

Reset1: process
begin
RSTntb  <='1','0' after 8 ns;
wait;
end process;


--------------------------------------do not change-----------------------------------------------
datap: WHARWOOD_LC3 port map ( CLK=>CLKtb, reset=>RSTntb);

end WHARWOOD_LC3_TB;
--------------------------------------change the names to match your TB/Component-----
configuration CFG_DATAPATH_ALL_TB of DATAPATH_ALL_TB is
	for WHARWOOD_LC3_TB
	end for;
end CFG_DATAPATH_ALL_TB;