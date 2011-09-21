----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:54:06 09/14/2011 
-- Design Name: 
-- Module Name:    led_sw - Behavioral 
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

entity led_sw is
    Port ( sw : in  STD_LOGIC_VECTOR (7 downto 0);
           led : out  STD_LOGIC_VECTOR (7 downto 0));
end led_sw;

architecture Behavioral of led_sw is
-- just show some led combinations depending in the switches.
-- nothing special. first supid test :D
begin
	led <=   "00000001" when sw="00000001" else
				"00000011" when sw="00000010" else
				"00000111" when sw="00000100" else
				"00001111" when sw="00001000" else
				"11111111";
end Behavioral;

