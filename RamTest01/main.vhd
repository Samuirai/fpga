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
			btnl: in STD_ULOGIC;
			btnu: in STD_ULOGIC;
			btns: in STD_ULOGIC;
			btnr: in STD_ULOGIC;
			btnd: in STD_ULOGIC;
			clk: in STD_ULOGIC
		);
end main;

architecture Behavioral of main is
	component memctrl 
		PORT( MemAdr : out STD_ULOGIC_VECTOR (23 downto 1) := "00000000000000000000000";
			MemData : inout STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
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
			DataIn : in STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
			DataOut : out STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
			AdrIn : in STD_ULOGIC_VECTOR (1 to 23);
			WriteRequest: in STD_ULOGIC := '0';
			ReadRequest: in STD_ULOGIC := '0';
			busy: out STD_ULOGIC := '0';
			OKIN: in STD_ULOGIC := '0';
			OKOUT: out STD_ULOGIC := '0'
			--led: out STD_ULOGIC_VECTOR := "00000000"
		);
	end component;
	
	signal MemBusy: STD_ULOGIC := '0';
	signal DataOut: STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal DataIn: STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
	signal Adr: STD_ULOGIC_VECTOR (1 to 23);
	signal WriteRequest: STD_ULOGIC := '0';
	signal ReadRequest: STD_ULOGIC := '0';
	signal OKOUT: STD_ULOGIC := '0';
	signal OKIN: STD_ULOGIC := '0';
begin
	
	MemoryController: memctrl port map(
			MemAdr => MemAdr,
			MemData => Data,
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
			--led => led,
			busy => MemBusy,
			ReadRequest => ReadRequest,
			WriteRequest => WriteRequest,
			DataIn => DataIn,
			DataOut => DataOut,
			AdrIn => Adr,
			OKIN => OKIN,
			OKOUT => OKOUT
		);
	
	process 
	begin
		
		if (clk'event and clk = '1') then
			if (MemBusy = '0') then
				if(btnl = '1') then
					ReadRequest <= '0';
					WriteRequest <= '1';
					--led <= sw;
					DataIn <= "00000000"&sw;
					Adr <= "00000000000000000000000";
				elsif(btnu = '1') then
					ReadRequest <= '0';
					WriteRequest <= '1';
					--led <= sw;
					DataIn <= "00000000"&sw;
					Adr <= "00000000000000000000011";
				elsif(btnd = '1') then
					ReadRequest <= '1';
					WriteRequest <= '0';
					Adr <= "00000000000000000000000";
				elsif(btnr = '1') then
					ReadRequest <= '1';
					WriteRequest <= '0';
					Adr <= "00000000000000000000011";
				elsif(btns = '1') then
					ReadRequest <= '0';
					WriteRequest <= '0';
					--DataOut <= "0000000000000000";
					--Data <= "0000000000000000";
				else
					ReadRequest <= '0';
					WriteRequest <= '0';
					OKIN <= '0';
					led <= OKOUT & MemBusy &"000001";
				end if;
			else
				if(OKOUT = '1') then
					OKIN <= '1';
				
			--led <= OKOUT & MemBusy &"100010";
					led <= DataOut(7 downto 0);
				else
					OKIN <= '0';
					--led <= OKOUT & MemBusy &"000010";
				end if;
				ReadRequest <= '0';
				WriteRequest <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;

