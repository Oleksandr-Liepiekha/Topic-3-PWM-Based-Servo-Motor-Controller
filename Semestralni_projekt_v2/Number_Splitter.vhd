library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Number_Splitter is
    Port ( number_in : in  INTEGER range 0 to 180;
           ones_out : out INTEGER range 0 to 9;
           tens_out : out INTEGER range 0 to 9;
           hundreds_out : out INTEGER range 0 to 1);
end Number_Splitter;

architecture Behavioral of Number_Splitter is
begin
    process(number_in)
    begin
        hundreds_out <= number_in / 100;
        tens_out <= (number_in mod 100) / 10;
        ones_out <= (number_in mod 100) mod 10;
    end process;
end Behavioral;
