----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:44:24 10/15/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.samuirai.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
	PORT( MemAdr : out STD_ULOGIC_VECTOR (23 downto 1);
			Data : inout STD_ULOGIC_VECTOR (15 downto 0);
			sw: in STD_ULOGIC_VECTOR (7 downto 0);
			led: out STD_ULOGIC_VECTOR (7 downto 0) := "00000000";
			RamOE: out STD_ULOGIC := '0';
			MemWR: out STD_ULOGIC := '0';
			MemAdv: out STD_ULOGIC := '0';
			MemWait: inout STD_ULOGIC := '0';
			MemClk: out STD_ULOGIC := '0';
			RamCE: out STD_ULOGIC := '0';
			RamCRE: out STD_ULOGIC := '0';
			RamUB: out STD_ULOGIC := '0';
			RamLB: out STD_ULOGIC := '0';
			clk: in STD_ULOGIC
		);
end main;

architecture Behavioral of main is
		signal STATE : STATE_MACHINE := INIT;
		signal idle : integer := 10;
		signal test : STD_ULOGIC_VECTOR (15 downto 0);
		signal test2 : STD_ULOGIC_VECTOR (23 downto 1);
begin
	--led <= leds;
	MemClk <= '0';
	RamCRE <= '0';
	test <= "0011011100010011";
	test2 <= "00000000000000000000000";
	process (clk) is
		
	begin
		if (clk'event and clk = '1') then
		case STATE is
			when INIT =>
				-- INIT
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '0';
				MemWR <= '0';
				MemAdr <= "-----------------------";
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				led <= "00000000";
					
				idle <= 100; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE2;
				end if;
				
			when WRITE1 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '0';
				MemWR <= '0';
				MemAdr <= "-----------------------";
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				led <= "00000001";
					
				idle <= 100; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE2;
				end if;
				
			when WRITE2 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '0';
				MemWR <= '1';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				led <= "00000010";
					
				idle <= 15; -- 10ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE3;
				end if;
				
			when WRITE3 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				led <= "00000011";
					
				idle <= 5; -- 0ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE4;
				end if;
				
			when WRITE4 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= 'Z';
				led <= "00000100";
					
				idle <= 5; -- 1ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE5;
				end if;
				
			when WRITE5 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				led <= "00000101";
					
				idle <= 15; -- 10ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE6;
				end if;
			
			when WRITE6 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '0';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				led <= "00000110";
					
				idle <= 10; -- 8ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE7;
				end if;
				
			when WRITE7 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '0';             
				MemAdr <= test2;
				Data <= test;
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				led <= "00000111";
					
				idle <= 25; -- 20ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE8;
				end if;
				
			when WRITE8 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '0';             
				MemAdr <= test2;
				Data <= test;
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				led <= "00001000";
					
				idle <= 5; -- 0ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= WRITE9;
				end if;
			
			when WRITE9 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '0';             
				MemAdr <= test2;
				Data <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				led <= "00001001";
					
				idle <= 100; -- 0ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ1;
				end if;
			
			when others =>
				-- others
		end case;
		end if;
		
	end process;

end Behavioral;

