----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2024 03:06:50 PM
-- Design Name: 
-- Module Name: lfsr - Behavioral
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

entity lfsr is
    generic (
        NBIT : integer := 4
    );
    Port ( clk :            in STD_LOGIC;
           en :             in STD_LOGIC;
           load_enable :    in STD_LOGIC;
           load_data :      in STD_LOGIC_VECTOR (NBIT-1 downto 0);
           done:            out std_logic;
           count :          out STD_LOGIC_VECTOR (NBIT-1 downto 0));
end lfsr;

architecture Behavioral of lfsr is

    signal sig_reg: std_logic_vector(NBIT-1 downto 0);
    signal sig_feedback: std_logic;

begin

    process (clk)
    begin
        if rising_edge(clk)then
            if load_enable = '1' then
                sig_reg <= load_data;
            elsif en = '1' then
                sig_reg <= sig_reg(NBIT-2 downto 0) & sig_feedback;
            end if;
        end if;
    end process;
    
    nbit3 : if NBIT = 3 generate
        sig_feedback <= sig_reg(2) xnor sig_reg(1);
    end generate nbit3;
    
    nbit4 : if NBIT = 4 generate
        sig_feedback <= sig_reg(3) xnor sig_reg(2);
    end generate nbit4;
    
    nbit5 : if NBIT = 5 generate
        sig_feedback <= sig_reg(4) xnor sig_reg(2);
    end generate nbit5;
    
   --sig_feedback <= sig_reg(3) xnor sig_reg(2);
    
    done <= '1' when sig_reg = load_data else '0';
    
    count <= sig_reg;

end Behavioral;
