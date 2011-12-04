----------------------------------------------------------------------------------
-- Company: 			shackspace e.V.
-- Engineer: 			Fabian Faessler (samuirai/smrrd)
-- 
-- Create Date:    	02:01:30 12/03/2011 
-- Last Big Change	16:03:00 12/04/2011
-- Module Name:    	MemoryController  
-- Target Devices: 	NEXYS3 // Spartan-6
-- Tool versions:  	ISE 13.2
-- Description: 		This is a MemoryController which interacts wit the CellularRam on my NEXYS3 FPGA Board.
-- Revision: 			1.0 first working Version
-- Additional Comments: 
--		The MemoryController latches the adr and data internally when you want to read or write
--		You need to implement _finish and _thx in your module, when you want to use this, which are kind of a bus protocol.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.samuirai.ALL; -- atm not used

entity MemoryController is
PORT( 
	-- map them to the CellularRam Ports --------
	memcntrl_ram_adr : out STD_ULOGIC_VECTOR (24 downto 1);
	memcntrl_ram_data : inout STD_ULOGIC_VECTOR (15 downto 0);
	memcntrl_ram_oe: out STD_ULOGIC := '0';
	memcntrl_ram_we: out STD_ULOGIC := '0';
	memcntrl_ram_adv: out STD_ULOGIC := '0';
	memcntrl_ram_wait: inout STD_ULOGIC := 'Z';
	memcntrl_ram_clk: out STD_ULOGIC := '0';
	memcntrl_ram_ce: out STD_ULOGIC := '1';
	memcntrl_ram_cre: out STD_ULOGIC := '0';
	memcntrl_ram_ub: out STD_ULOGIC := '1';
	memcntrl_ram_lb: out STD_ULOGIC := '1'; 
	---------------------------------------------- 
	memcntrl_adr : in STD_ULOGIC_VECTOR (24 downto 1); -- where?
	memcntrl_data_in : in STD_ULOGIC_VECTOR (15 downto 0); -- what?
	memcntrl_data_out : out STD_ULOGIC_VECTOR (15 downto 0); -- what I read.
	memcntrl_clk: in STD_ULOGIC; -- clock for the MemCtrl. tested with 100 MHz
	memcntrl_cfg_rw: in STD_ULOGIC_VECTOR (0 to 1) := "00"; -- read (10) or write (01)
	memcntrl_cfg_busy: out STD_ULOGIC := '0'; -- shows if the MemCtrl is busy = running through the states
	memcntrl_cfg_finish: out STD_ULOGIC := '0'; -- bus protocol. Says finish and waits for _thx
	memcntrl_cfg_thx: in STD_ULOGIC  := '0'; -- input if other devices read finish and say _thx to the MemCtrl
	memcntrl_cfg_state: out STD_ULOGIC_VECTOR (7 downto 0) -- the state of the MemCtrl for debug purposes
);
end MemoryController;

architecture Behavioral of MemoryController is
	-- internal latches
	signal AdrLatch: STD_ULOGIC_VECTOR (24 downto 1);
	signal DataLatch: STD_ULOGIC_VECTOR (15 downto 0);
	
begin
	process (memcntrl_clk) is
		-- idle is used to wait a few clocks to get the Timing
		variable idle : integer := 3;
		variable STATE: STD_ULOGIC_VECTOR (7 downto 0);
	begin
		memcntrl_cfg_state <= STATE;
		if (memcntrl_clk'event and memcntrl_clk = '1') then
		case STATE is
			when "00000000" => -- INIT / WAITING
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';
				memcntrl_ram_adr <= "------------------------";
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '0';
				memcntrl_cfg_finish <= '0';
				
				if idle > 0 then
					idle := idle - 1;
				elsif (idle = 0 and	memcntrl_cfg_rw = "01") then -- when write request
					STATE := "00000001";
					idle := 0; 
					AdrLatch <= memcntrl_adr;
					DataLatch <= memcntrl_data_in;
				elsif (idle = 0 and	memcntrl_cfg_rw = "10") then -- when read request
					AdrLatch <= memcntrl_adr;
					STATE := "00010000";
					idle := 0; 
				end if;
				
				
			------------- START OF STATE MACHINE FOR READ --------------
				
			when "00010000" => -- READ
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= "------------------------";
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy<= '1';
					
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00100000";
					idle := 0;
				end if;
				
			when "00100000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= "------------------------";
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy<= '1';
					
				 
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00110000";
					idle := 0;
				end if;
				
			when "00110000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy<= '1';
					
				 
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 0;
					STATE := "01000000";
				end if;
				
			when "01000000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy<= '1';
					
				 
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 0;
					STATE := "01010000";
				end if;
				
			when "01010000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy<= '1';
					
				 
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 0; 
					STATE := "01100000";
				end if;
				
			when "01100000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy<= '1';
					
				
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 0; 
					STATE := "01110000";
				end if;
				
			when "01110000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy<= '1';
					
				
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 0;
					STATE := "10000000";
				end if;
				
			when "10000000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				DataLatch <= memcntrl_ram_data;
				memcntrl_data_out <= memcntrl_ram_data;
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
				memcntrl_cfg_finish <= '1';
				 
				if idle > 0 then
					idle := idle - 1;
				elsif idle = 0 and memcntrl_cfg_thx = '1' then
					idle := 0;
					memcntrl_cfg_finish <= '0';
					STATE := "10010000";
				end if;
				
			when "10010000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				DataLatch <= memcntrl_ram_data;
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy<= '1';
				 
				if idle > 0  then
					idle := idle - 1;
				else
					idle := 0; 
					STATE := "10100000";	
				end if;
				
			when "10100000" => -- READ
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '1';
				memcntrl_ram_we <= '1';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy<= '1';
					
				
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 3;
					STATE := "00000000";
				end if;
				
				
			------------- END OF STATE MACHINE FOR READ --------------
			
			------------- START OF STATE MACHINE FOR WRITE --------------
				
				
			when "00000001" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '1';
				memcntrl_cfg_finish <= '1';
				if idle > 0 then
					idle := idle - 1;
				elsif idle = 0 and memcntrl_cfg_thx = '1' then 
					memcntrl_cfg_finish <= '0';
					STATE := "00000010";
					idle := 10;
				end if;
					
			
			when "00000010" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';      
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '1';
					
				 -- 10ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000011";
					idle := 2;
				end if;
				
			when "00000011" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '1';
					
				
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000100";
					idle := 2;
				end if;
				
			when "00000100" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '1';
					
				 -- 1ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000101";
					idle := 10;
				end if;
				
			when "00000101" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= DataLatch;
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 10ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000110";
					idle := 8;
				end if;
			
			when "00000110" =>
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= DataLatch;
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 8ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000111";
					idle := 20;
				end if;
				
			when "00000111" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= DataLatch;
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 20ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00001000";
					idle := 2;
				end if;
				
			when "00001000" =>
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= DataLatch;
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 0ns
				if idle > 0 then
					idle := idle - 1;
				else
					idle := 2;
					STATE := "00001001";
				end if;
			
			when "00001001" =>
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= DataLatch;
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
				 -- 0ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE := "00000000";
					idle := 3;
				end if;
				
			------------- END OF STATE MACHINE FOR WAIT --------------
			
			when others =>
				-- error
		end case;
		end if;
		
	end process;
end Behavioral;

