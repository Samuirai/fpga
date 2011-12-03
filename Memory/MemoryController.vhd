----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:01:30 12/03/2011 
-- Design Name: 
-- Module Name:    MemoryController - Behavioral 
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

entity MemoryController is
PORT( 
	memcntrl_ram_adr : out STD_ULOGIC_VECTOR (23 downto 1);
	memcntrl_ram_data : inout STD_ULOGIC_VECTOR (15 downto 0);
	memcntrl_adr : in STD_ULOGIC_VECTOR (23 downto 1);
	memcntrl_data : inout STD_ULOGIC_VECTOR (15 downto 0);
	memcntrl_ram_oe: out STD_ULOGIC := '0';
	memcntrl_ram_we: out STD_ULOGIC := '0';
	memcntrl_ram_adv: out STD_ULOGIC := '0';
	memcntrl_ram_wait: inout STD_ULOGIC := '0';
	memcntrl_ram_clk: out STD_ULOGIC := '0';
	memcntrl_ram_ce: out STD_ULOGIC := '0';
	memcntrl_ram_cre: out STD_ULOGIC := '0';
	memcntrl_ram_ub: out STD_ULOGIC := '0';
	memcntrl_ram_lb: out STD_ULOGIC := '0';
	memcntrl_clk: in STD_ULOGIC;
	memcntrl_cfg_rw: in STD_ULOGIC_VECTOR (0 to 1) := "00";
	memcntrl_cfg_busy: out STD_ULOGIC := '0';
	memcntrl_cfg_finish: out STD_ULOGIC := '0';
	memcntrl_cfg_thx: in STD_ULOGIC  := '0';
	memcntrl_cfg_state: out STD_ULOGIC_VECTOR (7 downto 0)
);
end MemoryController;

architecture Behavioral of MemoryController is
	signal STATE: STD_ULOGIC_VECTOR (7 downto 0);
	signal AdrLatch: STD_ULOGIC_VECTOR (23 downto 1);
	signal DataLatch: STD_ULOGIC_VECTOR (15 downto 0);
	
begin
	process (memcntrl_clk) is
		variable idle : integer := 3;
	begin
		memcntrl_cfg_state <= STATE;
		if (memcntrl_clk'event and memcntrl_clk = '1') then
		case STATE is
			when "00000000" => -- INIT / WAITING
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';
				memcntrl_ram_adr <= "-----------------------";
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= 'Z';
				memcntrl_cfg_busy <= '0';
				memcntrl_cfg_finish <= '0';
				
				if idle > 0 then
					idle := idle - 1;
				elsif (idle = 0 and	memcntrl_cfg_rw = "01") then
					STATE <= "00000001";
					idle := 3; -- safe
				elsif (idle = 0 and	memcntrl_cfg_rw = "10") then
					--AdrLatch <= memcntrl_adr;
					STATE <= "00010000";
					idle := 3; -- safe
				end if;
				
			when "00000001" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '1';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';
				memcntrl_ram_adr <= memcntrl_adr;
				AdrLatch <= memcntrl_adr;
				DataLatch <= memcntrl_data;
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
					STATE <= "00000010";
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
					STATE <= "00000011";
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
					STATE <= "00000100";
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
					STATE <= "00000101";
					idle := 10;
				end if;
				
			when "00000101" => -- WRITE
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '1';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 10ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE <= "00000110";
					idle := 8;
				end if;
			
			when "00000110" =>
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '0';
				memcntrl_ram_lb <= '0';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
					
				 -- 8ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE <= "00000111";
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
					STATE <= "00001000";
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
					STATE <= "00001001";
				end if;
			
			when "00001001" =>
			
				memcntrl_ram_adv <= '0';
				memcntrl_ram_ce <= '0';
				memcntrl_ram_oe <= '0';
				memcntrl_ram_we <= '0';             
				memcntrl_ram_adr <= AdrLatch;
				memcntrl_ram_data <= "ZZZZZZZZZZZZZZZZ";
				memcntrl_ram_ub <= '1';
				memcntrl_ram_lb <= '1';
				memcntrl_ram_wait <= '0';
				memcntrl_cfg_busy <= '1';
				 -- 0ns
				if idle > 0 then
					idle := idle - 1;
				else
					STATE <= "00000000";
					idle := 3;
				end if;
			
			when others =>
				-- error
		end case;
		end if;
		
	end process;
end Behavioral;

