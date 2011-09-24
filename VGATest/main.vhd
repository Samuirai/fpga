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
		clk : in STD_LOGIC;
		btns: in STD_LOGIC
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
	component pixel
		PORT(
				signal mem : memory_array;
				signal x: integer range 1 to 640;
				signal y: integer range 1 to 480
			);
	end component;

	signal clk2,blank: std_logic;
	signal hc,vc: std_logic_vector(10 downto 0);
	type uchar_arr is array (0 to 255) of std_logic_vector(7 downto 0);
	
	shared variable str : string (1 to 8) := "SAMUIRAI";
begin

	led <= sw;
	process (blank,sw,clk,hc)
		variable x,x2: integer range 1 to 640;
		variable y: integer range 1 to 480;
		variable mem : memory_array;
	begin
	
		for x in 1 to 640 loop
			for y in 1 to 480 loop
				mem(x,y) := "00000011";
			end loop;
		end loop;
		y := 100;
		x := 2;
		x2:=x*8+100;
		letter(mem,x2,y,str(x));
		
		if blank = '0' then
			vgaRed <= mem(to_integer(unsigned(hc)),to_integer(unsigned(vc)))(7 downto 5);
			vgaGreen <= mem(to_integer(unsigned(hc)),to_integer(unsigned(vc)))(4 downto 2);
			vgaBlue <= mem(to_integer(unsigned(hc)),to_integer(unsigned(vc)))(1 downto 0);
		else
			vgaRed <= "000";
			vgaGreen <= "000";
			vgaBlue <= "00";
		end if;
	end process;
	CockDivider25Mhz: clockDivider port map(clk,clk2,3);
	VGAController: vga_controller port map(btns,clk2,Hsync,Vsync,hc,vc,blank);
	

end Behavioral;

