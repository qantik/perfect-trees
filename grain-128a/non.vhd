library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity non is
    port (x0, x1, x2, x3, x4, x5, x6, x7, x8, x9      : in std_logic;
          x10, x11, x12, x13, x14, x15, x16, x17, x18 : in std_logic;
          x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 : in std_logic;
          l                                           : in std_logic;
          --f                                           : in std_logic;
          y                                           : out std_logic);
end entity non;

architecture parallel of non is
begin

    y <= x0 xor x1 xor x2 xor x3 xor x4 xor (x5 and x6) xor (x7 and x8) xor
	 (x9 and x10) xor (x11 and x12) xor (x13 and x14) xor (x15 and x16) xor (x17 and x18) xor l xor
	 (x19 and x20 and x21) xor (x22 and x23 and x24) xor (x25 and x26 and x27 and x28);

end architecture parallel;
