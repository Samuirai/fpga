----------------------------------------------------------------------------------
-- Company:  
-- Engineer: Fabian Faessler (Samuirai)
-- 
-- Create Date:    00:19:46 09/20/2011 
-- Design Name: 
-- Module Name:    main - Behavioral 
-- Project Name: 
-- Target Devices: NEXYS3 - Spartan-6
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- main block. Handles the main input and outputs.
entity main is
	PORT (
			sw : in  STD_LOGIC_VECTOR (7 downto 0);
			led: out STD_LOGIC_VECTOR (7 downto 0);
			seg: out STD_LOGIC_VECTOR (7 downto 0);
			an : out STD_LOGIC_VECTOR (3 downto 0);
			btn : in STD_LOGIC_VECTOR (4 downto 0);
			clk : in STD_LOGIC
		);
end main;

-- #####################################################

architecture Behavioral of main is
	-- clocks used for the clock divider
	signal clk2 : STD_LOGIC;
	signal clk3 : STD_LOGIC;
	-- component to show numbers on the 7 segment display
	component sevenSegment
		PORT (
			in1 : in  STD_LOGIC_VECTOR (3 downto 0);
			in2 : in  STD_LOGIC_VECTOR (3 downto 0);
			in3 : in  STD_LOGIC_VECTOR (3 downto 0);
			in4 : in  STD_LOGIC_VECTOR (3 downto 0);
			out1: out STD_LOGIC_VECTOR (0 to 7);
			out2: out STD_LOGIC_VECTOR (3 downto 0);
			Clock : in STD_LOGIC
		);
	end component;
	-- cock divider, divides the clock by the given speed (by)
	component clockDivider
		PORT (
			clk_in  : in  STD_LOGIC;
			clk_out : out STD_LOGIC;
			by : in integer range 0 to 50000
		);
	end component;
	-- signals used inside of the main blog
	signal z1,z2,z3,z4 : STD_LOGIC_VECTOR (3 downto 0);
	signal COUNTER: integer range 0 to 9999;
	signal speed: integer range 0 to 50000;
begin
	
	-- divides the clock. clk2 for the 7segment multiplex
	U2 : clockDivider port map (clk,clk2,10000);
	-- divides the clock. clk3 for the counting of the numbers
	U3 : clockDivider port map (clk2,clk3,speed);
	-- show the numbers
	U1 : sevenSegment port map (z1,z2,z3,z4,seg,an,clk2);
	
	-- leds show which switch is active
	led <= sw;

	-- process to count and calculate the numbers for the 7 segment display
	process
		variable einer,zehner,hunderter,tausender : integer range 0 to 9;
		variable zahl,ziel : integer;
	begin
		speed <= 500;
		ziel := to_integer(unsigned(sw));	
		
		-- count up or down, depends on the ziel (goal) what binary number is set by the switches
		if (clk3'event and clk3 = '1') then	
			if COUNTER > ziel then
				COUNTER <= COUNTER-1;
			elsif COUNTER < ziel then
				COUNTER <= COUNTER+1;
			else
				COUNTER <= ziel;
			end if;
		end if;
		
		-- calculates the single digits
		zahl := COUNTER;
		tausender := zahl / 1000;
		hunderter := (zahl - tausender*1000) / 100;
		zehner    := (zahl - tausender*1000 - hunderter*100) / 10;
		einer     := (zahl - tausender*1000 - hunderter*100 - zehner*10);		
		-- z1-z4 will be displayed by the sevenSegment component
		z1 <= std_logic_vector(to_unsigned(tausender,4));
		z2 <= std_logic_vector(to_unsigned(hunderter,4));
		z3 <= std_logic_vector(to_unsigned(zehner,4));
		z4 <= std_logic_vector(to_unsigned(einer,4));
		
	end process;
	
end Behavioral;

