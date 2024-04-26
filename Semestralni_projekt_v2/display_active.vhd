
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

entity display_active is
    Generic(
           PERIOD : integer := 500
    );
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           ones_right : in integer range 0 to 9;
           tens_right : in integer range 0 to 9;
           hundrets_right : in integer range 0 to 1;
           ones_left : in integer range 0 to 9;
           tens_left : in integer range 0 to 9;
           hundrets_left : in integer range 0 to 1;
           number_out : out integer;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end display_active;

architecture Behavioral of display_active is

signal display_index : integer range 0 to 5;
signal period_index : integer range 0 to PERIOD;

begin

    simple_counter : process(CLK)
    begin
        if rising_edge(CLK) then
        
            if RST = '1' then
                display_index <= 0;
                period_index <= 0;
            else 
                if display_index < 6 then   
                    period_index <= period_index + 1;     
                    if period_index = PERIOD-1 then
                        display_index <= display_index + 1;
                        period_index <= 0;
                    end if;           
                else
                    period_index <= 0;
                    display_index <= 0;
                end if;
                
            end if;
        end if;
        
     case display_index is
        when 0 =>
            AN <= b"11111110";
            number_out <= ones_right;
        when 1 =>          
            AN <= b"11111101";
            number_out <= tens_right;
        when 2 =>
            AN <= b"11111011";
            number_out <= hundrets_right;
        when 3 =>
            AN <= b"11101111";
            number_out <= ones_left;
        when 4 =>
            AN <= b"11011111";
            number_out <= tens_left;
        when 5 =>
            AN <= b"10111111";
            number_out <= hundrets_left;
        when others =>
            AN <= b"11111111";
            number_out <= 0;
    end case;
        
    end process;

end Behavioral;
