----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Fabian Faessler 
-- 
-- Create Date:    00:59:33 09/25/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: NEXYS3
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

entity main is
	PORT (
		MemAdr : out STD_LOGIC_VECTOR (26 downto 0);
		Data : inout STD_LOGIC_VECTOR (15 downto 0);
		sw: in STD_LOGIC_VECTOR (7 downto 0);
		led: out STD_LOGIC_VECTOR (7 downto 0);
		MemOE: out STD_LOGIC;
		MemWR: out STD_LOGIC;
		MemAdv: out STD_LOGIC;
		--MemWait: in STD_LOGIC;
		MemClk: out STD_LOGIC;
		RamCE: out STD_LOGIC;
		RamCRE: out STD_LOGIC;
		RamUB: out STD_LOGIC;
		RamLB: out STD_LOGIC;
		btns: in STD_LOGIC;
		btnu: in STD_LOGIC;
		clk: in STD_LOGIC
	);
end main;

architecture Behavioral of main is

	component clockDivider
		PORT (clk_in  : in STD_LOGIC;
				clk_out : out STD_LOGIC;
				by : in integer range 0 to 100_000_000);
	end component;
	signal clk2: STD_LOGIC;
begin

	ClockDivider25: clockDivider port map (clk,clk2,4);

	process (btns,btnu)
	begin
		if (clk2'event and clk2 = '1') then
			led <= "00000010";
			if btns = '1' then -- READ FROM RAM
				MemAdr <= "000000000000000000000000000";
				MemClk <= '0';
				MemAdv <= '0';
				RamCE  <= '0';
				MemOE  <= '0';
				MemWR  <= '1';
				RamCRE <= '0';
				RamUB  <= '0';
				RamLB  <= '0';
				led <= Data(15 downto 8);
			elsif btnu = '1' then -- WRITE TO RAM
				MemAdr <= "000000000000000000000000000";
				MemClk <= '0';
				MemAdv <= '0';
				RamCE  <= '0';
				MemOE  <= 'Z';
				MemWR  <= '0';
				RamCRE <= '0';
				RamUB  <= '0';
				RamLB  <= '0';
				Data(7 downto 0) <= "01010101";
				Data(15 downto 8) <= sw;
				led <= "11111111";
			else					-- IDLE... zZz
				MemClk <= '0';
				MemAdv <= '1';
				RamCE  <= '0';
				MemOE  <= 'Z';
				MemWR  <= '1';
				RamCRE <= '0';
				RamUB  <= 'Z';
				RamLB  <= 'Z';
				led <= sw;
			end if;
		end if;
	end process;

end Behavioral;

