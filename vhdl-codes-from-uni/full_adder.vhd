----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2024 03:09:57 PM
-- Design Name: 
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    Port ( c_in : in STD_LOGIC;
           b : in STD_LOGIC;
           a : in STD_LOGIC;
           c_out : out STD_LOGIC;
           sum : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is

begin

    sum <= (a xor b) xor c_in;
    c_out <= (a and b) or (c_in and (a xor b));

end Behavioral;
