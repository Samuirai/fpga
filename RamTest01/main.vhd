----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:44:24 10/15/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

entity main is
	PORT( MemAdr : out STD_ULOGIC_VECTOR (23 downto 1);
			Data : inout STD_ULOGIC_VECTOR (15 downto 0);
			sw: in STD_ULOGIC_VECTOR (7 downto 0);
			led: out STD_ULOGIC_VECTOR (7 downto 0) := "00000000";
			RamOE: out STD_ULOGIC := '0';
			MemWR: out STD_ULOGIC := '0';
			MemAdv: out STD_ULOGIC := '0';
			MemWait: inout STD_ULOGIC := '0';
			MemClk: out STD_ULOGIC := '0';
			RamCE: out STD_ULOGIC := '0';
			RamCRE: out STD_ULOGIC := '0';
			RamUB: out STD_ULOGIC := '0';
			RamLB: out STD_ULOGIC := '0';
			clk: in STD_ULOGIC
		);
end main;

architecture Behavioral of main is
	component memctrl 
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
	end component;
	
	signal MemBusy: STD_ULOGIC := '0';
	signal DataRequest: STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal AdrRequest: STD_ULOGIC_VECTOR (23 downto 1) := "00000000000000000000000";
	signal WriteRequest: STD_ULOGIC := '0';
	
begin
	
	MemoryController: memctrl port map(
			MemAdr => MemAdr,
			MemData => Data,
			DataRequest => DataRequest,
			RamOE => RamOE,
			MemWR => MemWR,
			MemAdv => MemAdv,
			MemWait => MemWait,
			MemClk => MemClk,
			RamCE => RamCE,
			RamCRE => RamCRE,
			RamUB => RamUB,
			RamLB => RamLB,
			clk => clk,
			busy => MemBusy,
			AdrRequest => AdrRequest,
			WriteRequest => WriteRequest
		);
	process 
	
	begin
		if (clk'event and clk = '1') then
			if (MemBusy = '0') then
				WriteRequest <= '1';
				led <= "11110000";
				DataRequest <= "0101010101010101";
				AdrRequest <= "00000000000000000000000";
			else
				WriteRequest <= '1';
				led <= "11111111";
				DataRequest <= "0101010101010101";
				AdrRequest <= "00000000000000000000000";
			end if;
		end if;
	end process;
	
end Behavioral;

