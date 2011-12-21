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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLayer is
	PORT (
	
		vgaRed : out STD_ULOGIC_VECTOR (2 downto 0);
		vgaGreen : out STD_ULOGIC_VECTOR (2 downto 0);
		vgaBlue : out STD_ULOGIC_VECTOR (1 downto 0);
		Hsync : out STD_ULOGIC;
		Vsync : out STD_ULOGIC;
		
		MemAdr : out STD_ULOGIC_VECTOR (24 downto 1) := "00000000000000000000000";
		Data : inout STD_ULOGIC_VECTOR (15 downto 0) := "0000000000000000";
		RamOE: out STD_ULOGIC := '0';
		MemWE: out STD_ULOGIC := '0';
		MemAdv: out STD_ULOGIC := '0';
		MemWait: inout STD_ULOGIC := '0';
		MemClk: out STD_ULOGIC := '0';
		RamCE: out STD_ULOGIC := '1';
		RamCRE: out STD_ULOGIC := '0';
		RamUB: out STD_ULOGIC := '1';
		RamLB: out STD_ULOGIC := '1';
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

	component VGAController
		PORT(
			rst         : in STD_ULOGIC;
			pixel_clk   : in STD_ULOGIC;
			HS          : out STD_ULOGIC;
			VS          : out STD_ULOGIC;
			hcount      : out STD_ULOGIC_vector(10 downto 0);
			vcount      : out STD_ULOGIC_vector(10 downto 0);
			blank       : out STD_ULOGIC
		);
	end component;

	component sevenSegment
		PORT (
			in1 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0000";
			in2 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0001";
			in3 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0010";
			in4 : in  STD_ULOGIC_VECTOR (3 downto 0) := "0011";
			out1: out STD_ULOGIC_VECTOR (0 to 7)  := "0000000";
			out2: out STD_ULOGIC_VECTOR (3 downto 0) := "0000";
			clk : in STD_ULOGIC
		);
	end component;
	
	component clockDivider
		PORT (
			clk_in  : in  STD_ULOGIC;
			clk_out : out STD_ULOGIC;
			divide_by : in integer range 0 to 10000000
		);
	end component;
	
	component MemoryController
		PORT( 
			memcntrl_ram_adr : out STD_ULOGIC_VECTOR (24 downto 1);
			memcntrl_ram_data : inout STD_ULOGIC_VECTOR (15 downto 0);
			memcntrl_adr : in STD_ULOGIC_VECTOR (24 downto 1);
			memcntrl_data_out : out STD_ULOGIC_VECTOR (15 downto 0);
			memcntrl_data_in : in STD_ULOGIC_VECTOR (15 downto 0);
			memcntrl_ram_oe: out STD_ULOGIC := '0';
			memcntrl_ram_we: out STD_ULOGIC := '0';
			memcntrl_ram_adv: out STD_ULOGIC := '0';
			memcntrl_ram_wait: inout STD_ULOGIC := '0';
			memcntrl_ram_clk: out STD_ULOGIC := '0';
			memcntrl_ram_ce: out STD_ULOGIC := '1';
			memcntrl_ram_cre: out STD_ULOGIC := '0';
			memcntrl_ram_ub: out STD_ULOGIC := '1';
			memcntrl_ram_lb: out STD_ULOGIC := '1';
			memcntrl_clk: in STD_ULOGIC;
			memcntrl_cfg_rw: in STD_ULOGIC_VECTOR (0 to 1);
			memcntrl_cfg_busy: out STD_ULOGIC := '0';
			memcntrl_cfg_thx: in STD_ULOGIC := '0';
			memcntrl_cfg_finish: out STD_ULOGIC := '0';
			memcntrl_cfg_state: out STD_ULOGIC_VECTOR (7 downto 0)
		);
	end component;
	
	component FIFO
		PORT (	
			fifo_clk: in STD_ULOGIC;
			fifo_out: out STD_ULOGIC;
			fifo_empty: out STD_ULOGIC := '0';
			fifo_thx: in STD_LOGIC;
			fifo_data: in STD_ULOGIC_VECTOR (15 downto 0);
			fifo_regA: out STD_ULOGIC_VECTOR (15 downto 0) := "1010101010101010"
		);
	end component;

	signal number1,number2,number3,number4 : STD_ULOGIC_VECTOR (3 downto 0);
	signal clk10000,clk100,clk3,clk4,clk5 : STD_ULOGIC;
	signal memcntrl_state : STD_ULOGIC_VECTOR (7 downto 0);
	signal memcntrl_thx : STD_ULOGIC := '0';
	signal memcntrl_finish : STD_ULOGIC;
	signal memcntrl_rw : STD_ULOGIC_VECTOR (0 to 1);
	signal memcntrl_busy : STD_ULOGIC;
	signal memcntrl_data_in : STD_ULOGIC_VECTOR (15 downto 0) := "1110001110001110";
	signal memcntrl_data_out : STD_ULOGIC_VECTOR (15 downto 0) := "1110001110001110";
	signal memcntrl_adr : STD_ULOGIC_VECTOR (24 downto 1);
	signal blank: STD_ULOGIC;
	signal hc,vc: STD_ULOGIC_vector(10 downto 0);
	signal color,latch,regA : STD_ULOGIC_VECTOR (15 downto 0) := "1010101010101010";
	signal counter: integer := 0;
	signal bw,empty,thx: STD_ULOGIC;
begin

	
	
	-- divides the clock. clk2 for the 7segment multiplex
	divide_clock_by_10000 : clockDivider port map (clk,clk10000,5000);
	divide_clock_by_3 : clockDivider port map (clk,clk3,3);
	sekunde1 : clockDivider port map (clk,clk4,10000000);
	sekunde2 : clockDivider port map (clk,clk5,  500000);

	--divide_clock_by_100 : clockDivider port map (clk,clk100,100);
	-- map the seven segment display
	seven_segment_display : sevenSegment port map (number1,number2,number3,number4,seg,an,clk10000);
	
	
	vga_controller: VGAController port map(sw(0),clk3,Hsync,Vsync,hc,vc,blank);
	
	fifo161 : FIFO port map(	
			fifo_clk => clk4,
			fifo_out => bw,
			fifo_empty => empty,
			fifo_thx => thx,
			fifo_data => latch,
			fifo_regA=> regA 
		);
		
	
	memory_controller: MemoryController port map (
		memcntrl_ram_adr => MemAdr,
		memcntrl_ram_data => Data,
		memcntrl_adr => memcntrl_adr,
		memcntrl_data_in => memcntrl_data_in,
		memcntrl_data_out => memcntrl_data_out,
		memcntrl_ram_oe => RamOE,
		memcntrl_ram_we => MemWE,
		memcntrl_ram_adv => MemAdv,
		memcntrl_ram_wait => MemWait,
		memcntrl_ram_clk => MemClk,
		memcntrl_ram_ce => RamCE,
		memcntrl_ram_cre => RamCRE,
		memcntrl_ram_ub => RamUB,
		memcntrl_ram_lb => RamLB,
		memcntrl_clk => clk5,
		memcntrl_cfg_rw => memcntrl_rw,
		memcntrl_cfg_busy => memcntrl_busy,
		memcntrl_cfg_finish => memcntrl_finish,
		memcntrl_cfg_thx => memcntrl_thx,
		memcntrl_cfg_state => memcntrl_state
	);
	
	
	--led <= memcntrl_rw & memcntrl_busy & memcntrl_finish & memcntrl_thx & clk & "11";
	--number1 <= memcntrl_state(7 downto 4);
	--number2 <= memcntrl_state(7 downto 4);
	process (clk4,thx,empty,memcntrl_busy,memcntrl_thx,clk) is
	begin
		if(memcntrl_thx = '1') then
			number1 <= "0001";
		else
			number1 <= "0000";
		end if;
		if(bw = '1') then
			number2 <= "0001";
		else
			number2 <= "0000";
		end if;
		if(memcntrl_busy = '1') then
			number3 <= "0001";
		else
			number3 <= "0000";
		end if;
	end process;
	
	number4 <= memcntrl_state(7 downto 4);
	
	process (blank,clk,hc,vc)
	
	begin
	
		if blank = '0' then
			vgaRed <= "111";
			vgaGreen <= "111";
			vgaBlue <= "11";
		else
			vgaRed <= "000";
			vgaGreen <= "000";
			vgaBlue <= "00";
		end if;
		--led <= hc(7 downto 0);
	end process;
	
	process (clk,btnl,btnr,btnu,btnd,memcntrl_busy,memcntrl_finish,hc,vc,empty) is
		
	begin
		
		if btnl = '1' then
			--memcntrl_rw <= "01";
			--memcntrl_adr <= "000000000000000000000001";
			--memcntrl_data_in <= "00000000" & sw;
			led <= regA(7 downto 0);
		elsif btnr = '1' then
			--memcntrl_rw <= "01";
			--memcntrl_adr <= "000000000000000000000010";
			--memcntrl_data_in <= "00000000" & sw;
			
		elsif btnu = '1' then
			memcntrl_rw <= "10";
			memcntrl_adr <= "000000000000000000000000";
			led <= latch(15 downto 8);
		elsif btnd = '1' then
			--memcntrl_rw <= "10";
			--memcntrl_adr <= "000000000000000000000010";
			led <= latch(7 downto 0);
		else
			led <= regA(15 downto 8);
			
		end if;
			--if(hc(3 downto 0) = "0000") then
		if(empty = '1' and memcntrl_busy='0') then
			memcntrl_rw <= "10";
			memcntrl_adr <= "000000000000000000000000";
			--memcntrl_adr <= "000000" & hc(10 downto 4) & vc;
		end if;
		
		if(empty = '1' and thx = '1') then
			thx <= '0';
		end if;
		
		if memcntrl_finish = '1' and memcntrl_thx='0' then
			if (sw(0) = '1') then
				latch <= memcntrl_data_out;
			else
				latch <= "1100110011001100";
			end if;
			memcntrl_rw <= "00";
			if(empty = '1') then
				thx <= '1';
			end if;
			memcntrl_thx <= '1';
		end if;
	end process;
	
end Behavioral;

