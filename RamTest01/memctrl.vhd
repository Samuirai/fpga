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
			DataIn : in STD_ULOGIC_VECTOR (15 downto 0);
			DataOut : out STD_ULOGIC_VECTOR (15 downto 0);
			AdrIn : in STD_ULOGIC_VECTOR (1 to 23);
			WriteRequest: in STD_ULOGIC := '0';
			ReadRequest: in STD_ULOGIC := '0';
			busy: out STD_ULOGIC := '0';
			OKIN: in STD_ULOGIC := '0';
			OKOUT: out STD_ULOGIC := '0'
			--led: out STD_ULOGIC_VECTOR := "00000000"
		);
end memctrl;

architecture Behavioral of memctrl is
		signal STATE : STATE_MACHINE := INIT;
		signal idle : integer := 10;
		signal AdrLatch : STD_ULOGIC_VECTOR (23 downto 1);
		signal DataLatch : STD_ULOGIC_VECTOR (15 downto 0);
begin

	process (clk) is
		variable OK: integer;
	begin
		--led <= WriteRequest & ReadRequest & "0" & clk & "0000";
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
				idle <= 2; -- safe
				OKOUT <= '0';
				OK := 0;
				if idle > 0 then
					idle <= idle - 1;
				elsif (idle = 0 and	WriteRequest = '1') then
					DataLatch <= DataIn;
					AdrLatch <= AdrIn;
					STATE <= WRITE1;
				elsif (idle = 0 and	ReadRequest = '1') then
					AdrLatch <= AdrIn;
					STATE <= READ0;
				end if;
				
				
			when READ0 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= "-----------------------";
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 2; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ1;
				end if;
			
			when READ1 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= "-----------------------";
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 2; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ2;
				end if;
				
			when READ2 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= "-----------------------";
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 4; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ3;
				end if;
				
			when READ3 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 1; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ4;
				end if;
				
			when READ4 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 5; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ5;
				end if;
				
			when READ5 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 5; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ6;
				end if;
				
			when READ6 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				MemData <= "UUUUUUUUUUUUUUUU";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 5; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ7;
				end if;
				
			when READ7 =>
			
				MemAdv <= '0';
				RamCE <= '0';
				RamOE <= '0';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				DataOut <= MemData;
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 5; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= READ8;
				end if;
				
			when READ8 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				DataOut <= MemData;
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '1';
				idle <= 5; -- safe
				if idle > 0  then
					idle <= idle - 1;
				elsif idle = 0 and OK = 0 then
					OKOUT <= '1';
					OK := 1;
				elsif idle = 0 and OKIN = '1' and OK = 1 then
					OKOUT <= '0';
					OK := 0;
					STATE <= READ9;	
				end if;
				
			when READ9 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '1';
				MemWR <= '1';
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 5; -- safe
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= INIT;
				end if;
					
				
			when WRITE1 =>
			
				MemAdv <= '0';
				RamCE <= '1';
				RamOE <= '0';
				MemWR <= '0';
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 3; -- safe
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 2; -- 0ns
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= 'Z';
				busy <= '1';
					
				idle <= 2; -- 1ns
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
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
				MemAdr <= AdrLatch;
				MemData <= DataLatch;
				RamUB <= '0';
				RamLB <= '0';
				MemWait <= '0';
				busy <= '1';
					
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
				MemAdr <= AdrLatch;
				MemData <= DataLatch;
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '1';
					
				idle <= 2; -- 0ns
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
				MemAdr <= AdrLatch;
				MemData <= "ZZZZZZZZZZZZZZZZ";
				RamUB <= '1';
				RamLB <= '1';
				MemWait <= '0';
				busy <= '1';
				idle <= 2; -- 0ns
				if idle > 0 then
					idle <= idle - 1;
				else
					STATE <= FINISH;
				end if;
				
			when FINISH =>
				busy <= '0';
				STATE <= INIT;
			
			when others =>
				-- others
		end case;
		end if;
		
	end process;


end Behavioral;

