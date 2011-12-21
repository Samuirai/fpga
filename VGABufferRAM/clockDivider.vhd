----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:28:25 09/20/2011 
-- Design Name: 
-- Module Name:    clockDivider2 - Behavioral 
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

entity clockDivider is
		PORT (clk_in  : in STD_ULOGIC;
				clk_out : out STD_ULOGIC;
				divide_by : in integer range 0 to 10000000);
end clockDivider;

architecture Behavioral of clockDivider is
	signal COUNT1 : integer range 0 to 10000000;
begin
	-- counts up to by/2 and toggles the clk_out.
	-- this process divides the clock through the given integer "by"
	process (clk_in) is
	begin
		if (clk_in'event and clk_in = '1') then
			COUNT1 <= COUNT1+1;
			if(COUNT1 < divide_by/2) then
				clk_out <= '0';
			elsif(COUNT1>= divide_by/2) then
				clk_out <= '1';
			end if;
			if(COUNT1 >= divide_by) then
				COUNT1 <= 0;
			end if;
		end if;
	end process;

end Behavioral;