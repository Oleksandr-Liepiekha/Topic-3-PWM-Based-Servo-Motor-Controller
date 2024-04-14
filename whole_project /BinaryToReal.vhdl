library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryToReal is
    port (
        binary_input : in std_logic_vector(31 downto 0);
        real_output : out real
    );
end entity BinaryToReal;

architecture Behavioral of BinaryToReal is
begin
    process (binary_input)
    begin
        -- Convert binary input to real
        real_output <= real(to_integer(signed(binary_input))) / 100.0; -- Adjust scale as needed
    end process;
end architecture Behavioral;
