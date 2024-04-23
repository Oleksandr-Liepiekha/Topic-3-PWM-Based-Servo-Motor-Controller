# Topic 3: PWM-Based Servo Motor Controller

____
__Team members:__
 * Oleksandr Liepiekha (responsible for : Servo, top level , nexys-a7-50T , display active)
 * Dominik Choutka (responsible for: bin2seg, display active, top level )
 * Ivan Hinak (responsible for: BinaryToReal , Number_Spliter , Servo , README)
  

  ## Instructions
  The main idea of the project is that the 2x8 switches on the board (Nexys A7-50T) represent bits of a binary number. 
  After which, the numbers are converted to decimal (this decimal number represents the degrees by which our Servo Motor will rotate) and displayed on the display.
  
  For example:(11001000 = 200) or (01100100 = 100)

![example](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/example%20of%20display.png?raw=true)


  
   Ideally, our servo motor can rotate from 0 to 180 degrees, but due to the imperfection of the components, the number that we will set using our switches will always be about a little more than the value of the angle by which our Servo Motor will rotate
 
 ![0-180 degrees](https://cdn-learn.adafruit.com/assets/assets/000/055/650/medium800/robotics___cnc_servo-pic_angle.png?1529422893)
 
 
# Theoretical description 
---
The main task for the implementation of this project is the goal: to master the pulse width of the output signal "PWM"
Because the motor can rotate from 0 to 180 degrees and this angle is determined by the pulse width from 1ms to 2ms, and the whole signal period should be 20ms, below is an example of how the angle depends on the pulse widthЖ

![pulse to angle](https://i.pinimg.com/736x/88/97/00/8897000102a5bcdba57a00f03fe40117.jpg)

# How it works ( Hardware desctiption)
 ___
* Let's start with the fact that our binary number goes to the file "BinaryToReal.vhd" where it is converted to decimal .
  ``````vhdl
  entity BinaryToReal is
    port (
        binary_input : in std_logic_vector(7 downto 0);
        integer_output : out integer range 0 to 180
    );
end entity BinaryToReal;

...

process (binary_input)
    begin
        integer_output <= to_integer(unsigned(binary_input)); --The main line
    end process;

  ``````
* After which it is displayed on our displays using the files: "Number_Splitter.vhd"
````
entity Number_Splitter is
    Port ( number_in : in  INTEGER range 0 to 180;
           ones_out : out INTEGER range 0 to 9;
           tens_out : out INTEGER range 0 to 9;
           hundreds_out : out INTEGER range 0 to 1);
end Number_Splitter;

architecture Behavioral of Number_Splitter is
begin
    process(number_in)
    begin
        hundreds_out <= number_in / 100; --Definition of number displaying hundreds
        tens_out <= (number_in mod 100) / 10;Definition of number displaying tens
        ones_out <= (number_in mod 100) mod 10;Definition of number displaying ones
    end process;
````
 Then it goes through "display_active.vhd"
 ``````
 ...
 case display_index is
        when 0 =>
            AN <= b"11111110";
            number_out <= ones_right;
        when 1 =>          
            AN <= b"11111101";
            number_out <= tens_right;
        when 2 =>
            AN <= b"11111011";
            number_out <= hundrets_right;
        when 3 =>
            AN <= b"11101111";
            number_out <= ones_left;
        when 4 =>
            AN <= b"11011111";
            number_out <= tens_left;
        when 5 =>
            AN <= b"10111111";
            number_out <= hundrets_left;
        when others =>
            AN <= b"11111111";
            number_out <= 0;
    end case; 
 ``````
 And finaly through "bin2seg.vhd" .
 ``````
 p_7seg_decoder : process (bin, clear) is
begin

  if (clear = '1') then
    seg <= "1111111";  -- Clear the display
  else

    case bin is
      when 0 =>
        seg <= "0000001";
      when 1 =>
        seg <= "1001111";
      when 2 =>
        seg <= "0010010";
      when 3 =>
        seg <= "0000110";
      when 4 =>
        seg <= "1001100";
      when 5 =>
        seg <= "0100100";
      when 6 =>
        seg <= "0100000";
      when 7 =>
        seg <= "0001111";
      when 8 =>
        seg <= "0000000";
      when 9 =>
        seg <= "0000100";
    end case;

  end if;    
end process p_7seg_decoder;
 ``````

  And also this decimal number is sent to the most important file "servo.vhd" that controls the output signal to our Servo Motor
  
* In the main file we call "servo.vhd" we take the value for the variable "position" which displays the angle of rotation of our servo motor, and then we define a function for "duty_cycle" which adjusts the pulse width of our signal

``````vhdl 

entity servo is

    ...

    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        position : in integer range 0 to 180; --Input numer of angle
        PWM : out STD_LOGIC
    );
end servo;

...

 DUTY_CYCLE_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                duty_cycle <= min_count;
            else
                duty_cycle <= position * step_us + min_count; --The main function
            end if;
        end if;
    end process;

``````
# Simulations
----

-----
### Top level overview
![top level](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/top_level.png?raw=true)
 
 # References

