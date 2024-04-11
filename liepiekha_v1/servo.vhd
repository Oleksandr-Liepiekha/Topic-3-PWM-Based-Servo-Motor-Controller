library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.round;

entity servo is
    generic (
        clk_hz : real := 100.0e6;  -- Clock frequency in Hz (100 MHz)
        pulse_ms : real := 1.5;    -- Pulse duration in milliseconds (default: middle position)
        period_ms : real := 20.0;  -- PWM period in milliseconds
        step_count : positive := 180  -- Number of steps
    );
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        position : in integer range 0 to step_count - 1;
        PWM : out STD_LOGIC
    );
end servo;

architecture Behavioral of servo is

    function cycles_per_ms (ms_count : real) return integer is
    begin
        return integer(round(clk_hz / 1.0e3 * ms_count));
    end function;

    constant min_count : integer := cycles_per_ms(1.0);    -- 1 ms
    constant max_count : integer := cycles_per_ms(2.0);    -- 2 ms
    constant min_max_range_ms : real := 2.0 - 1.0;         -- 1 ms to 2 ms
    constant step_ms : real := min_max_range_ms / real(step_count);
    constant cycles_per_step : positive := cycles_per_ms(step_ms);

    constant counter_max : integer := integer(round(clk_hz * period_ms / 1.0e3)) - 1;
    signal counter : integer range 0 to counter_max;
  
    signal duty_cycle : integer range 0 to max_count;

begin

    COUNTER_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                counter <= 0;
            else
                if counter < counter_max then
                    counter <= counter + 1;
                else
                    counter <= 0;
                end if;
            end if;
        end if;
    end process;

    PWM_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                PWM <= '0';
            else
                PWM <= '0';
                if counter < duty_cycle then
                    PWM <= '1';
                end if;
            end if;
        end if;
    end process;

    DUTY_CYCLE_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                duty_cycle <= min_count;
            else
                duty_cycle <= 10 * position * cycles_per_step + min_count;
            end if;
        end if;
    end process;

    

end Behavioral;
