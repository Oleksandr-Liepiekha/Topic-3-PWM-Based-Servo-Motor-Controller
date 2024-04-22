----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2024 03:19:04 PM
-- Design Name: 
-- Module Name: bin2seg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2seg is
    Port ( clear : in STD_LOGIC;
           bin : in integer range 0 to 9;
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end bin2seg;

architecture Behavioral of bin2seg is

begin

p_7seg_decoder : process (bin, clear) is
begin

  if (clear = '1') then
    seg <= "1111111";  -- Clear the display
  else

    case bin is
      when 0 =>
        seg <= "0000001";
      when 1 =>
        seg <= "1001111";
      when 2 =>
        seg <= "0010010";
      when 3 =>
        seg <= "0000110";
      when 4 =>
        seg <= "1001100";
      when 5 =>
        seg <= "0100100";
      when 6 =>
        seg <= "0100000";
      when 7 =>
        seg <= "0001111";
      when 8 =>
        seg <= "0000000";
      when 9 =>
        seg <= "0000100";
    end case;

  end if;    
end process p_7seg_decoder;

end Behavioral;
