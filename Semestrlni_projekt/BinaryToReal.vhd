library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryToReal is
    port (
        binary_input : in std_logic_vector(7 downto 0);
        integer_output : out integer range 0 to 180
    );
end entity BinaryToReal;

architecture Behavioral of BinaryToReal is
begin
    process (binary_input)
    begin
        integer_output <= to_integer(unsigned(binary_input));
    end process;
end architecture Behavioral;
