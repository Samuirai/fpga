----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:26:08 11/28/2011 
-- Design Name: 
-- Module Name:    memctrl - Behavioral 
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

entity memctrl is
	PORT( MemAdr : out STD_ULOGIC_VECTOR (23 downto 1);
			MemData : inout STD_ULOGIC_VECTOR (15 downto 0);
			RamOE: out STD_ULOGIC := '0';
			MemWR: out STD_ULOGIC := '0';
			MemAdv: out STD_ULOGIC := '0';
			MemWait: inout STD_ULOGIC := '0';
			MemClk: out STD_ULOGIC := '0';
			RamCE: out STD_ULOGIC := '0';
			RamCRE: out STD_ULOGIC := '0';
			RamUB: out STD_ULOGIC := '0';
			RamLB: out STD_ULOGIC := '0';
			clk: in STD_ULOGIC;
			DataRequest : inout STD_ULOGIC_VECTOR (15 downto 0);
			AdrRequest : in STD_ULOGIC_VECTOR (23 downto 1);
			WriteRequest: in STD_ULOGIC;
			busy: out STD_ULOGIC
		);
end memctrl;

architecture Behavioral of memctrl is
		signal STATE : STATE_MACHINE := INIT;
		signal idle : integer := 10;
begin

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
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '0';
					
				idle <= 0; -- safe
				if idle > 0 then
					idle <= idle - 1;
				elsif (idle <= 0 or WriteRequest = '1') then
					STATE <= WRITE2;
				end if;
				
			when WRITE1 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '0';
				MemWR <= '0';
				MemAdr <= "-----------------------";
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '0';
					
				idle <= 0; -- safe
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '0';
					
				idle <= 10; -- 10ns
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '0';
					
				idle <= 0; -- 0ns
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= 'Z';
				busy <= '0';
					
				idle <= 1; -- 1ns
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '0';
					
				idle <= 10; -- 10ns
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '0';
					
				idle <= 8; -- 8ns
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
				MemAdr <= AdrRequest;
				MemData <= DataRequest;
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '0';
					
				idle <= 20; -- 20ns
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
				MemAdr <= AdrRequest;
				MemData <= DataRequest;
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '0';
					
				idle <= 0; -- 0ns
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
				MemAdr <= AdrRequest;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '0';
				idle <= 0; -- 0ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= FINISH;
				end if;
				
			when FINISH =>
				busy <= '0';
			
			when others =>
				-- others
		end case;
		end if;
		
	end process;


end Behavioral;

