----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:52:31 09/24/2011 
-- Design Name: 
-- Module Name:    pixel - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pixel is
	PORT(
			signal mem : memory_array;
			signal x,y: integer range 1 to 640
		);
end pixel;

architecture Behavioral of pixel is
	signal i,j: integer range 1 to 640;
begin
	process
		begin
		for i in x to x+5 loop
			for j in y to y+5 loop
				mem(i,j) <= "11111111";
			end loop;
		end loop;
	end process;

end Behavioral;

