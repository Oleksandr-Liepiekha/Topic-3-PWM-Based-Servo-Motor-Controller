library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.round;

entity servo is
    generic (
        clk_hz : integer := 100e6;  -- Clock frequency in Hz (100 MHz)
        pulse_us : integer := 1500;    -- Pulse duration in mikroseconds (default: middle position)
        period_us : integer := 20000;  -- PWM period in mikroseconds
        step_count : integer := 180  -- Number of steps
    );
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        position : in integer range 0 to 180;
        PWM : out STD_LOGIC
    );
end servo;

architecture Behavioral of servo is

    constant min_count : integer := 700;    -- 1 ms
    constant max_count : integer := 2300;    -- 2 ms
    constant min_max_range_ms : integer := max_count - min_count;     
    constant step_us : integer := min_max_range_ms / step_count;     -- amount of time for a one step
   
    signal counter_ns : integer range 0 to 100;
    signal counter_us : integer range 0 to period_us;
    
  
    signal duty_cycle : integer range 0 to max_count;

begin

    COUNTER_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
        
            if RST = '1' then
                counter_us <= 0;
                counter_ns <= 0;
            else
            
                if counter_us < period_us - 1 then
                
                    counter_ns <= counter_ns + 1;
                    
                    if counter_ns = 99 then
                        counter_us <= counter_us + 1;
                        counter_ns <= 0;
                    end if;
                    
                else
                    counter_us <= 0;
                    counter_ns <= 0;
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
                if counter_us < duty_cycle then
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
                duty_cycle <= position * step_us + min_count;
            end if;
        end if;
    end process;

    

end Behavioral;


