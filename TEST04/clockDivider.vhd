----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:04:20 09/20/2011 
-- Design Name: 
-- Module Name:    clockDivider - Behavioral 
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

entity clockDivider10k is
		PORT (clk_in  : in STD_LOGIC;
				clk_out : out STD_LOGIC);
end clockDivider10k;


architecture Behavioral of clockDivider10k is
	signal COUNT1 : integer range 0 to 10000;
begin
	process 
	begin
		if (clk_in'event and clk_in = '1') then
			COUNT1 <= COUNT1+1;
			if(COUNT1 < 5000) then
				clk_out <= '0';
			elsif(COUNT1>=5000) then
				clk_out <= '1';
			end if;
			if(COUNT1 >= 10000) then
				COUNT1 <= 0;
			end if;
		end if;
	end process;

end Behavioral;

