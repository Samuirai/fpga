--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package samuirai is

subtype tmp is std_logic_vector(7 downto 0);
type memory_array is array(integer range 1 to 640, integer range 1 to 480) of tmp;
-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	procedure letter (
		variable mem : out memory_array;
		variable xin: integer range 1 to 640;
		variable yin: integer range 1 to 480;
		variable c: character
	);
end samuirai;

package body samuirai is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;

	procedure letter
		(
			variable mem : out memory_array;
			variable xin: integer range 1 to 640;
			variable yin: integer range 1 to 480;
			variable c: character
		) is	
	begin
		if c = 'I' then
			mem(xin+0,yin+2) := "11111111";
			mem(xin+0,yin+3) := "11111111";
			mem(xin+0,yin+4) := "11111111";
			mem(xin+0,yin+5) := "11111111";
			mem(xin+0,yin+6) := "11111111";
		elsif c = 'A' then
			mem(xin+0,yin+2) := "11111111";
			mem(xin+1,yin+2) := "11111111";
			mem(xin+2,yin+2) := "11111111";
			mem(xin+3,yin+2) := "11111111";
			mem(xin+4,yin+2) := "11111111";
			mem(xin+4,yin+3) := "11111111";
			mem(xin+4,yin+4) := "11111111";
			mem(xin+4,yin+5) := "11111111";
			mem(xin+4,yin+6) := "11111111";
			mem(xin+3,yin+6) := "11111111";
			mem(xin+2,yin+6) := "11111111";
			mem(xin+1,yin+6) := "11111111";
			mem(xin+0,yin+6) := "11111111";
			mem(xin+0,yin+5) := "11111111";
			mem(xin+0,yin+4) := "11111111";
			mem(xin+1,yin+4) := "11111111";
			mem(xin+2,yin+4) := "11111111";
			mem(xin+3,yin+4) := "11111111";
		end if;
		mem(1,1) := "11100000";
		mem(2,2) := "11100000";
		mem(3,3) := "11100000";
	end letter;
 
end samuirai;
