library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity h is
    port (x0, x1, x2, x3, x4, x5, x6, x7, x8 : in std_logic;
          b0, b1, b2, b3, b4, b5, b6         : in std_logic;
          s                                  : in std_logic;
          y                                  : out std_logic);
end entity h;

architecture parallel of h is
begin

    y <= (x0 and x1) xor (x2 and x3) xor (x4 and x5) xor (x6 and x7) xor (x0 and x4 and x8) xor
	 b0 xor b1 xor b2 xor b3 xor b4 xor b5 xor b6 xor s;

end architecture parallel;
