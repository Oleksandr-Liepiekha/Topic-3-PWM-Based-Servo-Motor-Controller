library ieee;
use ieee.std_logic_1164.all;

entity tb_servo is
end tb_servo;

architecture tb of tb_servo is

    component servo
        generic (clk_hz : real;
                 pulse_hz : real;
                 min_pulse_us : real;
                 max_pulse_us : real;
                 step_count : positive
        );   
        port (CLK      : in std_logic;
              RST      : in std_logic;
              position : in integer;
              PWM      : out std_logic);
    end component;
    
    constant clk_hz : real := 1.0e6;
   
    
    constant pulse_hz : real := 50.0;
    
    constant min_pulse_us : real := 1000.0;
    constant max_pulse_us : real := 2000.0;
    constant step_count : positive := 5;

    signal CLK      : std_logic := '1';
    signal RST      : std_logic := '1';
    signal position : integer range 0 to step_count - 1;
    signal PWM      : std_logic;

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    


begin

    dut : servo
    generic map (clk_hz => clk_hz,
                 pulse_hz => pulse_hz,
                 min_pulse_us => min_pulse_us,
                 max_pulse_us => max_pulse_us,
                 step_count => step_count
    )
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
        wait for 10 * TbPeriod;
        rst <= '0';
        
        wait for 10 * TbPeriod;
  
        for i in 0 to step_count - 1 loop
          position <= i;
          wait for 15 * TbPeriod;
         end loop;
  
  report "Simulation done. Check waveform.";
  
        
        
       -- position <= ;

        -- Reset generation
        -- EDIT: Check that RST is really your reset signal
       -- RST <= '1';
       -- wait for 100 ns;
       -- RST <= '0';
       -- wait for 100 ns;

        -- EDIT Add stimuli here
       -- wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
      --  TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_servo of tb_servo is
    for tb
    end for;
end cfg_tb_servo;