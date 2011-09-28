----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:17:55 09/23/2011 
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
use IEEE.NUMERIC_STD.ALL;

library STD;
use STD.TEXTIO.ALL;

library work;
use work.samuirai.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity main is
	PORT (
		vgaRed : out STD_LOGIC_VECTOR (2 downto 0);
		vgaGreen : out STD_LOGIC_VECTOR (2 downto 0);
		vgaBlue : out STD_LOGIC_VECTOR (1 downto 0);
		Hsync : out STD_LOGIC;
		Vsync : out STD_LOGIC;
		sw : in STD_LOGIC_VECTOR (7 downto 0);
		led : out STD_LOGIC_VECTOR (7 downto 0);
		seg: out STD_LOGIC_VECTOR (7 downto 0);
		an : out STD_LOGIC_VECTOR (3 downto 0);
		clk : in STD_LOGIC;
		btns: in STD_LOGIC;
		btnl: in STD_LOGIC;
		btnr: in STD_LOGIC;
		MemAdr : out STD_LOGIC_VECTOR (26 downto 0);
		Data : inout STD_LOGIC_VECTOR (15 downto 0);
		MemOE: out STD_LOGIC;
		MemWR: out STD_LOGIC;
		MemAdv: out STD_LOGIC;
		MemClk: out STD_LOGIC;
		RamCE: out STD_LOGIC;
		RamCRE: out STD_LOGIC;
		RamUB: out STD_LOGIC;
		RamLB: out STD_LOGIC
	);
end main;

architecture Behavioral of main is
	
	component clockDivider
		PORT (clk_in  : in STD_LOGIC;
				clk_out : out STD_LOGIC;
				by : in integer range 0 to 50000);
	end component;
	
	component vga_controller
		PORT(
			rst         : in std_logic;
			pixel_clk   : in std_logic;
			HS          : out std_logic;
			VS          : out std_logic;
			hcount      : out std_logic_vector(10 downto 0);
			vcount      : out std_logic_vector(10 downto 0);
			blank       : out std_logic
		);
	end component;
	
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
--	component pixel
--		PORT(
--				signal mem : memory_array;
--				signal x: integer range 1 to 640;
--				signal y: integer range 1 to 480
--			);
--	end component;

	signal clk2,clk3,clk4,blank: std_logic;
	signal hc,vc: std_logic_vector(10 downto 0); 
	SIGNAL Status : STD_LOGIC_VECTOR (2 downto 0) := "000"; 
	CONSTANT INIT1: STD_LOGIC_VECTOR (2 downto 0) := "000"; 
	CONSTANT INIT2: STD_LOGIC_VECTOR (2 downto 0) := "001";
	CONSTANT SHOW:  STD_LOGIC_VECTOR (2 downto 0) := "010"; 
	CONSTANT IDLE:  STD_LOGIC_VECTOR (2 downto 0) := "011"; 
	signal z1,z2,z3,z4 : STD_LOGIC_VECTOR (3 downto 0);
	
begin

	CockDivider25Mhz: clockDivider port map(clk,clk2,4);
	CockDivider1000: clockDivider port map(clk2,clk3,50000);
	CockDivider500: clockDivider port map(clk2,clk4,1000);
	VGAController: vga_controller port map(btns,clk2,Hsync,Vsync,hc,vc,blank);
	U1 : sevenSegment port map (z1,z2,z3,z4,seg,an,clk3);

	process (blank,sw,clk,hc)
		variable x,x2: integer range 1 to 640 := 1;
		variable y,y2: integer range 1 to 480 := 1;
		variable einer,zehner,hunderter,tausender : integer range 0 to 9;
		variable zahl : integer;
	begin
		if Status = SHOW then
			if (clk2'event and clk2 = '1') then
			
			
				z1 <= std_logic_vector(to_unsigned(9,4));
					z2 <= std_logic_vector(to_unsigned(8,4));
					z3 <= std_logic_vector(to_unsigned(7,4));
					z4 <= std_logic_vector(to_unsigned(6,4));
					
				if blank = '0' then
					MemAdr <= "00000"&hc&vc;
					MemClk <= '0';
					MemAdv <= '0';
					RamCE  <= '0';
					MemOE  <= '0';
					MemWR  <= '1';
					RamCRE <= '0';
					RamUB  <= '0';
					RamLB  <= '0';
					led <= Data(7 downto 0);
					vgaRed <= Data(7 downto 5);
					vgaGreen <= Data(4 downto 2);
					vgaBlue <= Data(1 downto 0);
				else
					vgaRed <= "000";
					vgaGreen <= "000";
					vgaBlue <= "00";
				end if;
			end if;
		elsif Status=INIT1 then
			if (clk4'event and clk4 = '1') then
				if x<640 then
					if y>200 and y<300 then
						Data(7 downto 0) <= "00000011";
						Data(15 downto 8) <= "00000011";
					else
						Data(7 downto 0) <= sw;
						Data(15 downto 8) <= sw;
					end if;
					MemAdr <= "00000"&std_logic_vector(to_unsigned(x,11))&std_logic_vector(to_unsigned(y,11));
					MemClk <= '0';
					MemAdv <= '0';
					RamCE  <= '0';
					MemOE  <= 'Z';
					MemWR  <= '0';
					RamCRE <= '0';
					RamUB  <= '0';
					RamLB  <= '0';
					led <= Data(7 downto 0);
					vgaRed <= Data(7 downto 5);
					vgaGreen <= Data(4 downto 2);
					vgaBlue <= Data(1 downto 0);
					-- calculates the single digits
					zahl := y;
					tausender := zahl / 1000;
					hunderter := (zahl - tausender*1000) / 100;
					zehner    := (zahl - tausender*1000 - hunderter*100) / 10;
					einer     := (zahl - tausender*1000 - hunderter*100 - zehner*10);		
					-- z1-z4 will be displayed by the sevenSegment component
					z1 <= std_logic_vector(to_unsigned(1,4));
					z2 <= std_logic_vector(to_unsigned(hunderter,4));
					z3 <= std_logic_vector(to_unsigned(zehner,4));
					z4 <= std_logic_vector(to_unsigned(einer,4));

					x := x+1;
				else
					x := 1;
					if y<480 then
						y := y+1;
					else
						y := 1;
						x := 1;
						STATUS <= INIT2;
					end if;
				end if;
			end if;

			
		elsif Status=INIT2 then
		
			if (clk4'event and clk4 = '1') then
				if x2<640 then
					
					MemAdr <= "00000"&std_logic_vector(to_unsigned(x2,11))&std_logic_vector(to_unsigned(y2,11));
					MemClk <= '0';
					MemAdv <= '0';
					RamCE  <= '0';
					MemOE  <= '0';
					MemWR  <= '1';
					RamCRE <= '0';
					RamUB  <= '0';
					RamLB  <= '0';
					led <= Data(7 downto 0);
					vgaRed <= Data(7 downto 5);
					vgaGreen <= Data(4 downto 2);
					vgaBlue <= Data(1 downto 0);
					-- calculates the single digits
					zahl := y2;
					tausender := zahl / 1000;
					hunderter := (zahl - tausender*1000) / 100;
					zehner    := (zahl - tausender*1000 - hunderter*100) / 10;
					einer     := (zahl - tausender*1000 - hunderter*100 - zehner*10);		
					-- z1-z4 will be displayed by the sevenSegment component
					z1 <= std_logic_vector(to_unsigned(2,4));
					z2 <= std_logic_vector(to_unsigned(hunderter,4));
					z3 <= std_logic_vector(to_unsigned(zehner,4));
					z4 <= std_logic_vector(to_unsigned(einer,4));
					Status<=IDLE;
					x2 := x2+1;
				else
					
					x2 := 1;
					if y2<480 then
						y2 := y2+1;
					else
						y2 := 1;
						x2 := 1;
						STATUS <= SHOW;
					end if;
				end if;
			end if;
		elsif Status=IDLE then	
			if (clk4'event and clk4 = '1') then
				MemClk <= '0';
				MemAdv <= '1';
				RamCE  <= '0';
				MemOE  <= 'Z';
				MemWR  <= '1';
				RamCRE <= '0';
				RamUB  <= 'Z';
				RamLB  <= 'Z';
				led <= "10101010";
				Status<=INIT2;
			end if;
		end if;
	end process;
	

	
end Behavioral;

