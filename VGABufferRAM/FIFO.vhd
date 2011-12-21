----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:03:50 12/05/2011 
-- Design Name: 
-- Module Name:    FIFO - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
	PORT (	
		fifo_clk: in STD_ULOGIC;
		fifo_out: out STD_ULOGIC;
		fifo_empty: out STD_ULOGIC := '0';
		fifo_thx: in STD_LOGIC;
		fifo_data: in STD_ULOGIC_VECTOR (15 downto 0);
		fifo_regA: out STD_ULOGIC_VECTOR (15 downto 0) := "1010101010101010"
	);
end FIFO;

architecture Behavioral of FIFO is
	signal regA,regB,regC: STD_ULOGIC_VECTOR (15 downto 0) := "1010101010101010";
	signal regU: unsigned (15 downto 0);
	signal empty: STD_ULOGIC := '0';
	signal thx_came: STD_ULOGIC := '0';
begin
	fifo_regA <= regA;
	
	
	process (fifo_clk,fifo_thx) is
		variable count: integer := 0;
	begin
		
		if(fifo_clk'event and fifo_clk = '1') then
		
			
			fifo_out <= regA(count);
			
			count := count + 1;
			
			if(count = 16) then
				regA <= regB;
				regB <= regC;
				fifo_empty <= '1';
				count := 0;
			else
				if(fifo_thx = '1') then
					fifo_empty <= '0';
					regC <= fifo_data;
				end if;
			end if;
		end if;
		
		
	end process;

end Behavioral;

