----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:23:21 09/20/2011 
-- Design Name: 
-- Module Name:    sevenSegment - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity sevenSegment is
	PORT (
		in1 : in  STD_LOGIC_VECTOR (3 downto 0);
		in2 : in  STD_LOGIC_VECTOR (3 downto 0);
		in3 : in  STD_LOGIC_VECTOR (3 downto 0);
		in4 : in  STD_LOGIC_VECTOR (3 downto 0);
		out1: out STD_LOGIC_VECTOR (0 to 7);
		out2: out STD_LOGIC_VECTOR (3 downto 0);
		Clock : in STD_LOGIC
	);
end sevenSegment;

architecture Behavioral of sevenSegment is
	signal COUNT1 : integer range 0 to 3;
begin
	-- process counts up from 0-3 to multiplex the digets. Depends on the given Clock.
	process 
	begin
		if (Clock'event and Clock = '1') then	
		
			if COUNT1 = 0 then
				 out2 <= "0111";
				 case  in1 is				  --hgfedcba
						when "0000"=> out1 <="11000000";  -- '0'
						when "0001"=> out1 <="11111001";  -- '1'
						when "0010"=> out1 <="10100100";  -- '2'
						when "0011"=> out1 <="10110000";  -- '3'
						when "0100"=> out1 <="10011001";  -- '4' 
						when "0101"=> out1 <="10010010";  -- '5'
						when "0110"=> out1 <="10000010";  -- '6'
						when "0111"=> out1 <="11111000";  -- '7'
						when "1000"=> out1 <="10000000";  -- '8'
						when "1001"=> out1 <="10010000";  -- '9'
						 --nothing is displayed when a number more than 9 is given as input. 
						when others=> out1 <="11111110"; 
				 end case;
			end if;
			
			if COUNT1 = 1 then
				 out2 <= "1011";
				 case  in2 is
						when "0000"=> out1 <="11000000";  -- '0'
						when "0001"=> out1 <="11111001";  -- '1'
						when "0010"=> out1 <="10100100";  -- '2'
						when "0011"=> out1 <="10110000";  -- '3'
						when "0100"=> out1 <="10011001";  -- '4' 
						when "0101"=> out1 <="10010010";  -- '5'
						when "0110"=> out1 <="10000010";  -- '6'
						when "0111"=> out1 <="11111000";  -- '7'
						when "1000"=> out1 <="10000000";  -- '8'
						when "1001"=> out1 <="10010000";  -- '9'
						 --nothing is displayed when a number more than 9 is given as input. 
						when others=> out1 <="01111111"; 
				end case;
			end if;
			
			if COUNT1 = 2 then
				 out2 <= "1101";
				 case  in3 is
						when "0000"=> out1 <="11000000";  -- '0'
						when "0001"=> out1 <="11111001";  -- '1'
						when "0010"=> out1 <="10100100";  -- '2'
						when "0011"=> out1 <="10110000";  -- '3'
						when "0100"=> out1 <="10011001";  -- '4' 
						when "0101"=> out1 <="10010010";  -- '5'
						when "0110"=> out1 <="10000010";  -- '6'
						when "0111"=> out1 <="11111000";  -- '7'
						when "1000"=> out1 <="10000000";  -- '8'
						when "1001"=> out1 <="10010000";  -- '9'
						 --nothing is displayed when a number more than 9 is given as input. 
						when others=> out1 <="01111111"; 
					end case;
			end if;
			
			if COUNT1 = 3 then
				 out2 <= "1110";
				 case  in4 is
						when "0000"=> out1 <="11000000";  -- '0'
						when "0001"=> out1 <="11111001";  -- '1'
						when "0010"=> out1 <="10100100";  -- '2'
						when "0011"=> out1 <="10110000";  -- '3'
						when "0100"=> out1 <="10011001";  -- '4' 
						when "0101"=> out1 <="10010010";  -- '5'
						when "0110"=> out1 <="10000010";  -- '6'
						when "0111"=> out1 <="11111000";  -- '7'
						when "1000"=> out1 <="10000000";  -- '8'
						when "1001"=> out1 <="10010000";  -- '9'
						 --nothing is displayed when a number more than 9 is given as input. 
						when others=> out1 <="01111111"; 
					end case;
			end if;
			
			-- counts from 0 to 3 and resets to 0. to multiplex the 4 displays.
			COUNT1 <= COUNT1+1;
			if(COUNT1 > 3) then
				COUNT1 <= 0;
			end if;
			
			
			
		end if;
	end process;

end Behavioral;

