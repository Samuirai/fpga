----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Fabian Faessler 
-- 
-- Create Date:    00:59:33 09/25/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: NEXYS3
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

entity main is
	PORT (
		MemAdr : out STD_LOGIC_VECTOR (23 downto 1);
		Data : inout STD_LOGIC_VECTOR (15 downto 0);
		sw: in STD_LOGIC_VECTOR (7 downto 0);
		led: out STD_LOGIC_VECTOR (7 downto 0);
		MemOE: out STD_LOGIC;
		MemWR: out STD_LOGIC;
		MemAdv: out STD_LOGIC;
		MemWait: in STD_LOGIC;
		MemClk: out STD_LOGIC;
		RamCE: out STD_LOGIC;
		RamCRE: out STD_LOGIC;
		RamUB: out STD_LOGIC;
		RamLB: out STD_LOGIC;
		btnl: in STD_LOGIC;
		btnr: in STD_LOGIC;
		clk: in STD_LOGIC
	);
end main;

architecture Behavioral of main is
	
	SIGNAL GBState : STD_LOGIC_VECTOR (2 DownTo 0); 
	CONSTANT INIT: STD_LOGIC_VECTOR (1 DownTo 0) := "000"; 
	CONSTANT B: STD_LOGIC_VECTOR (1 DownTo 0) := "001"; 
	CONSTANT C: STD_LOGIC_VECTOR (1 DownTo 0) := "010"; 
	CONSTANT D: STD_LOGIC_VECTOR (1 DownTo 0) := "011";
	CONSTANT E: STD_LOGIC_VECTOR (1 DownTo 0) := "100"; 
	CONSTANT F: STD_LOGIC_VECTOR (1 DownTo 0) := "101"; 
	CONSTANT G: STD_LOGIC_VECTOR (1 DownTo 0) := "110"; 
	CONSTANT H: STD_LOGIC_VECTOR (1 DownTo 0) := "111";
	component clockDivider
		PORT (clk_in  : in STD_LOGIC;
				clk_out : out STD_LOGIC;
				by : in integer range 0 to 100_000_000);
	end component;

	signal clk2: STD_LOGIC;
		-- Memory read/write
	signal memOp              : std_logic_vector(1 downto 0);
	signal memBusy            : std_logic;
	signal mcrAddrInput  : std_logic_vector(22 downto 0);
	signal mcrDataInput  : std_logic_vector(15 downto 0);
	signal mcrDataOutput : std_logic_vector(15 downto 0);
begin
	RamUB <= '0';
	RamLB <= '0';
	led <= sw;
	ClockDivider25: clockDivider port map (clk,clk2,2);
	Mem: MemoryController port map (
	
			-- Internal interface
			clk           => clk,        -- clocked at 2x rate you want ramClk
			reset         => btnr,     -- reset memctrl
			memRequest    => memOp(0),     -- ask memctrl to begin an operation
			readNotWrite  => memOp(1),     -- tell memctrl whether to read or write
			busy          => memBusy,      -- mem controller is busy
			mcrAddrInput  => mcrAddrInput,      -- address you want to access
			mcrDataInput  => mcrDataInput,    -- data to be written to RAM
			mcrDataOutput => mcrDataOutput,   -- data read from RAM (registered)

			-- External interface
			ramClk        => MemClk,   -- driven at clk/2
			nWait         => MemWait,   -- RAM busy pin
			addressBus    => MemAdr,  -- RAM address pins
			dataBus       => Data,   -- RAM data pins (bidirectional)
			nADV          => MemADV,   -- RAM address valid pin
			nCE           => RamCE,    -- RAM chip enable pin
			CRE           => RamCRE,   -- Control Register Enable pin
			nWE           => MemWR,    -- Write Enable
			nOE           => MemOE     -- Output Enable
		);

end Behavioral;

