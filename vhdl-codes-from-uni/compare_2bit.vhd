----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2024 03:32:59 PM
-- Design Name: 
-- Module Name: compare_2bit - Behavioral
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

entity compare_2bit is
    Port ( a : in STD_LOGIC_VECTOR (15 downto 0);
           b : in STD_LOGIC_VECTOR (15 downto 0);
           b_greater : out STD_LOGIC;
           b_a_equal : out STD_LOGIC;
           a_greater : out STD_LOGIC);
end compare_2bit;

architecture Behavioral of compare_2bit is

begin

    b_greater <= (b(1) and not a(1)) or 
                 (b(0) and not a(0) and not a(1)) or   
                 (b(1) and b(0) and not a(0));

    b_a_equal <= '1' when (b = a) 
                     else '0';

    a_greater <= '1' when (b < a)
                     else '0';
    
end Behavioral;
