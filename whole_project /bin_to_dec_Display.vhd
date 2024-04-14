library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BinaryToDecimalDisplay is
    port (
        binary_input : in std_logic_vector(7 downto 0); -- Binary input, assuming 8-bit input
        anodes : out std_logic_vector(2 downto 0);     -- Anodes of 7-segment displays
        segments : out std_logic_vector(6 downto 0)    -- Segments of 7-segment displays
    );
end entity BinaryToDecimalDisplay;

architecture Behavioral of BinaryToDecimalDisplay is
    signal decimal_output : integer range 0 to 999;   -- Decimal output (0 to 999)
    signal bcd_output : std_logic_vector(11 downto 0);-- BCD output (12-bit BCD representation)

    -- BCD to 7-segment decoder
    constant bcd_to_7seg : array(0 to 9) of std_logic_vector(6 downto 0) :=
        ("0000001",  -- 0
         "1001111",  -- 1
         "0010010",  -- 2
         "0000110",  -- 3
         "1001100",  -- 4
         "0100100",  -- 5
         "0100000",  -- 6
         "0001111",  -- 7
         "0000000",  -- 8
         "0000100"); -- 9

    -- Binary to BCD conversion process
    function binary_to_bcd(bin : integer) return std_logic_vector is
        variable bcd : std_logic_vector(11 downto 0) := (others => '0');
    begin
        for i in 0 to 11 loop
            bcd(i) := std_logic(to_integer(unsigned(bin)) mod 10);
            bin := bin / 10;
        end loop;
        return bcd;
    end function;

begin
    -- Convert binary input to decimal
    decimal_output <= to_integer(unsigned(binary_input));

    -- Convert decimal output to BCD
    bcd_output <= binary_to_bcd(decimal_output);

    -- Output BCD values to 7-segment displays
    process(bcd_output)
    begin
        case bcd_output(11 downto 8) is
            when "0000" =>
                segments <= bcd_to_7seg(to_integer(unsigned(bcd_output(3 downto 0))));
                anodes <= "111"; -- Display first digit
            when "0001" =>
                segments <= bcd_to_7seg(to_integer(unsigned(bcd_output(7 downto 4))));
                anodes <= "110"; -- Display second digit
            when "0010" =>
                segments <= bcd_to_7seg(to_integer(unsigned(bcd_output(11 downto 8))));
                anodes <= "101"; -- Display third digit
            when others =>
                segments <= (others => '1'); -- Turn off segments if invalid BCD
                anodes <= "000"; -- Turn off all displays
        end case;
    end process;

end architecture Behavioral;
