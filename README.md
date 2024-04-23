# Topic 3: PWM-Based Servo Motor Controller

____
__Developers:__
 * Oleksandr Liepiekha
 * Dominik Choutka
 * Ivan Hinak
  

  ## Usage 
  The main idea of the project is that the 2x8 switches on the board (Nexys A7-50T) represent bits of a binary number. 
  After which, the numbers are converted to decimal (this decimal number represents the degrees by which our Servo Motor will rotate) and displayed on the display.
  
  For example:(11001000 = 200) or (01100100 = 100)

![example](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/example%20of%20display.png?raw=true)


  
   Ideally, our servo motor can rotate from 0 to 180 degrees, but due to the imperfection of the components, the number that we will set using our switches will always be about a little more than the value of the angle by which our Servo Motor will rotate
 
 ![0-180 degrees](https://cdn-learn.adafruit.com/assets/assets/000/055/650/medium800/robotics___cnc_servo-pic_angle.png?1529422893)
 ___
 # How it works
* Let's start with the fact that our binary number goes to the file "BinaryToReal.vhd" where it is converted to decimal .After which it is displayed on our displays using the files: "Number_Splitter.vhd", "bin2seg.vhd" and "display_active.vhd" .
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
An example of how the pulse width of the output signal affects the rotation angle:

![pulse to angle](https://i.pinimg.com/736x/88/97/00/8897000102a5bcdba57a00f03fe40117.jpg)
-----
### Top level overview
![top level](https://github.com/Oleksandr-Liepiekha/Topic-3-PWM-Based-Servo-Motor-Controller/blob/main/inital%20sources/top_level.png?raw=true)
 
