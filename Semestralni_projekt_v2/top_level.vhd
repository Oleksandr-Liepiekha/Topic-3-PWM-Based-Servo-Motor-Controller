

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW_right : in STD_LOGIC_VECTOR (7 downto 0);
           SW_left : in STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);      
           JB : out STD_LOGIC;
           JC : out STD_LOGIC); 
end top_level;

architecture Behavioral of top_level is

component servo
    generic (
        clk_hz : integer := 100e6;  -- Clock frequency in Hz (100 MHz)
        pulse_us : integer := 1500;    -- Pulse duration in mikroseconds (default: middle position)
        period_us : integer := 20000;  -- PWM period in mikroseconds
        step_count : integer := 180  -- Number of steps
    );
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        position : in integer range 0 to step_count;
        PWM : out STD_LOGIC
    );
end component;

component BinaryToReal
    port (
        binary_input : in std_logic_vector(7 downto 0);
        integer_output : out integer range 0 to 180
    );
end component;

component Number_Splitter
    port (
        number_in : in  INTEGER range 0 to 180;
        ones_out : out INTEGER range 0 to 9;
        tens_out : out INTEGER range 0 to 9;
        hundreds_out : out INTEGER range 0 to 1
    );
end component;

component bin2seg
    port (
        clear : in STD_LOGIC;
        bin : in integer range 0 to 9;
        seg : out STD_LOGIC_VECTOR (6 downto 0)
    );
end component;

component display_active
   Generic(
           PERIOD : integer := 500
    );
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           ones_right : in integer range 0 to 9;
           tens_right : in integer range 0 to 9;
           hundrets_right : in integer range 0 to 2;
           ones_left : in integer range 0 to 9;
           tens_left : in integer range 0 to 9;
           hundrets_left : in integer range 0 to 2;
           number_out : out integer;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end component;

signal position_by_sw_right : integer range 0 to 180;
signal ones_out_right : integer range 0 to 9;
signal tens_out_right : integer range 0 to 9;
signal hundrets_out_right : integer range 0 to 1;

signal position_by_sw_left : integer range 0 to 180;
signal ones_out_left : integer range 0 to 9;
signal tens_out_left : integer range 0 to 9;
signal hundrets_out_left : integer range 0 to 1;

signal number_out : integer;

begin

servo_right : servo
generic map (
   clk_hz => 100e6,  -- Clock frequency in Hz (100 MHz)
   pulse_us => 1500,    -- Pulse duration in mikroseconds (default: middle position)
   period_us => 20000,  -- PWM period in mikroseconds
   step_count => 180  -- Number of steps
)
port map (
   CLK => CLK100MHZ,
   RST => BTNC,
   position => position_by_sw_right,
   PWM => JB
);   

servo_left : servo
generic map (
   clk_hz => 100e6,  -- Clock frequency in Hz (100 MHz)
   pulse_us => 1500,    -- Pulse duration in mikroseconds (default: middle position)
   period_us => 20000,  -- PWM period in mikroseconds
   step_count => 180  -- Number of steps
)
port map (
   CLK => CLK100MHZ,
   RST => BTNC,
   position => position_by_sw_left,
   PWM => JC
); 

BinaryToReal_right : BinaryToReal
port map (
    binary_input => SW_right,
    integer_output => position_by_sw_right
);

BinaryToReal_left : BinaryToReal
port map (
    binary_input => SW_left,
    integer_output => position_by_sw_left
);

Number_Splitter_right : Number_Splitter
port map (
    number_in => position_by_sw_right,
    ones_out => ones_out_right,
    tens_out => tens_out_right,
    hundreds_out => hundrets_out_right
);

Number_Splitter_left : Number_Splitter
port map (
    number_in => position_by_sw_left,
    ones_out => ones_out_left,
    tens_out => tens_out_left,
    hundreds_out => hundrets_out_left
);

display_active_en : display_active
port map (
    CLK => CLK100MHZ,
    RST => BTNC,
    ones_right => ones_out_right, 
    tens_right => tens_out_right,
    hundrets_right => hundrets_out_right,
    ones_left => ones_out_left,
    tens_left => tens_out_left,
    hundrets_left => hundrets_out_left,
    number_out => number_out,
    AN => AN
);

bin2seg_en : bin2seg
port map (
    clear => BTNC,
    bin => number_out,
    seg(6) => CA,
    seg(5) => CB,
    seg(4) => CC,
    seg(3) => CD,
    seg(2) => CE,
    seg(1) => CF,
    seg(0) => CG  
);

DP <= '1';

end Behavioral;
