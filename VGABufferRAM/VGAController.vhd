
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:01:29 12/04/2011 
-- Design Name: 
-- Module Name:    VGAController - Behavioral 
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

entity VGAController is
PORT(
		rst         : in STD_ULOGIC;
		pixel_clk   : in STD_ULOGIC;
		HS          : out STD_ULOGIC;
		VS          : out STD_ULOGIC;
		hcount      : out STD_ULOGIC_VECTOR(10 downto 0);
		vcount      : out STD_ULOGIC_VECTOR(10 downto 0);
		blank       : out STD_ULOGIC
	);
end VGAController;

architecture Behavioral of VGAController is

------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------

-- maximum value for the horizontal pixel counter
constant HMAX  : STD_ULOGIC_VECTOR(10 downto 0) := "01100100000"; -- 800
-- maximum value for the vertical pixel counter
constant VMAX  : STD_ULOGIC_VECTOR(10 downto 0) := "01000001101"; -- 525
-- total number of visible columns
constant HLINES: STD_ULOGIC_VECTOR(10 downto 0) := "01010000000"; -- 640
-- value for the horizontal counter where front porch ends
constant HFP   : STD_ULOGIC_VECTOR(10 downto 0) := "01010001000"; -- 648
-- value for the horizontal counter where the synch pulse ends
constant HSP   : STD_ULOGIC_VECTOR(10 downto 0) := "01011101000"; -- 744
-- total number of visible lines
constant VLINES: STD_ULOGIC_VECTOR(10 downto 0) := "00111100000"; -- 480
-- value for the vertical counter where the front porch ends
constant VFP   : STD_ULOGIC_VECTOR(10 downto 0) := "00111100010"; -- 482
-- value for the vertical counter where the synch pulse ends
constant VSP   : STD_ULOGIC_VECTOR(10 downto 0) := "00111100100"; -- 484
-- polarity of the horizontal and vertical synch pulse
-- only one polarity used, because for this resolution they coincide.
constant SPP   : STD_ULOGIC := '0';

------------------------------------------------------------------------
-- SIGNALS
------------------------------------------------------------------------

-- horizontal and vertical counters
signal hcounter : STD_ULOGIC_VECTOR(10 downto 0) := (others => '0');
signal vcounter : STD_ULOGIC_VECTOR(10 downto 0) := (others => '0');

-- active when inside visible screen area.
signal video_enable: STD_ULOGIC;

begin
	-- output horizontal and vertical counters
   hcount <= hcounter;
   vcount <= vcounter;

   -- blank is active when outside screen visible area
   -- color output should be blacked (put on 0) when blank in active
   -- blank is delayed one pixel clock period from the video_enable
   -- signal to account for the pixel pipeline delay.
   blank <= not video_enable when rising_edge(pixel_clk);

   -- increment horizontal counter at pixel_clk rate
   -- until HMAX is reached, then reset and keep counting
   h_count: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(rst = '1') then
            hcounter <= (others => '0');
         elsif(hcounter = HMAX) then
            hcounter <= (others => '0');
         else
				hcounter <= STD_ULOGIC_VECTOR( unsigned(hcounter) + 1 );
         end if;
      end if;
   end process h_count;

   -- increment vertical counter when one line is finished
   -- (horizontal counter reached HMAX)
   -- until VMAX is reached, then reset and keep counting
   v_count: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(rst = '1') then
            vcounter <= (others => '0');
         elsif(hcounter = HMAX) then
            if(vcounter = VMAX) then
               vcounter <= (others => '0');
            else
					vcounter <= STD_ULOGIC_VECTOR( unsigned(vcounter) + 1 );
            end if;
         end if;
      end if;
   end process v_count;

   -- generate horizontal synch pulse
   -- when horizontal counter is between where the
   -- front porch ends and the synch pulse ends.
   -- The HS is active (with polarity SPP) for a total of 96 pixels.
   do_hs: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(hcounter >= HFP and hcounter < HSP) then
            HS <= SPP;
         else
            HS <= not SPP;
         end if;
      end if;
   end process do_hs;

   -- generate vertical synch pulse
   -- when vertical counter is between where the
   -- front porch ends and the synch pulse ends.
   -- The VS is active (with polarity SPP) for a total of 2 video lines
   -- = 2*HMAX = 1600 pixels.
   do_vs: process(pixel_clk)
   begin
      if(rising_edge(pixel_clk)) then
         if(vcounter >= VFP and vcounter < VSP) then
            VS <= SPP;
         else
            VS <= not SPP;
         end if;
      end if;
   end process do_vs;
   
   -- enable video output when pixel is in visible area
   video_enable <= '1' when (hcounter < HLINES and vcounter < VLINES) else '0';

end Behavioral;

