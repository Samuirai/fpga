----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:41:42 09/23/2011 
-- Design Name: 
-- Module Name:    vga_controller - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
	PORT (
		clk_in  : in STD_LOGIC
	);
end vga_controller;

architecture Behavioral of vga_controller is
--component clockDivider
--		PORT (clk_in  : in STD_LOGIC;
--				clk_out : out STD_LOGIC;
--				by : in integer range 0 to 100_000_000);
--end component;
signal clk2 : STD_LOGIC;
begin
	--clockDivide: clockDivider port map (clk_in,clk2,1000);
	process 
		variable COUNT integer range 0 to 100_000_000
	begin
		if (clk_in'event and clk_in = '1') then
			COUNT := COUNT+1;
			if COUNT
		end if;
	end process;
end Behavioral;

