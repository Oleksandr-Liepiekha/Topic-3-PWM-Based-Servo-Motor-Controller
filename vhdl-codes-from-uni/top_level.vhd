

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( BTND : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (3 downto 0);
           CLK100MHZ : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           LED : out STD_LOGIC_VECTOR (3 downto 0);
           LED16_B : out STD_LOGIC;
           LED_LOAD : out STD_LOGIC_VECTOR (3 downto 0));
end top_level;

architecture behavioral of top_level is

    -- Component declaration for clock enable
component clock_enable
    generic (
        PERIOD : integer
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           pulse : out STD_LOGIC);
end component;

    -- Component declaration for LFSR counter
component lfsr
    generic (
        NBIT : integer
    );
    Port ( clk :            in STD_LOGIC;
           en :             in STD_LOGIC;
           load_enable :    in STD_LOGIC;
           load_data :      in STD_LOGIC_VECTOR (NBIT-1 downto 0);
           done:            out std_logic;
           count :          out STD_LOGIC_VECTOR (NBIT-1 downto 0));
end component;

    -- Component declaration for bin2seg
component bin2seg
    Port ( clear : in STD_LOGIC;
           bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;
   
    -- Local signals for a counter: 4-bit @ 500 ms
    signal sig_en_500ms : std_logic;
    signal sig_count : std_logic_vector(3 downto 0);

begin

    -- Component instantiation of clock enable for 500 ms
    clock_en : clock_enable
    generic map(
        PERIOD => 50000000
    )
    Port map(      
           clk => CLK100MHZ,
           rst => BTNC,
           pulse => sig_en_500ms
    );

    -- Component instantiation of 4-bit LFSR counter
    lfsr_en : lfsr
    generic map(
        NBIT => 4
    )
    Port map( 
        clk =>           CLK100MHZ,
        en =>            sig_en_500ms,
        load_enable =>   BTND,
        load_data =>     SW,
        done    =>       LED16_B,          
        count =>         sig_count
    );

    -- Component instantiation of bin2seg
    bin2seg_en : bin2seg
    Port map( 
        clear => BTNC,
        bin => sig_count,
        seg(6) => CA,
        seg(5) => CB,
        seg(4) => CC,
        seg(3) => CD,
        seg(2) => CE,
        seg(1) => CF,
        seg(0) => CG
    );

    -- Turn off decimal point

    DP <= '1';

    -- Set display position
    
    AN <= b"11111110";

    -- Set output LEDs (green)
    
    LED_LOAD <= SW;

end architecture behavioral;
