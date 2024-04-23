library ieee;
use ieee.std_logic_1164.all;

entity tb_servo is
end tb_servo;

architecture tb of tb_servo is

    component servo
        port (CLK      : in std_logic;
              RST      : in std_logic;
              position : in integer;
              PWM      : out std_logic);
    end component;

    signal CLK      : std_logic;
    signal RST      : std_logic;
    signal position : integer;
    signal PWM      : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : servo
    port map (CLK      => CLK,
              RST      => RST,
              position => position,
              PWM      => PWM);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        position <= 0;

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;
        
        position <= 0;
        wait for 20ms;
        position <= 20;
        wait for 20ms;
        position <= 40;
        wait for 20ms;
        position <= 60;
        wait for 20ms;
        position <= 80;
        wait for 20ms;
        position <= 90;
        wait for 20ms;
        position <= 100;
        wait for 20ms;
        position <= 120;
        wait for 20ms;
        position <= 160;
        wait for 20ms;
        position <= 180;
        wait for 20ms;
        
        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_servo of tb_servo is
    for tb
    end for;
end cfg_tb_servo;
