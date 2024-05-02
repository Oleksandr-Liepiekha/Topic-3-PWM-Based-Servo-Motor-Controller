# Topic 3: PWM-Based Servo Motor Controller

____
__Team members:__
 * Oleksandr Liepiekha (responsible for : Servo, top level , nexys-a7-50T , display active)
 * Dominik Choutka (responsible for: bin2seg, display active, top level )
 * Ivan Hinak (responsible for: BinaryToReal , Number_Spliter , Servo , README)
  

  ## Instructions
  * Short video with instructions : https://www.linkedin.com/posts/ivan-hinak-72a272251_first-vhdl-project-sorvo-motor-controller-activity-7191750905937944576-UdD5?utm_source=share&utm_medium=member_android
    
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

# How it works (Software desctiption)
 ___
 

### Top level overview
![top level](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/top_level.png?raw=true)

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
* After which we divide our number into 'hundreds','tens' and'ones' in the files: "Number_Splitter.vhd"
 ````vhdl
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
 * Then it goes through "display_active.vhd" to distribute each digit to the approriate display
  ``````vhdl
 ...
 case display_index is
        when 0 =>
            AN <= b"11111110";
            number_out <= ones_right;
 ...
        when others =>
            AN <= b"11111111";
            number_out <= 0;
    end case; 
  ``````
 * And finaly we go through "bin2seg.vhd" to display each number in 7 segments.
  ``````vhdl
 p_7seg_decoder : process (bin, clear) is
begin

  if (clear = '1') then
    seg <= "1111111";  -- Clear the display
  else

    case bin is
      when 0 =>
        seg <= "0000001";
...
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
The main simulation is to check our signal that will go directly to the Servo Motor, as we described earlier 'position' comes from outside with a number from 0 to 180 and because of this the pulse width should change from 1ms to 2ms 
````vhdl
stimuli : process
    begin
       ...
        position <= 0;
        wait for 20ms;

        position <= 20;
        wait for 20ms;
       ...
        position <= 60;
        wait for 20ms;
       ...
        position <= 180;
        wait for 20ms;
        
        wait;
    end process;
````
At 0 the pulse width should be 1ms, at 20≈1.1ms, at 60≈1.35ms, at 180≈2ms , but but as you will see we mentioned above because incorrectness of spare parts, the real angle will always be less than the given one, and therefore we have increased the ratio of the pulse width to the given angle and at maximum values ​​the pulse can even be wider than 2ms
And below the simulation demonstrates to us that our idea and assumptions work↓

![0](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/0.png?raw=true)

![20](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/20.png?raw=true)

![60](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/60.png?raw=true)

![180](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/180.png?raw=true)

-----

 # References
* VHDLwhiz: https://vhdlwhiz.com/product/vhdl-rc-servo-controller-using-pwm/
* Data sheet:http://www.ee.ic.ac.uk/pcheung/teaching/DE1_EE/stores/sg90_datasheet.pdf
  

