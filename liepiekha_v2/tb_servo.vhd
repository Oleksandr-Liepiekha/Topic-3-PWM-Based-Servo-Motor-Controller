library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity servo_tb is
end servo_tb;

architecture Behavioral of servo_tb is

    -- Component declaration for DUT (Device Under Test)
    component servo
        generic (
            clk_hz : real := 100.0e6;  -- Clock frequency in Hz (100 MHz)
            pulse_ms : real := 1.5;    -- Pulse duration in milliseconds (default: middle position)
            period_ms : real := 20.0;  -- PWM period in milliseconds
            step_count : real := 1000.0  -- Number of steps
        );
        Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            position : in real range 0.0 to step_count - 1.0;
            PWM : out STD_LOGIC
        );
    end component servo;

    -- Clock signal generation process
    signal CLK : STD_LOGIC := '0';
    constant PERIOD : time := 10 ns;  -- Clock period

    -- Constants for simulation parameters
    constant SIM_DURATION : time := 200 ms;  -- Simulation duration

    -- Signals for connecting DUT ports
    signal RST : STD_LOGIC;
    signal position : real range 0.0 to 180.0;  -- Assuming 1000 steps
    signal PWM : STD_LOGIC;

begin

    -- Instantiate the servo module (DUT)
    DUT: servo
        generic map (
            clk_hz => 100.0e6,  -- 100 MHz clock frequency
            pulse_ms => 1.5,    -- 1.5 ms pulse duration (neutral position)
            period_ms => 20.0,  -- 20 ms PWM period
            step_count => 1000.0  -- 1000 steps
        )
        port map (
            CLK => CLK,
            RST => RST,
            position => position,
            PWM => PWM
        );

    -- Clock generation process
    CLK_PROCESS: process
    begin
        while now < SIM_DURATION loop
            CLK <= '0';
            wait for PERIOD / 2;
            CLK <= '1';
            wait for PERIOD / 2;
        end loop;
        wait;
    end process CLK_PROCESS;

    -- Reset process
    RST_PROCESS: process
    begin
        RST <= '1';  -- Assert reset
        wait for 100 ns;  -- Wait for a short duration
        RST <= '0';  -- De-assert reset
        wait;
    end process RST_PROCESS;

    -- Stimulus process to change position
    STIMULUS: process
    begin
        -- Apply various positions for simulation
        --for i in 0 to 180 loop
        --    position <= i;
        --    wait for 20 ms;  -- Wait for 10 ms between position changes
        --end loop;
        --wait;
        
        position <= 0.0;
        wait for 19 ms;
        position <= 20.0;
        wait for 19 ms;
        position <= 40.0;
        wait for 19 ms;
        position <= 60.0;
        wait for 19 ms;
        position <= 80.0;
        wait for 19 ms;
        position <= 120.0;
        wait for 19 ms;
        position <= 140.0;
        wait for 19 ms;
        position <= 160.0;
        wait for 19 ms;
        position <= 180.0;
        wait for 19 ms;
        
    end process STIMULUS;

end Behavioral;
