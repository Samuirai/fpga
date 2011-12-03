----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:00:42 12/03/2011 
-- Design Name: 
-- Module Name:    TopLayer - Behavioral 
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

entity TopLayer is
	PORT (
		MemAdr : out STD_ULOGIC_VECTOR (23 downto 1) := "00000000000000000000000";
		Data : inout STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
		RamOE: out STD_ULOGIC := '0';
		MemWE: out STD_ULOGIC := '0';
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
		sw : in  STD_ULOGIC_VECTOR (7 downto 0);
		led: out STD_ULOGIC_VECTOR (7 downto 0);
		seg: out STD_ULOGIC_VECTOR (7 downto 0);
		an : out STD_ULOGIC_VECTOR (3 downto 0);
		btn : in STD_ULOGIC_VECTOR (4 downto 0);
		clk : in STD_ULOGIC
	);
end TopLayer;

architecture Behavioral of TopLayer is

	component sevenSegment
		PORT (
			in1 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0000";
			in2 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0001";
			in3 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0010";
			in4 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0011";
			out1: out STD_ULOGIC_VECTOR (0 to 7) := "0000000";
			out2: out STD_ULOGIC_VECTOR (3 downto 0) := "0000";
			clk : in STD_ULOGIC
		);
	end component;
	
	component clockDivider
		PORT (
			clk_in  : in  STD_LOGIC;
			clk_out : out STD_LOGIC;
			divide_by : in integer range 0 to 50000
		);
	end component;
	
	component MemoryController
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
			memcntrl_cfg_rw: in STD_ULOGIC_VECTOR (0 to 1);
			memcntrl_cfg_busy: out STD_ULOGIC := '0';
			memcntrl_cfg_thx: in STD_ULOGIC := '0';
			memcntrl_cfg_finish: out STD_ULOGIC := '0';
			memcntrl_cfg_state: out STD_ULOGIC_VECTOR (7 downto 0)
		);
	end component;

	
	signal number1,number2,number3,number4 : STD_ULOGIC_VECTOR (3 downto 0);
	signal clk10000,clk100 : STD_LOGIC;
	signal memcntrl_state : STD_ULOGIC_VECTOR (7 downto 0);
	signal memcntrl_thx : STD_ULOGIC := '0';
	signal memcntrl_finish : STD_ULOGIC;
	signal memcntrl_rw : STD_ULOGIC_VECTOR (0 to 1);
	signal memcntrl_busy : STD_ULOGIC;
	signal memcntrl_data : STD_ULOGIC_VECTOR (15 downto 0);
	signal memcntrl_adr : STD_ULOGIC_VECTOR (23 downto 1);
begin

	led <= sw;
	number1 <= memcntrl_state(3 downto 0);
	number2 <= memcntrl_state(7 downto 4);
	number3 <= "0001";
	number4 <= "0010";
	
	-- divides the clock. clk2 for the 7segment multiplex
	divide_clock_by_10000 : clockDivider port map (clk,clk10000,10000);
	divide_clock_by_100 : clockDivider port map (clk,clk100,100);
	-- map the seven segment display
	seven_segment_display : sevenSegment port map (number1,number2,number3,number4,seg,an,clk10000);
	
	memory_controller: MemoryController port map (
		memcntrl_ram_adr => MemAdr,
		memcntrl_ram_data => Data,
		memcntrl_adr => memcntrl_adr,
		memcntrl_data => memcntrl_data,
		memcntrl_ram_oe => RamOE,
		memcntrl_ram_we => MemWE,
		memcntrl_ram_adv => MemAdv,
		memcntrl_ram_wait => MemWait,
		memcntrl_ram_clk => MemClk,
		memcntrl_ram_ce => RamCE,
		memcntrl_ram_cre => RamCRE,
		memcntrl_ram_ub => RamUB,
		memcntrl_ram_lb => RamLB,
		memcntrl_clk => clk,
		memcntrl_cfg_rw => memcntrl_rw,
		memcntrl_cfg_busy => memcntrl_busy,
		memcntrl_cfg_finish => memcntrl_finish,
		memcntrl_cfg_thx => memcntrl_thx,
		memcntrl_cfg_state => memcntrl_state
	);
	
	process (clk,btnl,btnr) is
		
	begin
		if btnl = '1' then
			memcntrl_rw <= "01";
			memcntrl_adr <= "00000000000000000000000";
			memcntrl_data <= "0000000000000001";
		elsif btnr = '1' then
			memcntrl_rw <= "01";
			memcntrl_adr <= "00000000000000000000001";
			memcntrl_data <= "0000000000000010";
		else
			memcntrl_rw <= "00";
		end if;
		
		if memcntrl_finish = '1' then
			memcntrl_thx <= '1';
		end if;
	end process;
	
end Behavioral;

