----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2024 04:09:15 PM
-- Design Name: 
-- Module Name: clock_enable - Behavioral
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


library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all; -- Package for arithmetic operations with std_logic_vector
    use ieee.math_real.all; -- To calculate the number of bits needed to represent an integer

entity clock_enable is
    generic (
        PERIOD : integer := 6
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end clock_enable;

architecture Behavioral of clock_enable is

    constant bits_needed : integer := integer(ceil(log2(real(PERIOD + 1))));

    signal sig_count : std_logic_vector(bits_needed - 1 downto 0);

begin
    --! Generate clock enable signal. By default, enable signal
    --! is low and generated pulse is always one clock long.
    p_clk_enable : process (clk) is
    begin

        -- Synchronous proces
        if (rising_edge(clk)) then
            -- if high-active reset then
            if(rst = '1') then               
                -- Clear all bits of local counter
                sig_count <= (others => '0');
                -- Set output `pulse` to low
                pulse <= '0';
                
            -- elsif sig_count is PERIOD-1 then
            elsif (sig_count = PERIOD-1) then
                -- Clear all bits of local counter
                sig_count <= (others => '0');
                -- Set output `pulse` to high
                pulse <= '1';

            -- else
            else
                -- Increment local counter
                sig_count <= sig_count + 1;
                -- Set output `pulse` to low
                pulse <= '0';

            -- Each `if` must end by `end if`
            end if;
        end if;

    end process p_clk_enable;

end architecture behavioral;
